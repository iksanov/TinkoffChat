//
//  UserTmp.swift
//  TinkoffChat
//
//  Created by MacBookPro on 13/04/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import CoreData

extension UserTmp {
    static func findUser(with name: String, in context: NSManagedObjectContext) -> UserTmp? {
        print("_ findUser \(name)")
        // TODO: may be embed in .perform() (don't forget context.save() before exit perfomBlock())
        var user: UserTmp?  // TODO: refactor naming
        let fetchRequest = NSFetchRequest<UserTmp>(entityName: "UserTmp")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "_ Multiple users with the same name found!")
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("_ Failed to fetch User: \(error)")
        }
//        CoreDataStack.performSave(with: context)
        return user
    }
    
    // TODO: what about the rule of using NSMO only on the context where it was created
    // TODO: may be use custom class instead of UserTmp
    static func findOrInsertUser(with name: String, in context: NSManagedObjectContext) -> UserTmp? {
        print("_ findOrInsertUser \(name)")
        // TODO: may be embed in .perform() (don't forget context.save() before exit perfomBlock())
        var user: UserTmp?  // TODO: refactor naming
        let fetchRequest = NSFetchRequest<UserTmp>(entityName: "UserTmp")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "_ Multiple users with the same name found!")
            if let foundUser = results.first {
                user = foundUser
            }
        } catch {
            print("_ Failed to fetch User: \(error)")
        }
        
        if user == nil {
            print("_ no such user. Trying to create a new one")
            user = {
                let returnUser = UserTmp(context: context)
                returnUser.name = name
                return returnUser
            }()
        }
        
        CoreDataStack.performSave(with: context)
        return user
    }
}
