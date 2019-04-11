//
//  MultipeerCommunicator.swift
//  TinkoffChat
//
//  Created by MacBookPro on 19/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class MultipeerCommunicator: NSObject, Communicator {
    var online: Bool
    weak var delegate: CommunicatorDelegate?
    static let myPeerID = MCPeerID(displayName: MultipeerCommunicator.myDeviceName)
    
    var advertiser: MCNearbyServiceAdvertiser
    var browser: MCNearbyServiceBrowser
    var sessions: [String : MCSession]
    
    let decoder: JSONDecoder
    
    override init() {
        online = true
        sessions = [String : MCSession]()
        advertiser = MCNearbyServiceAdvertiser(peer: MultipeerCommunicator.myPeerID,
                                               discoveryInfo: ["userName": "emil_iksanov"],
                                               serviceType: "tinkoff-chat")
        
        browser = MCNearbyServiceBrowser(peer: MultipeerCommunicator.myPeerID,
                                         serviceType: "tinkoff-chat")
        decoder = JSONDecoder()
        
        super.init()
        
        advertiser.delegate = self
        browser.delegate = self
        
        advertiser.startAdvertisingPeer()
        browser.startBrowsingForPeers()
    }
    
    func sendMessage(string: String, to userID: String, completionHandler: ((_ success: Bool, _ error: Error?) -> ())?) {
        let msgId = MessageForJSON.generateMessageId()
        let msgString = """
        {
        "eventType": "TextMessage",
        "text": "\(string)",
        "messageId": "\(msgId)"
        }
        """
        let jsonData = msgString.data(using: .utf8)!
        
        do {
            if let sessionWithReceiver = sessions[userID] {
//                try sessionWithReceiver.send(jsonData, toPeers: [userID], with: .reliable)
            }
        } catch let myJSONError {
            print("CAN'T SEND", myJSONError)
        }
        print("I have tried to send message")
        delegate?.didReceiveMessage(text: string, fromUser: MultipeerCommunicator.myDeviceName, toUser: userID)
    }
}

extension MultipeerCommunicator {
    static let myDeviceName = UIDevice.current.name
}

extension MultipeerCommunicator: MCNearbyServiceAdvertiserDelegate {
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        print("_ received invitation from peer: \(peerID.displayName)")
        if sessions[peerID.displayName] == nil {
            print("_ didReceiveInvitation -> session was nil")
            let newSession = MCSession(peer: MultipeerCommunicator.myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
            newSession.delegate = self
            sessions[peerID.displayName] = newSession
            invitationHandler(true, newSession)
            print("_ accepted invitation from peer: \(peerID.displayName)")
        } else {
            if sessions[peerID.displayName]!.connectedPeers.contains(peerID) {
                print("_ didReceiveInvitation -> session wasn't nil -> connectedPeers.contains")
                invitationHandler(false, nil)
                print("_ reject invitation from \(peerID.displayName)")
            } else {
                print("_ didReceiveInvitation -> session wasn't nil -> connectedPeers doesn't contain")
                invitationHandler(true, sessions[peerID.displayName]!)
                print("_ accepted invitation from \(peerID.displayName)")
            }
        }
    }
}

extension MultipeerCommunicator: MCNearbyServiceBrowserDelegate {
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        print("_ foundPeer \(peerID.displayName)")
        if sessions[peerID.displayName] == nil {
            print("_ foundPeer -> session was nil")
            let newSession = MCSession(peer: MultipeerCommunicator.myPeerID, securityIdentity: nil, encryptionPreference: MCEncryptionPreference.none)
            newSession.delegate = self
            sessions[peerID.displayName] = newSession
            browser.invitePeer(peerID,
                               to: newSession,
                               withContext: nil,
                               timeout: 120)
            print("_ foundPeer -> session was nil -> invited peer")
        } else {
            print("_ Session with \(peerID.displayName) already exists. peerID connection to session: \(sessions[peerID.displayName]!.connectedPeers.contains(peerID))")
        }
    }
    
    // TODO: FIX! - update somehow (may be by checking all sessions again) info about old conversations after coming back from background mode
    // if close on the first device, then close on the second and then reopen on the first - it will show that the second is online
    // (because it didn't get the message about loosing peer (because it was in background mode))
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("_ lost peer \(peerID.displayName)")
        sessions.removeValue(forKey: peerID.displayName)
        delegate?.didLostUser(userID: peerID.displayName)
    }
}

extension MultipeerCommunicator: MCSessionDelegate {
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("_ Session with peer \(peerID.displayName) changed state to \(state.rawValue)")
        print("_ peerID \(peerID.displayName) connection to session: \(session.connectedPeers.contains(peerID))")
        if state == MCSessionState.notConnected {
            sessions.removeValue(forKey: peerID.displayName)
            print("_ deleted session with peerID \(peerID.displayName)")
            delegate?.didLostUser(userID: peerID.displayName)
        }
        if state == MCSessionState.connected {
            print("_ Session is connected")
            delegate?.didFoundUser(userID: peerID.displayName, userName: "add later")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        print("_ session didReceive data \(data)")
        let messageFromJSON = try! decoder.decode(MessageForJSON.self, from: data)
        delegate?.didReceiveMessage(text: messageFromJSON.text, fromUser: peerID.displayName, toUser: MultipeerCommunicator.myPeerID.displayName)
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("_ session didReceive stream: \(stream)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("_ session didStartReceivingResourceWithName \(resourceName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print("_ session didFinishReceivingResourceWithName \(resourceName)")
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        certificateHandler(true)
        print("_ session didReceiveCertificate fromPeer \(peerID)")
    }
}
