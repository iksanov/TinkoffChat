//
//  EditProfileViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 13/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    var gcdDataManager = GCDDataManager()
    var profile = ProfileInfo()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        photoImageView.image = profile.image
    }
    
    @IBAction func cancelEditProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
