//
//  PoolOfConversations.swift
//  TinkoffChat
//
//  Created by MacBookPro on 26/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class ConversationsList {
    
//    let conversations: [ConversationPreview]
//    
//    init() {
//        conversations = [ConversationPreview].init(ConversationsList.listOfConversations)
//    }
//    
//    var onlineConversations: [ConversationPreview] {
//        return conversations.filter({ $0.online }).sorted { $0.date! > $1.date! }
//    }
//    
//    var historyConversations: [ConversationPreview] {
//        return conversations.filter({ $0.message != nil && !$0.online }).sorted { $0.date! > $1.date! }
//    }
}

extension ConversationsList {
    
     static let listOfConversations = [Conversation(name: "James Smith",
                                                        message: Conversation.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-3600)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    Conversation(name: "Maria Garcia",
                                                        message: Conversation.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-36000)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    Conversation(name: "Sam Rodriguez",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-9000)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Dan Wild",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-20000)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Paul Walker",
                                                        message: Conversation.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-86400)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    Conversation(name: "Chester Field",
                                                        message: "How are you?",
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-600)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Ben Stiller",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-60)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Tony Robbins",
                                                        message: Conversation.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-120)),
                                                        online: true,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Chris Brown",
                                                        message: "Let's have a break!",
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-180)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    Conversation(name: "William Fox",
                                                        message: "Go home, bro",
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-200000)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    Conversation(name: "Robert Spown",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-600000)),
                                                        online: true,
                                                        hasUnreadMessages: true),
                                    
                                    
                                    Conversation(name: "David Johnson",
                                                        message: "Hello!",
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-120)),
                                                        online: false,
                                                        hasUnreadMessages: true),
                                    
                                    Conversation(name: "Hearly Cooper",
                                                        message: Conversation.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-600000)),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Miley Old",
                                                        message: Conversation.messageText,
                                                        date: Date.init(timeIntervalSinceNow: TimeInterval.init(-60)),
                                                        online: false,
                                                        hasUnreadMessages: true),
                                    
                                    Conversation(name: "Sam McGregor",
                                                        message: "Could you come here?",
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: true),
                                    
                                    Conversation(name: "Paul Black",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Ann Duple",
                                                        message: Conversation.messageText,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Matt Diezel",
                                                        message: nil,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Elizabeth Lawson",
                                                        message: "Go upstairs!",
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Sarah Grames",
                                                        message: Conversation.messageText,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: true),
                                    
                                    Conversation(name: "Cohnor Bush",
                                                        message: Conversation.messageText,
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: false),
                                    
                                    Conversation(name: "Daniel Perry",
                                                        message: "Let's have a look at it.",
                                                        date: Date.init(timeIntervalSinceNow: 0),
                                                        online: false,
                                                        hasUnreadMessages: true)
                                    ]
}
