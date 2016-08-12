//
//  HighScoreData.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import Foundation
import CoreData

struct HighScoreData {
    
    var name: String
    var score: Int
    
    init(with name: String, score: Int) {
        self.name = name
        self.score = score
    }
}

// MARK: - Storable
extension HighScoreData: Storable {
    
    static var entityName: String { return "HighScore" }
    
    func saveToEnity(inContext moc: NSManagedObjectContext, withManager storeManager: DataStore) throws -> HighScore {
        
        if let entity = NSEntityDescription.insertNewObjectForEntityForName(HighScoreData.entityName, inManagedObjectContext: moc) as? HighScore {
            entity.name = name
            entity.score = NSDecimalNumber(integer: score)
            
            return entity
        }
        else {
            throw DataStoreError.CouldNotSave
        }
    }
    
    init(with entity: HighScore) throws {
        name = entity.name ?? ""
        score = entity.score?.integerValue ?? 0
    }
}

// MARK: - Comparable
extension HighScoreData: Comparable { }

func ==(x: HighScoreData, y: HighScoreData) -> Bool { return x.score == y.score && x.name == y.name }
func <(x: HighScoreData, y: HighScoreData) -> Bool { return x.score > y.score }
