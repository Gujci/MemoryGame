//
//  GamePresenter.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import Foundation

// MARK: - Needed Protocols
protocol GameRepresentation {
    
    func resetGameArea()
    func hidePair(at indexes: [Int])
}

protocol GamePointRepresentation {
    
    func set(points: Int)
}

// MARK: - Presenter
final class GamePresenter {
    
    var representation: GameRepresentation?
    var pointCounter: GamePointRepresentation? {
        didSet {
            pointCounter?.set(points)
        }
    }
    var points: Int = 0 {
        didSet {
            pointCounter?.set(points)
        }
    }
    
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
                let scores: ScorePresenter = App.sharedInstance.request()
                scores.shouldAddNewUser(withPoints: points)
            }
        }
    }
}

// MARK: - Injectable
extension GamePresenter: Injectable {
    
    static var id: String { return "Game" }
    
    static func create() -> GamePresenter {
        return GamePresenter()
    }
}

// MARK: - TileDataSource
extension GamePresenter: TileDataSource {
    
    func imageName(forTag tag: Int?) -> String? {
        guard let index = tag where index < cards.count else { return nil }
        return cards[index]
    }
}

// MARK: - TileDelgate
extension GamePresenter: TileDelgate {
    
    func didChanged(to state: TileState, at tag: Int?) {
        guard state == .Color else { return }
        guard let index = tag where index < cards.count else { return }
        guard let prevousIndex = prevousIndexGuess else { return  prevousIndexGuess = index }
        
        if (cards[index] == cards[prevousIndex]) {
            
            representation?.hidePair(at: [prevousIndex, index])
            scoreCount += 1
            points += 2
        }
        else {
            points -= 1
        }
        
        prevousIndexGuess = nil
        representation?.resetGameArea()
    }
}
