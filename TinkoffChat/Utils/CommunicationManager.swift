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
    let decoder = JSONDecoder()
    
    func didFoundUser(userID: String, userName: String?) {
        
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
            let newSession = MCSession(peer: MultipeerCommunicator.myPeerID)
            sessions[peerID] = newSession
            browser.invitePeer(peerID,
                               to: newSession,
                               withContext: nil,
                               timeout: 120)
        } else {
            assert(false, "Session with this peerID already excists")
        }
    }
    
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        sessions.removeValue(forKey: peerID)
        delegate?.conversations.removeValue(forKey: peerID)
    }
}

extension CommunicationManager: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("I have received invitation from peer: \(peerID)")
        if sessions[peerID]!.connectedPeers.contains(peerID) {
            invitationHandler(false, nil)
        } else {
            invitationHandler(true, sessions[peerID]!)
        }
    }
}

extension CommunicationManager: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        if state == MCSessionState.connected {
            delegate?.conversations[peerID] = Conversation(name: peerID.displayName,  // TODO: make a separate method
                                                           messages: nil,
                                                           date: Date(),  // TODO: replace for nil
                                                           online: true,
                                                           hasUnreadMessages: false)
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("session didReceive data \(data)")
        
        let messageFromJSON = try! decoder.decode(MessageForJSON.self, from: data)
        delegate?.conversations[peerID]?.messages?.append(Message(text: messageFromJSON.text,
                                                                  isIncoming: true))
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("session didReceive stream: \(stream)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("session didStartReceivingResourceWithName \(resourceName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("session didFinishReceivingResourceWithName \(resourceName)")
    }
}
