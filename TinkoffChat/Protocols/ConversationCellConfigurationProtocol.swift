//
//  ConversationCellConfigurationProtocol.swift
//  TinkoffChat
//
//  Created by MacBookPro on 28/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

protocol ConversationCellConfiguration: class {
    var name: String? { get set }
    var message: String? { get set }
    var date: Date? { get set }
    var online: Bool { get set }
    var hasUnreadMessages: Bool { get set }
}
