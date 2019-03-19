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
    init() {
//        advertiser.delegate = (delegate as! CommunicationManager)
//        browser.delegate = (delegate as! CommunicationManager)
    }
    
    var online = false
    weak var delegate: CommunicatorDelegate?  // make it sigleton
    
    let myPeerID = MCPeerID(displayName: "Emil")
    lazy var advertiser = MCNearbyServiceAdvertiser(peer: myPeerID,
                                                    discoveryInfo: ["userName": "emil_iksanov"],
                                                    serviceType: "tinkoff-chat")
    lazy var browser = MCNearbyServiceBrowser(peer: myPeerID,
                                              serviceType: "tinkoff-chat")
    
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?) {
        
    }
}
