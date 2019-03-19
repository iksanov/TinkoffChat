//
//  CommunicationManagerDelegate.swift
//  TinkoffChat
//
//  Created by MacBookPro on 19/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

protocol CommunicationManagerDelegate: class {
    var conversations: [Conversation] { get set }
}
