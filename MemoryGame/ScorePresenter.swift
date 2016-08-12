//
//  ScorePresenter.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import Foundation

// MARK: - Needed protocols
protocol NameInputRepresenter {
    
    func presentNameInput(with completion: (name: String) -> ())
}

protocol ScoresRepresentationView {
    
    func reload()
}

// MARK: - Presenter
final class ScorePresenter {
    
    private let scoresManager: HighScoresManager = App.sharedInstance.request()
    
    var nameInput: NameInputRepresenter?
    var scroesView: ScoresRepresentationView?
    
    var records: [HighScoreData]? {
        return scoresManager.highScoreRecords
    }
}

extension ScorePresenter {
    
    func shouldAddNewUser(withPoints points: Int) {
        nameInput?.presentNameInput(with: { [weak self] (name) in
            self?.scoresManager.addNewRecord(with: name, points: points)
            self?.scroesView?.reload()
            })
    }
}

// MARK: - Injectable
extension ScorePresenter: Injectable {
    
    static var id: String { return "Scores" }
    
    static func create() -> ScorePresenter {
        return ScorePresenter()
    }
}
