//
//  ScoresTableViewController.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import UIKit

class ScoresTableViewController: UITableViewController {

    private let presenter: ScorePresenter = App.sharedInstance.request()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.nameInput = self
        presenter.scroesView = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
}

// MARK: - Table view data source
extension ScoresTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.records?.count ?? 0
    }
}

// MARK: - Table view delegate
extension ScoresTableViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("rankCell", forIndexPath: indexPath) as? ScoresTableViewCell else {
            fatalError("wrong cell given")
        }
        cell.rankLabel.text = "\(indexPath.row + 1)."
        cell.nameLabel.text = presenter.records![indexPath.row].name
        cell.pointsLabel.text = "\(presenter.records![indexPath.row].score)"
        
        cell.backgroundColor = UIColor.clearColor()
        
        return cell
    }
}

// MARK: - ScoresRepresentationView
extension ScoresTableViewController: ScoresRepresentationView {
    
    func reload() {
        tableView.reloadData()
    }
}

// MARK: - NameInputPresenter
extension ScoresTableViewController: NameInputRepresenter {
    
    func presentNameInput(with completion: (name: String) -> ()) {
        
        let alert = UIAlertController(title: "Please enter your name!", message: nil, preferredStyle: .Alert)
        
        let actionOk = UIAlertAction(title: "Ok", style: .Default) { (_) in
            guard let inputText = (alert.textFields![0] as UITextField).text where inputText != "" else { return }
            completion(name: inputText)
        }
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Name"
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification,
            object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                actionOk.enabled = textField.text != ""
            }
        }
        
        actionOk.enabled = false
        alert.addAction(actionOk)
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
