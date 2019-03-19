//
//  CommunicationManager.swift
//  TinkoffChat
//
//  Created by MacBookPro on 19/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class CommunicationManager: NSObject, CommunicatorDelegate {
    weak var delegate: CommunicationManagerDelegate?
    var sessions = [MCPeerID : MCSession]()
    
    func didFoundUser(userID: String, userName: String?) {
//        delegate?.conversations.append()
    }
    
    func didLostUser(userID: String) {
        
    }
    
    func failedToStartBrowsingForUsers(error: Error) {
        
    }
    
    func failedToStartAdvertising(error: Error) {
        
    }
    
    func didReceiveMessage(text: String, fromUser: String, toUser: String) {
        
    }
}

extension CommunicationManager: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        if sessions[peerID] == nil {
            sessions[peerID] = MCSession(peer: peerID)
            didFoundUser(userID: peerID.displayName, userName: info?["userName"])
        } else {
            assert(false, "Session with this peerID already excists")
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        
    }
}

extension CommunicationManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        
    }
}
