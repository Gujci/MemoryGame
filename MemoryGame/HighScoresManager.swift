//
//  HighScoresManager.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import Foundation

final class HighScoresManager {
    
    private let storeManager: DataStore = App.sharedInstance.request()
    
    var highScoreRecords: [HighScoreData]? {
        return storeManager.getAllEntities()?.sort()
    }
}

extension HighScoresManager {
    
    func addNewRecord(with name: String, points: Int) {
        storeManager.saveObjectToStore(HighScoreData(with: name, score: points))
    }
}

// MARK: - Injectable
extension HighScoresManager: Injectable {
    
    static var id: String { return "highScores" }
    
    static func create() -> HighScoresManager {
        return HighScoresManager()
    }
}