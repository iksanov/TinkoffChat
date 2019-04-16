//
//  MessageTmp.swift
//  TinkoffChat
//
//  Created by MacBookPro on 13/04/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import CoreData

extension MessageTmp {
    static func insertMessage(from user: UserTmp, with text: String, which isIncoming: Bool, at date: Date, in context: NSManagedObjectContext) -> MessageTmp? {
        print("_ insertMessage")
        guard let message = NSEntityDescription.insertNewObject(forEntityName: "MessageTmp", into: context) as? MessageTmp else { return nil }
        
        message.date = date
        message.isIncoming = isIncoming
        message.text = text
        
        return message
    }
}
