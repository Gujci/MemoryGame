//
//  MainViewController.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        App.sharedInstance.appNavigationDelehgate = self
    }
}

extension MainViewController: NavigationDelegate {
    
    func performNavigation(by segueId: String) {
        performSegueWithIdentifier(segueId, sender: self)
    }
}