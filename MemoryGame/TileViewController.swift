//
//  TileViewController.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import UIKit

// MARK: - DataSource
protocol TileDataSource {
    func imageName(forTag tag: Int?) -> String?
}

// MARK: - Delegate
protocol TileDelgate {
    func didChanged(to state: TileState, at tag: Int?)
}

// MARK: - Tile State
enum TileState {
    case Back
    case Color
}

// MARK: - Tile State negation
prefix func !(left: TileState) -> TileState {
    switch left {
    case .Back:
        return .Color
    case .Color:
        return .Back
    }
}

// MARK: - Tile View Controller
class TileViewController: UIViewController {
    
    var tag: Int? { return view.superview?.tag }
    var delegate: TileDelgate?
    var dataSource: TileDataSource?
    
    @IBOutlet weak var tileColorImageView: UIImageView!
    @IBOutlet weak var tileBackgroundImageView: UIImageView!
    
    private var currentlyVisibleImageView: UIImageView {
        return state == .Back ? tileBackgroundImageView : tileColorImageView
    }
    
    private var nextVisibleImageView: UIImageView {
        return state == .Color ? tileBackgroundImageView : tileColorImageView
    }
    
    var state: TileState = .Back {
        willSet(newState) {
            guard state != newState else { return }
            UIView.transitionFromView(currentlyVisibleImageView,
                                      toView: nextVisibleImageView,
                                      duration: 0.3,
                                      options: [UIViewAnimationOptions.TransitionFlipFromRight ,UIViewAnimationOptions.ShowHideTransitionViews]) {
                                        [weak self] (_: Bool) in
                                        self?.delegate?.didChanged(to: newState, at: self?.tag)
            }
        }
    }
}

// MARK: - Lifecycle
extension TileViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        let presenter: GamePresenter = App.sharedInstance.request()
        delegate = presenter
        dataSource = presenter
        
        tileColorImageView.image = UIImage(named: dataSource?.imageName(forTag: tag) ?? "card_bg")
    }
}

// MARK: - Actions
extension TileViewController {
    
    @IBAction func tileTapped(sender: UITapGestureRecognizer) {
        state = .Color
    }
}
