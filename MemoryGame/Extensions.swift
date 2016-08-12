//
//  Extensions.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

extension UIView {
    
    static func delay(time: Double, callback: ()->()) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64(NSEC_PER_MSEC) * Int64(time * 1000))), dispatch_get_main_queue(), { () -> Void in
            callback()
        })
    }
}

extension MutableCollectionType where Index == Int {
    
    mutating func shuffle() -> Self {
        guard count >= 2  else { return self }
        
        for i in 0..<count - 1 {
            let j = Int(arc4random_uniform(UInt32(count - i))) + i
            guard i != j else { continue }
            swap(&self[i], &self[j])
        }
        return self
    }
}