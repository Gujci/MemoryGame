//
//  DataStore.swift
//  MemoryGame
//
//  Created by Gujgiczer Máté on 12/08/16.
//  Copyright © 2016 gujci. All rights reserved.
//

import Foundation

import Foundation
import CoreData

protocol Storable {
    associatedtype ManagedObjectType: NSManagedObject
    static var entityName: String {get}
    
    func saveToEnity(inContext moc: NSManagedObjectContext, withManager cacheManager: DataStore) throws -> ManagedObjectType
    init(withEntity: ManagedObjectType) throws
}

enum DataStoreError: ErrorType {
    case CouldNotInitiate
    case CouldNotSaveToCace
}

final class DataStore {
    
    private lazy var managedObjectContext: NSManagedObjectContext? = {
        var managedObjectContext: NSManagedObjectContext? = nil
        Queue.Utility.executeSync(self) { [weak self] in
            if let coordinator = self?.persistentStoreCoordinator {
                managedObjectContext = NSManagedObjectContext(concurrencyType: .PrivateQueueConcurrencyType)
                managedObjectContext!.persistentStoreCoordinator = coordinator
            }
        }
        return managedObjectContext
    }()
    
    private lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = nil
        Queue.Utility.executeSync(self) { [weak self] in
            if let model = self?.managedObjectModel {
                coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
                let url = self?.applicationDocumentsDirectory.URLByAppendingPathComponent("MemoryGame.sqlite")
                
                do {
                    try coordinator?.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil)
                }
                catch {
                    print("NSPersistentStoreCoordinator error")
                }
            }
        }
        return coordinator
    }()
    
    private lazy var applicationDocumentsDirectory: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        return urls.first!
    }()
    
    private lazy var managedObjectModel: NSManagedObjectModel? = {
        var model: NSManagedObjectModel? = nil
        Queue.Utility.executeSync(self) { [weak self] in
            if let modelURL = NSBundle(forClass: self!.dynamicType).URLForResource("MemoryGame", withExtension: "momd") {
                model = NSManagedObjectModel(contentsOfURL: modelURL)
            }
        }
        return model
    }()
}

// MARK: - Load
extension DataStore {
    
    func getAllEntities<T: Storable>() -> [T]? {
        if let moc = managedObjectContext {
            var results: [T]? = nil
            moc.performBlockAndWait() {
                let request = NSFetchRequest(entityName: T.entityName)
                request.returnsObjectsAsFaults = false
                
                let result: [AnyObject]?
                do {
                    result = try? moc.executeFetchRequest(request)
                }
                if let validRes = result as? [NSManagedObject] where validRes.count > 0 {
                    do {
                        results = try validRes.map() { element in
                            if let entity = element as? T.ManagedObjectType {
                                return try T(withEntity: entity)
                            }
                            else {
                                throw DataStoreError.CouldNotInitiate
                            }
                        }
                    } catch {
                        print("Can't load \(T.entityName)")
                    }
                }
            }
            return results
        }
        return nil
    }
}

// MARK: - Save
extension DataStore {
    
    func saveObjectToCache<T: Storable>(object: T) {
        if let moc = managedObjectContext {
            moc.performBlockAndWait() {
                do {
                    try object.saveToEnity(inContext: moc, withManager: self)
                    try moc.save()
                } catch {
                    print("Error during saving \(T.entityName)")
                }
            }
        }
    }
    
    func saveObjectsToCache<T: Storable>(objects: [T]) {
        objects.forEach() { object in
            saveObjectToCache(object)
        }
    }
}

// MARK: - Injectable
extension DataStore: Injectable {
    
    static var id: String { return "Storage" }
    
    static func create() -> DataStore {
        return DataStore()
    }
}