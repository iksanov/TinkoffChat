//
//  Theme.swift
//  TinkoffChat
//
//  Created by MacBookPro on 05/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation



struct ThemeManager {
    private static var barBackgroundColor: UIColor = UIColor.white
    private static var tintColor: UIColor = #colorLiteral(red: 0.1725490196, green: 0.4274509804, blue: 1, alpha: 1)
    private static var titleColor: UIColor?
    
    static public func setLightTheme() { // non-static
        barBackgroundColor = UIColor.white
        tintColor = #colorLiteral(red: 0.1725490196, green: 0.4274509804, blue: 1, alpha: 1)
        titleColor = UIColor.black
        updateDisplay()
    }
    
    static public func setDarkTheme() { // non-static
        barBackgroundColor = UIColor.black
        tintColor = UIColor.black
        titleColor = UIColor.black
        updateDisplay()
    }
    
    static public func setChampagneTheme() { // non-static
        barBackgroundColor = #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1)
        tintColor = #colorLiteral(red: 0.7068463409, green: 0.5005939322, blue: 0, alpha: 1)
        titleColor = #colorLiteral(red: 0.3329968118, green: 0.2358308642, blue: 0, alpha: 1)
        updateDisplay()
    }
    
    static public func updateDisplay() { // private?
        UINavigationBar.appearance().backgroundColor = barBackgroundColor
        UIBarButtonItem.appearance().tintColor = tintColor  // почему это красит все BarButtonItems, кроме картинки профиля?
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: titleColor as Any]
    }
}
