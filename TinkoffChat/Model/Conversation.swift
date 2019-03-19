//
//  ConversationPreview.swift
//  TinkoffChat
//
//  Created by MacBookPro on 26/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

//class Conversation: ConversationCellConfiguration {
class Conversation {
    var name: String?
    var messages: [Message]?
    var date: Date?
    var online: Bool
    var hasUnreadMessages: Bool
    
    init(name: String?, messages: [Message]?, date: Date?, online: Bool, hasUnreadMessages: Bool) {
        self.name = name
        self.messages = messages
        self.date = date
        self.online = online
        self.hasUnreadMessages = hasUnreadMessages
    }
}

extension Conversation {
    static let messageText: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
}

extension Conversation {
    
    static let listOfConversations = [Conversation(name: String?("James Smith"),
                                                   messages: nil,
                                                   date: Date.init(timeIntervalSinceNow: TimeInterval.init(-3600)),
                                                   online: true,
                                                   hasUnreadMessages: true),
                                      
                                      Conversation(name: "Daniel Perry",
                                                   messages: [Message(text: Conversation.messageText, isIncoming: true)],
                                                   date: Date.init(timeIntervalSinceNow: 0),
                                                   online: false,
                                                   hasUnreadMessages: true)
    ]
}
