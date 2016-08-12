//
//  AppDependencies.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import Foundation
import EventEmitter

typealias App = AppDependencies

// MARK: - DEpendency protocolts
protocol Injectable: class {
    static var id: String {get}
    static func create() -> Self
}

// MARK: - Navigation delegate
protocol NavigationDelegate {
    func performNavigation(by segueId: String)
}

class AppDependencies: EventEmitter {
    
    static var sharedInstance = AppDependencies()
    
    var appNavigationDelehgate: NavigationDelegate?
    
    var listeners: [String: [Any]]? = [:]
    private var injectables: [String: Injectable] = [:]
}

// MARK: -  Dependency management
extension AppDependencies {
    
    func request<T: Injectable>() -> T {
        if let oldModule = injectables[T.id] as? T {
            return oldModule
        }
        else {
            return new()
        }
    }
    
    func new<T: Injectable>() -> T {
        let newModule = T.create()
        injectables[T.id] = newModule
        emit("didAddModuleWithId", information: T.id)
        return newModule
    }
}