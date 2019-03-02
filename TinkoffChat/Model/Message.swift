//
//  Message.swift
//  TinkoffChat
//
//  Created by MacBookPro on 01/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class Message: MessageCellConfiguration {
    var textOfMessage: String?
    var isIncoming: Bool
    
    init(text: String?, isIncoming: Bool) {
        self.textOfMessage = text
        self.isIncoming = isIncoming
    }
}
