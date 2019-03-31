//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by MacBookPro on 19/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: Communicator {    
    var online = true
    weak var delegate: CommunicatorDelegate?  // make it sigleton
    static let myPeerID = MCPeerID(displayName: UIDevice.current.name)
    
    lazy var advertiser = MCNearbyServiceAdvertiser(peer: MultipeerCommunicator.myPeerID,
                                                    discoveryInfo: ["userName": "emil_iksanov"],
                                                    serviceType: "tinkoff-chat")
    lazy var browser = MCNearbyServiceBrowser(peer: MultipeerCommunicator.myPeerID,
                                              serviceType: "tinkoff-chat")
    
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?) {
        
    }
}
