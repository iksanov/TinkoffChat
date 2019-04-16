//
//  ConversationTmp.swift
//  TinkoffChat
//
//  Created by MacBookPro on 13/04/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import CoreData

extension ConversationTmp {
    // TODO: what about the rule of using NSMO only on the context where it was created
    // TODO: may be use custom class instead of UserTmp
    static func findOrInsertConversation(with user: UserTmp, in context: NSManagedObjectContext) -> ConversationTmp? {
        print("_ findOrInsertConversation")
        // TODO: may be embed in .perform() (don't forget context.save() before exit perfomBlock())
        var conv: ConversationTmp?  // TODO: refactor naming
        let fetchRequest = NSFetchRequest<ConversationTmp>(entityName: "ConversationTmp")
        fetchRequest.predicate = NSPredicate(format: "user == %@", user)
        
        do {
            let results = try context.fetch(fetchRequest)
            assert(results.count < 2, "_ Multiple Conversations with the same user found!")
            if let foundConv = results.first {
                conv = foundConv
            }
        } catch {
            print("_ Failed to fetch Conversation: \(error)")
        }
        
        if conv == nil {
            print("_ no such conversation. Trying to create a new one")
            conv = {
                let returnConv = ConversationTmp(context: context)
                returnConv.user = user
                returnConv.hasUnreadMessages = false
                returnConv.lastMessageDate = nil  // because there can be no messages yet
                return returnConv
            }()
        }
        
        CoreDataStack.performSave(with: context)
        return conv
    }
}
