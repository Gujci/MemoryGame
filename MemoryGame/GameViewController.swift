//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    @IBOutlet weak var gameAreaView: UIView!
    
    override func viewWillAppear(animated: Bool){
        super.viewWillAppear(animated)

        let presenter: GamePresenter = App.sharedInstance.new()
        presenter.representation = self
        
        gameAreaView.subviews.forEach() { view in
            view.hidden = false
        }
    }
}

// MARK: - GameRepresentation
extension GameViewController: GameRepresentation {
    
    func resetGameArea() {
        gameAreaView.subviews.forEach() { view in
            guard let tileView = view.subviews.first?.parentViewController as? TileViewController else { return }
            tileView.state = .Back
            
        }
        gameAreaView.userInteractionEnabled = false
        UIView.delay(0.5) { [weak self] in
            self?.gameAreaView.userInteractionEnabled = true
        }
    }
    
    func hidePair(at indexes: [Int]) {
        gameAreaView.subviews.forEach() { view in
            if indexes.indexOf(view.tag) != nil {
                view.hidden = true
            }
        }
    }
}
