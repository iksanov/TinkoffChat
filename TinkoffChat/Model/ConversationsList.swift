//
//  PoolOfConversations.swift
//  TinkoffChat
//
//  Created by MacBookPro on 26/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class ConversationsList {
    
    let conversations: [ConversationPreview]
    
    init() {
        conversations = [ConversationPreview].init(arrayLiteral: ConversationPreview(name: "James Smith",
                                                                                     message: ConversationPreview.messageText,
                                                                                     date: Date.init(timeIntervalSinceNow: 0),
                                                                                     online: true,
                                                                                     hasUnreadMessages: true))
    }
    
    var onlineConversations: [ConversationPreview] {
        return conversations.filter { $0.online }
    }
    
    var historyConversations: [ConversationPreview] {
        return conversations.filter { $0.message != nil && !$0.online }
    }
}
