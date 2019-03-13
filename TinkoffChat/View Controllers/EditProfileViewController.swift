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
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var GCDButton: UIButton!
    @IBOutlet var operationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        descriptionTextView.delegate = self
        activityIndicator.hidesWhenStopped = true
        activityIndicator.stopAnimating()
        
        GCDButton.isEnabled = false
        operationButton.isEnabled = false
    }

    var gcdDataManager = GCDDataManager()
    var operationDataManager = OperationDataManager()
    var profile = ProfileInfo()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        photoImageView.image = profile.image
    }
    
    @IBAction func cancelEditProfile(_ sender: Any) {
        dismiss(animated: true, completion: nil)  // TODO: think of resetting booleans in DataManagers
        
        gcdDataManager.nameIsEditted = false
        gcdDataManager.descriptionIsEditted = false
        gcdDataManager.imageIsEditted = false
        
        operationDataManager.nameIsEditted = false
        operationDataManager.descriptionIsEditted = false
        operationDataManager.imageIsEditted = false
    }
    
    // You can press Done button to hide keyboard
    @IBAction func finishEditing(_ sender: Any) {
        nameTextField.endEditing(true)
        descriptionTextView.endEditing(true)
    }
    
    @IBAction func saveWithGCD(_ sender: Any) {
        profile.name = nameTextField.text ?? "No text was there"
        profile.description = descriptionTextView.text
        profile.image = photoImageView.image!
                
        activityIndicator.startAnimating()
        gcdDataManager.writeDataToFile(from: profile)
        activityIndicator.stopAnimating()
    }
    
    @IBAction func saveWithOperation(_ sender: Any) {
        profile.name = nameTextField.text ?? "No text was there"
        profile.description = descriptionTextView.text
        profile.image = photoImageView.image!
        
        activityIndicator.startAnimating()
        operationDataManager.writeDataToFile(from: profile)
        activityIndicator.stopAnimating()
    }
}

extension EditProfileViewController: UITextViewDelegate {  // TODO: also make buttons inactive
    func textViewDidChange(_ textView: UITextView) {  // TODO: handle case of editing sum = 0
        gcdDataManager.descriptionIsEditted = true
        operationDataManager.descriptionIsEditted = true
        
        GCDButton.isEnabled = true
        operationButton.isEnabled = true
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {  // TODO: is called after everu letter
        gcdDataManager.nameIsEditted = true
        operationDataManager.descriptionIsEditted = true
    }
}
