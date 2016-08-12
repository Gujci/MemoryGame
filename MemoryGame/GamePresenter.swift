//
//  GamePresenter.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import Foundation

final class GamePresenter {
    
}

extension GamePresenter: Injectable {
    
    static var id: String { return "Game" }
    
    static func create() -> GamePresenter {
        return GamePresenter()
    }
}

extension GamePresenter: TileDataSource {
    
    func imageName(forTag tag: Int?) -> String? {
        return "colour6"
    }
}

extension GamePresenter: TileDelgate {
    
    func didChanged(to state: TileState, at tag: Int?) {
        
    }
}