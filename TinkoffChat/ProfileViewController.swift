//
//  ViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 11/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var photoChooser: UIButton!
    
    @IBOutlet weak var photoImage: UIImageView!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBAction func choosePhoto(_ sender: Any) {
        print("Выбери изображение профиля")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // TODO: change font size according to screen width (how?)
        // TODO: remove taps on button corners
        photoChooser.layer.cornerRadius = chooserCornerRadius
        let imageEdgeInset = chooserImageInset
        photoChooser.imageEdgeInsets = UIEdgeInsets(top: imageEdgeInset, left: imageEdgeInset, bottom: imageEdgeInset, right: imageEdgeInset)
        
        photoImage.layer.masksToBounds = true
        photoImage.layer.cornerRadius = photoChooser.layer.cornerRadius
        
        editProfileButton.layer.borderWidth = SizeRatio.editButtonBorderWidth
        editProfileButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editProfileButton.layer.masksToBounds = true
        editProfileButton.layer.cornerRadius = editButtonCornerRadius
        
        logEditProfileButtonFrame()
    }
    
    private func logEditProfileButtonFrame() {
        print(editProfileButton.frame)
    }
    
    /*
     Происходит ошибка, так как editProfileButton = nil.
     Это так, потому что в тот момент, когда вызывается метод init(), UI-элементов еще не существует.
     */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // logEditProfileButtonFrame()
    }
    
    /*
     Результаты получаются разные, потому что в сториборде выбрано устройство iPhoneSE и результаты во viewDidLoad() выводятся для него.
     Уже потом после viewDidLoad() будет вызван viewDidLayoutSubviews(), применены констрейнты, границы будут заданы границами выбранного девайса (iPhone 8 Plus).
     Если выбрать девайсы в симуляторе и в сториборде одинаковыми, то и результаты в логе будут одинаковыми.
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        logEditProfileButtonFrame()
    }
}

extension ProfileViewController {
    private struct SizeRatio {
        static let chooserCornerRadiusToChooserWidth: CGFloat = 0.65
        static let chooserImageInsetToChooserWidth: CGFloat = 0.3
        static let editButtonCornerRadiusToEditButtonWidth: CGFloat = 0.05
        static let editButtonBorderWidth: CGFloat = 2.0
    }
    private var chooserCornerRadius: CGFloat {
        return photoChooser.bounds.width * SizeRatio.chooserCornerRadiusToChooserWidth
    }
    private var chooserImageInset: CGFloat {
        return photoChooser.bounds.width * SizeRatio.chooserImageInsetToChooserWidth
    }
    private var editButtonCornerRadius: CGFloat {
        return editProfileButton.bounds.width * SizeRatio.editButtonCornerRadiusToEditButtonWidth
    }
}

