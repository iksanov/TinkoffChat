//
//  ProfileViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 11/02/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!  // TODO: test hugging and comression for different content volume
    @IBOutlet var descriptionLabel: UILabel!
    
    @IBOutlet weak var editProfileButton: UIButton!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
//    lazy var gcdDataManager = GCDDataManager()
//    lazy var operationDataManager = OperationDataManager()
    
    let storageManager = StorageManager()
    
    var profile = ProfileInfo()
    
//    var usingGCDInstedOfOperation = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        nameLabel.text = nil
        descriptionLabel.text = nil
    }
    
    override func viewDidAppear(_ animated: Bool) {  // TODO: may be do it in viewWillAppear()
        super.viewDidAppear(animated)
        readDataFromFile()
        fillContentFromProfile()  // TODO: wait until reading will stop
    }
    
    private func readDataFromFile() {
        activityIndicator.startAnimating()
//        if usingGCDInstedOfOperation {
//            gcdDataManager.readDataFromFile(to: &profile)
//        } else {
//            operationDataManager.readDataFromFile(to: &profile)
//        }
        StorageManager.sharedCoreDataStack.saveContext.performAndWait {  // TODO: understand which context is necessary
            let profileTmp = storageManager.fetchOrCreateNewProfile(in: StorageManager.sharedCoreDataStack.saveContext)!
            profile.name = profileTmp.name!
            profile.description = profileTmp.descriptionInfo!
        }
        activityIndicator.stopAnimating()
    }
    
    private func fillContentFromProfile() {
        nameLabel.text = profile.name
        descriptionLabel.text = profile.description
        photoImageView.image = profile.image
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // TODO: change font size according to screen width (how?)
        photoImageView.layer.masksToBounds = true
        photoImageView.layer.cornerRadius = imageCornerRadius
        photoImageView.contentMode = .scaleAspectFill
        
        editProfileButton.layer.borderWidth = SizeRatio.editButtonBorderWidth
        editProfileButton.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        editProfileButton.layer.masksToBounds = true
        editProfileButton.layer.cornerRadius = editButtonCornerRadius
    }
    
    @IBAction func closeProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfile" {
            if let editProfileVCinNavigationVC = segue.destination as? UINavigationController, let editProfileVC = editProfileVCinNavigationVC.topViewController as? EditProfileViewController {
                editProfileVC.profile = profile
            }
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
}

extension ProfileViewController {
    private struct SizeRatio {
        static let editButtonCornerRadiusToEditButtonWidth: CGFloat = 0.05
        static let editButtonBorderWidth: CGFloat = 2.0
        static let imageCornerRadiusToImageHeight: CGFloat = 0.15
    }
    private var editButtonCornerRadius: CGFloat {
        return editProfileButton.bounds.width * SizeRatio.editButtonCornerRadiusToEditButtonWidth
    }
    private var imageCornerRadius: CGFloat {
        return photoImageView.bounds.width * SizeRatio.imageCornerRadiusToImageHeight
    }
}
