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
}
