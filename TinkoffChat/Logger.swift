//
//  Logger.swift
//  TinkoffChat
//
//  Created by MacBookPro on 11/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

enum State: String {
    case not_running = "NOT_RUNNING"
    case inactive = "INACTIVE"
    case active = "ACTIVE"
    case background = "BACKGROUND"
    case suspended = "SUSPENDED"
}

/*
 It is possible to turn off Life Cycle logging before the compilation.
 To do this: set logMode variable to 'false'.
 You can also change it's value during the life cycle in code somewhere in methods (in order to start/stop logging for some of them)
 */
class Logger {
    static func printAppLogMsg(from fromState: State, to toState: State, methodName: String = #function) {
        if logMode {
            print("Application moved from \(fromState.rawValue) to \(toState.rawValue): \(methodName)")
        }
    }
    
    static func printVCLogMsg(methodName: String = #function) {
        if logMode {
            print("VCMethod: \(methodName)")
        }
    }
    
    static var logMode: Bool = true
}
