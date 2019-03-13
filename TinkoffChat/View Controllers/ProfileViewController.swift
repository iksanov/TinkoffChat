//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 11/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoChooser: UIButton!  // TODO: remove photoChooser from this VC
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    let nameFilename = "userName.txt"
    let descriptionFilename = "userDescription.txt"
    let imageFilename = "userPhoto.png"
    lazy var gcdDataManager = GCDDataManager(nameFilename, descriptionFilename, imageFilename)
    
    let profile = ProfileInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TODO: change font size according to screen width (how?)
        photoChooser.layer.cornerRadius = chooserCornerRadius
        let imageEdgeInset = chooserImageInset
        photoChooser.imageEdgeInsets = UIEdgeInsets(top: imageEdgeInset, left: imageEdgeInset, bottom: imageEdgeInset, right: imageEdgeInset)
        
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = photoChooser.layer.cornerRadius
        photoImageView.contentMode = .scaleAspectFill
        
        editProfileButton.layer.borderWidth = SizeRatio.editButtonBorderWidth
        editProfileButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editProfileButton.layer.masksToBounds = true
        editProfileButton.layer.cornerRadius = editButtonCornerRadius
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)  // TODO: may be do it beforehand
        gcdDataManager.readData(to: profile)  // TODO: use multythreading (choose GCD / Operation)
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        photoImageView.image = profile.image
    }
    
    @IBAction func closeProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func choosePhoto(_ sender: Any) {
        print("Выбери изображение профиля")
        
        let actionSheet = UIAlertController.init(title: "Choose source", message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Open Photo Library", style: .default, handler: { action in
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile" {
            if let editProfileVCinNavigationVC = sender as? UINavigationController, let editProfileVC = editProfileVCinNavigationVC.topViewController as? EditProfileViewController {
                editProfileVC.gcdDataManager = gcdDataManager
                editProfileVC.profile = profile
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ProfileViewController {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            photoImageView.image = image
            if picker.sourceType == .camera {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileViewController {
    private struct SizeRatio {
        static let chooserCornerRadiusToChooserWidth: CGFloat = 0.5
        static let chooserImageInsetToChooserWidth: CGFloat = 0.25
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
