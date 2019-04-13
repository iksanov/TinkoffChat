//
//  ProfileInfoTmp.swift
//  TinkoffChat
//
//  Created by MacBookPro on 26/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import CoreData


extension ProfileInfoTmp {
    static func insertAppUser(in context: NSManagedObjectContext) -> ProfileInfoTmp? {
        guard let appUser = NSEntityDescription.insertNewObject(forEntityName: "ProfileInfoTmp", into: context) as? ProfileInfoTmp else { return nil }
        
        appUser.name = "Emil"
        appUser.descriptionInfo = "my description info"
        
        return appUser
    }
    
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
        
        CoreDataStack.performSave(with: context)
        return appUser
    }
}
