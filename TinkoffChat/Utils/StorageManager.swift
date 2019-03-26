//
//  StorageManager.swift
//  TinkoffChat
//
//  Created by MacBookPro on 26/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import CoreData

class StorageManager {
    
    let coreDataStack = CoreDataStack()  // TODO: may be move it to AppDelegate
    
    func fetchOrCreateNewProfile(in context: NSManagedObjectContext) -> ProfileInfoTmp? {
        return CoreDataStack.findOrInsertAppUser(in: context)
    }
    
    func saveData(from profile: ProfileInfo, with context: NSManagedObjectContext) {
        let justFetchedProfileTmp = CoreDataStack.findOrInsertAppUser(in: context)
        justFetchedProfileTmp?.name = profile.name
        justFetchedProfileTmp?.descriptionInfo = profile.description
        CoreDataStack.performSave(with: context)
    }
}
