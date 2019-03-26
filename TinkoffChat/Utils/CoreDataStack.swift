//
//  CoreDataStack.swift
//  TinkoffChat
//
//  Created by MacBookPro on 26/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var storeURL: URL {
        let documentsUrl = FileManager.default.urls(for: .documentDirectory,
                                                    in: .userDomainMask).first!
        return documentsUrl.appendingPathComponent("MyStore.sqlite")
    }
    
    
    let dataModelName = "Model"
    let dataModelExtension = "momd"
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.dataModelName,
                                       withExtension: self.dataModelExtension)!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                               configurationName: nil,
                                               at: self.storeURL,
                                               options: nil)
        } catch {
            assert(false, "Error adding store: \(error)")
        }
        
        return coordinator
    }()
    
        lazy var masterContext: NSManagedObjectContext = {
            var masterContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            masterContext.persistentStoreCoordinator = self.persistentStoreCoordinator
            masterContext.mergePolicy = NSOverwriteMergePolicy
            return masterContext
        }()
    
        lazy var mainContext: NSManagedObjectContext = {
            var mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            mainContext.parent = self.masterContext
            mainContext.mergePolicy = NSOverwriteMergePolicy
            return mainContext
        }()
    
        lazy var saveContext: NSManagedObjectContext = {
            var saveContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            saveContext.parent = self.mainContext
            saveContext.mergePolicy = NSOverwriteMergePolicy
            return saveContext
        }()
    
    // TODO: what about the rule of using NSMO only on the context where it was created
    // TODO: remove ProfileInfoTmp (It was created because it doesn't contain UIImage for experimental purposes)
    static func findOrInsertAppUser(in context: NSManagedObjectContext) -> ProfileInfoTmp? {
        // TODO: may be embed in .perform() (don't forget context.save() before exit perfomBlock())
        var appUser: ProfileInfoTmp?  // TODO: refactor naming
        let fetchRequest = NSFetchRequest<ProfileInfoTmp>(entityName: "ProfileInfoTmp")
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "Multiple AppUsers found!")
            if let foundUser = results.first {
                appUser = foundUser
            }
        } catch {
            print("Failed to fetch AppUser: \(error)")
        }
        
        if appUser == nil {
            appUser = ProfileInfoTmp.insertAppUser(in: context)
        }
        
        performSave(with: context)
        return appUser
    }
    
    typealias SaveCompletion = () -> Void
    
    static func performSave(with context: NSManagedObjectContext, completion: SaveCompletion? = nil) {
        guard context.hasChanges else {
            print("No changes in given context")
            completion?()
            return
        }
        
        context.perform {
            do {
                try context.save()
            } catch {
                print("Context save error: \(error)")
            }
            
            if let parentContext = context.parent {
                performSave(with: parentContext, completion: completion)
            } else {
                completion?()
            }
        }
    }
    
}
