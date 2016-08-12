//
//  MainViewController.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var pointsCountLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        App.sharedInstance.appNavigationDelehgate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let gamePresenter: GamePresenter = App.sharedInstance.request()
        gamePresenter.pointCounter = self
    }
}

// MARK: - NavigationDelegate
extension MainViewController: NavigationDelegate {
    
    func performNavigation(by segueId: String) {
        performSegueWithIdentifier(segueId, sender: self)
    }
}

extension MainViewController {
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        
    }
}

// MARK: - GamePointRepresentation
extension MainViewController: GamePointRepresentation {
    
    func set(points: Int) {
        pointsCountLabel.text = "\(points) Points"
    }
}
