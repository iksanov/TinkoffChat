//
//  Theme.swift
//  TinkoffChat
//
//  Created by MacBookPro on 05/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

enum ThemeName: Int {
    case light
    case dark
    case champagne
}

struct Theme {
    let barBackgroundColor: UIColor
    let tintColor: UIColor
    let titleColor: UIColor
    
    init(barBackgroundColor: UIColor, tintColor: UIColor, titleColor: UIColor) {
        self.barBackgroundColor = barBackgroundColor
        self.tintColor = tintColor
        self.titleColor = titleColor
    }
    
    static let lightTheme: Theme = Theme(barBackgroundColor: UIColor.white, tintColor: #colorLiteral(red: 0.1725490196, green: 0.4274509804, blue: 1, alpha: 1), titleColor: UIColor.black)
    static let darkTheme: Theme = Theme(barBackgroundColor: UIColor.black, tintColor: UIColor.black, titleColor: UIColor.black)
    static let champagneTheme: Theme = Theme(barBackgroundColor: #colorLiteral(red: 1, green: 0.8288275599, blue: 0, alpha: 1), tintColor: #colorLiteral(red: 0.7068463409, green: 0.5005939322, blue: 0, alpha: 1), titleColor: #colorLiteral(red: 0.3329968118, green: 0.2358308642, blue: 0, alpha: 1))
}
