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
    
    let model = Themes(colors:UIColor.orange, UIColor.yellow, UIColor.magenta);
    var closureForThemeSetting: (UIColor) -> () = { color in }
    
    @IBOutlet var themeButton1: UIButton!
    @IBOutlet var themeButton2: UIButton!
    @IBOutlet var themeButton3: UIButton!
    
    @IBAction func setTheme1(_ sender: Any) {
        view.backgroundColor = model.theme1
        closureForThemeSetting(model.theme1)
    }
    
    @IBAction func setTheme2(_ sender: Any) {
        view.backgroundColor = model.theme2
        closureForThemeSetting(model.theme2)
    }
    
    @IBAction func setTheme3(_ sender: Any) {
        view.backgroundColor = model.theme3
        closureForThemeSetting(model.theme3)
    }
    
    @IBAction func closeThemeChooser(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
