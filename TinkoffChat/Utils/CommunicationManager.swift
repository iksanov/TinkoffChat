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
        print("_ foundPeer \(peerID.displayName)")
        if sessions[peerID] == nil {
            print("_ foundPeer -> session was nil")
            let newSession = MCSession(peer: MultipeerCommunicator.myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
            newSession.delegate = delegate!
            sessions[peerID] = newSession
            browser.invitePeer(peerID,
                               to: newSession,
                               withContext: nil,
                               timeout: 120)
            print("_ foundPeer -> session was nil -> invited peer")
        } else {
            print("_ Session with \(peerID.displayName) already exists. peerID connection to session: \(sessions[peerID]!.connectedPeers.contains(peerID))")
        }
    }
    
    // TODO: FIX! - update somehow (may be by checking all sessions again) info about old conversations after coming back from background mode
    // if close on the first device, then close on the second and then reopen on the first - it will show that the second is online
    // (because it didn't get the message about loosing peer (because it was in background mode))
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("_ lost peer \(peerID.displayName)")
        sessions.removeValue(forKey: peerID)
        delegate!.conversations.removeValue(forKey: peerID)
        delegate!.updateViewFromModel()
    }
}

extension CommunicationManager: MCNearbyServiceAdvertiserDelegate {
    
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("_ received invitation from peer: \(peerID.displayName)")
        if sessions[peerID] == nil {
            print("_ didReceiveInvitation -> session was nil")
            let newSession = MCSession(peer: MultipeerCommunicator.myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
            newSession.delegate = delegate!
            sessions[peerID] = newSession
            invitationHandler(true, newSession)
            print("_ accepted invitation from peer: \(peerID.displayName)")
        } else {
            if sessions[peerID]!.connectedPeers.contains(peerID) {
                print("_ didReceiveInvitation -> session wasn't nil -> connectedPeers.contains")
                invitationHandler(false, nil)
                print("_ reject invitation from \(peerID.displayName)")
            } else {
                print("_ didReceiveInvitation -> session wasn't nil -> connectedPeers doesn't contain")
                invitationHandler(true, sessions[peerID]!)
                print("_ accepted invitation from \(peerID.displayName)")
            }
        }
    }
}
