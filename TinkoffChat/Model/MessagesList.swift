//
//  MessagesList.swift
//  TinkoffChat
//
//  Created by MacBookPro on 01/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class MessagesList {
    let messages: [Message]
    
    init() {
        messages = [Message].init(MessagesList.listOfMessages)
    }
}

extension MessagesList {
    static let listOfMessages = [Message(text: "Hello", ifIncoming: true),
                                 Message(text: "How", ifIncoming: true),
                                 Message(text: "Are", ifIncoming: false),
                                 Message(text: "You", ifIncoming: true),
                                 Message(text: "I am okay", ifIncoming: false),
                                 Message(text: ConversationPreview.messageText, ifIncoming: false)]
}
