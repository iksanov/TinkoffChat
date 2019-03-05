//
//  Theme.swift
//  TinkoffChat
//
//  Created by MacBookPro on 05/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class ThemeManager {
    private static var theme: Theme = .lightTheme
    
    static func setTheme(withName themeName: ThemeName) {
        switch themeName {
        case .light: theme = .lightTheme
        case .dark: theme = .darkTheme
        case .champagne: theme = .champagneTheme
        }
        UserDefaults.standard.set(themeName.rawValue, forKey: "appTheme")
        updateDisplay()
    }
    
    private static func updateDisplay() {
        UINavigationBar.appearance().backgroundColor = theme.barBackgroundColor
        UIBarButtonItem.appearance().tintColor = theme.tintColor  // почему это красит все BarButtonItems, кроме картинки профиля?
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: theme.titleColor]
    }
}
