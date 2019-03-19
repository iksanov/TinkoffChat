//
//  MessageForJSON.swift
//  TinkoffChat
//
//  Created by MacBookPro on 20/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

struct MessageForJSON: Codable {
    let eventType: String
    let text: String
    let messageId: String
    
    static func generateMessageId() -> String {
        return "\(arc4random_uniform(UINT32_MAX))+\(Date.timeIntervalSinceReferenceDate)".data(using: .utf8)!.base64EncodedString()
    }
}
