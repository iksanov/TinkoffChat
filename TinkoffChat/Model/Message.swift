//
//  Message.swift
//  TinkoffChat
//
//  Created by MacBookPro on 01/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class Message: MessageCellConfiguration {
    var text: String?
    var ifIncoming: Bool
    
    init(text: String?, ifIncoming: Bool) {
        self.text = text
        self.ifIncoming = ifIncoming
    }
}
