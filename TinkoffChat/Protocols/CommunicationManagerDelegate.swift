//
//  CommunicationManagerDelegate.swift
//  TinkoffChat
//
//  Created by MacBookPro on 19/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol CommunicationManagerDelegate: class {
    var conversations: [MCPeerID : Conversation] { get set }
    func updateViewFromModel()
}
