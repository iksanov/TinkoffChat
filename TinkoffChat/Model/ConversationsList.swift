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
        conversations = [ConversationPreview].init(ConversationsList.listOfConversations)
    }
    
    var onlineConversations: [ConversationPreview] {
        return conversations.filter({ $0.online }).sorted { $0.date! > $1.date! }
    }
    
    var historyConversations: [ConversationPreview] {
        return conversations.filter({ $0.message != nil && !$0.online }).sorted { $0.date! > $1.date! }
    }
}

extension ConversationsList {
    
     static let listOfConversations = [ConversationPreview(name: "James Smith",
                                                        message: ConversationPreview.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-3600)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    ConversationPreview(name: "Maria Garcia",
                                                        message: ConversationPreview.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-36000)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    ConversationPreview(name: "Sam Rodriguez",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-9000)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Dan Wild",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-20000)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Paul Walker",
                                                        message: ConversationPreview.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-86400)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    ConversationPreview(name: "Chester Field",
                                                        message: "How are you?",
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-600)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Ben Stiller",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-60)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Tony Robbins",
                                                        message: ConversationPreview.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-120)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Chris Brown",
                                                        message: "Let's have a break!",
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-180)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    ConversationPreview(name: "William Fox",
                                                        message: "Go home, bro",
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-200000)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    ConversationPreview(name: "Robert Spown",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-600000)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    
                                    ConversationPreview(name: "David Johnson",
                                                        message: "Hello!",
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-120)),
                                                        online: false,
                                                        hasUnreadMessages: true),
                                    
                                    ConversationPreview(name: "Hearly Cooper",
                                                        message: ConversationPreview.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-600000)),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Miley Old",
                                                        message: ConversationPreview.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-60)),
                                                        online: false,
                                                        hasUnreadMessages: true),
                                    
                                    ConversationPreview(name: "Sam McGregor",
                                                        message: "Could you come here?",
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: true),
                                    
                                    ConversationPreview(name: "Paul Black",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Ann Duple",
                                                        message: ConversationPreview.messageText,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Matt Diezel",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Elizabeth Lawson",
                                                        message: "Go upstairs!",
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Sarah Grames",
                                                        message: ConversationPreview.messageText,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: true),
                                    
                                    ConversationPreview(name: "Cohnor Bush",
                                                        message: ConversationPreview.messageText,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    ConversationPreview(name: "Daniel Perry",
                                                        message: "Let's have a look at it.",
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: true)
                                    ]
}
