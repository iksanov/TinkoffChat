//
//  ThemesViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 05/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ThemesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        themeButton1.layer.cornerRadius = 8;
        themeButton2.layer.cornerRadius = 8;
        themeButton3.layer.cornerRadius = 8;
    }
    
    let model = Themes(colors:#colorLiteral(red: 1, green: 0.8409949541, blue: 0.8371030092, alpha: 1), #colorLiteral(red: 0.8323200345, green: 0.9884948134, blue: 0.6632229686, alpha: 1), #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1));
    var closureForThemeSetting: (UIColor) -> () = { color in }
    
    @IBOutlet var themeButton1: UIButton!
    @IBOutlet var themeButton2: UIButton!
    @IBOutlet var themeButton3: UIButton!
    
    @IBAction func setTheme1(_ sender: Any) {
        view.backgroundColor = model.theme1
        closureForThemeSetting(model.theme1)
        ThemeManager.setLightTheme()
        navigationController?.loadView()
    }
    
    @IBAction func setTheme2(_ sender: Any) {
        view.backgroundColor = model.theme2
        closureForThemeSetting(model.theme2)
        ThemeManager.setDarkTheme()
        navigationController?.loadView()
    }
    
    @IBAction func setTheme3(_ sender: Any) {
        view.backgroundColor = model.theme3
        closureForThemeSetting(model.theme3)
        ThemeManager.setChampagneTheme()
        navigationController?.loadView()
    }
    
    @IBAction func closeThemeChooser(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
