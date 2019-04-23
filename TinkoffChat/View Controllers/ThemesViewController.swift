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
        
        let tap = UILongPressGestureRecognizer(target: self, action: #selector(touchedBy(recognizer:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func touchedBy(recognizer: UILongPressGestureRecognizer) {
        let touchLocation = recognizer.location(in: recognizer.view)
        switch recognizer.state {
        case .began:
            DispatchQueue.main.async {
                let image = UIImageView(image: UIImage(named: "gerb"))
                image.frame = CGRect(x: touchLocation.x + CGFloat(arc4random_uniform(100)),
                                     y: touchLocation.y,
                                     width: 100,
                                     height: 100)
                self.view.addSubview(image)
                print("began")
                UIView.animate(withDuration: 2.0) {
                    image.center.x += 50
                }
            }

            
        case .cancelled:
            print("cancelled")
        case .changed:
            print("began")
        case .ended:
            print("ended")
        case .failed:
            print("began")
        case .possible:
            print("possible")
        default:
            print("default")
        }
    }
    
    let model = Themes(colors:#colorLiteral(red: 1, green: 0.8409949541, blue: 0.8371030092, alpha: 1), #colorLiteral(red: 0.8323200345, green: 0.9884948134, blue: 0.6632229686, alpha: 1), #colorLiteral(red: 1, green: 0.8323456645, blue: 0.4732058644, alpha: 1));
    var closureForThemeSetting: (UIColor) -> () = { color in }
    
    @IBOutlet var themeButton1: UIButton!
    @IBOutlet var themeButton2: UIButton!
    @IBOutlet var themeButton3: UIButton!
    
    @IBAction func setTheme1(_ sender: Any) {  // TODO: remove duplicated code for IBActions
        view.backgroundColor = model.theme1
        closureForThemeSetting(model.theme1)
        ThemeManager.setTheme(withName: .light)
        navigationController?.loadView()  // TODO: don't do like this
    }
    
    @IBAction func setTheme2(_ sender: Any) {
        view.backgroundColor = model.theme2
        closureForThemeSetting(model.theme2)
        ThemeManager.setTheme(withName: .dark)
        navigationController?.loadView()  // TODO: don't do like this
    }
    
    @IBAction func setTheme3(_ sender: Any) {
        view.backgroundColor = model.theme3
        closureForThemeSetting(model.theme3)
        ThemeManager.setTheme(withName: .champagne)
        navigationController?.loadView()  // TODO: don't do like this
    }
    
    @IBAction func closeThemeChooser(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
