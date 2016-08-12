//
//  GamePresenter.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import Foundation

protocol GameRepresentation {
    
    func resetGameArea()
    func hidePair(at indexes: [Int])
}

final class GamePresenter {
    
    var representation: GameRepresentation?
    
    lazy private var cards: [String] = {
        var returnValue: [String] = []
        (1...8).forEach() { i in
            returnValue.append("colour\(i)")
        }
        returnValue = returnValue + returnValue
        
        return returnValue.shuffle()
    }()
    
    private var prevousIndexGuess: Int?
    private var scoreCount = 0 {
        didSet {
            if scoreCount == 8 {
                App.sharedInstance.appNavigationDelehgate?.performNavigation(by: "showScores")
            }
        }
    }
}

extension GamePresenter: Injectable {
    
    static var id: String { return "Game" }
    
    static func create() -> GamePresenter {
        return GamePresenter()
    }
}

extension GamePresenter: TileDataSource {
    
    func imageName(forTag tag: Int?) -> String? {
        guard let index = tag where index < cards.count else { return nil }
        return cards[index]
    }
}

extension GamePresenter: TileDelgate {
    
    func didChanged(to state: TileState, at tag: Int?) {
        guard state == .Color else { return }
        guard let index = tag where index < cards.count else { return }
        guard let prevousIndex = prevousIndexGuess else { return  prevousIndexGuess = index }
        
        if (cards[index] == cards[prevousIndex]) {
            
            representation?.hidePair(at: [prevousIndex, index])
            scoreCount += 1
            //Increment points
        }
        else {
            //Decrement points
        }
        
        prevousIndexGuess = nil
        representation?.resetGameArea()
    }
}
