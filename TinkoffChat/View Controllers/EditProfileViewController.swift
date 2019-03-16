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
    @IBOutlet var nameTextField: UITextField!  // test hugging and comression for different content volume
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var GCDButton: UIButton!
    @IBOutlet var operationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        nameTextField.delegate = self
        descriptionTextView.delegate = self
        activityIndicator.hidesWhenStopped = true
        
        configureButtons()
        
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        photoImageView.image = profile.image
        
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if nameIsEditted || descriptionIsEditted || imageIsEditted {  // replace by nameIsEditted only
            enableButtons()
        } else {
            disableButtons()
        }
    }
    
    private func configureButtons() {
        GCDButton.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .disabled)
        GCDButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        operationButton.setTitleColor(#colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), for: .disabled)
        operationButton.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        
        disableButtons()
    }
    
    private func disableButtons() {
        GCDButton.isEnabled = false
        GCDButton.backgroundColor = GCDButton.backgroundColor?.withAlphaComponent(ColorConstants.disabledButtonsAlpha)

        operationButton.isEnabled = false
        operationButton.backgroundColor = operationButton.backgroundColor?.withAlphaComponent(ColorConstants.disabledButtonsAlpha)
    }
    
    private func enableButtons() {
        GCDButton.isEnabled = true
        GCDButton.backgroundColor = GCDButton.backgroundColor?.withAlphaComponent(1.0)
        
        operationButton.isEnabled = true
        operationButton.backgroundColor = operationButton.backgroundColor?.withAlphaComponent(1.0)
    }

    var gcdDataManager: GCDDataManager {
        return ((presentingViewController as! UINavigationController).topViewController! as! ProfileViewController).gcdDataManager
    }
    var operationDataManager: OperationDataManager {
        return ((presentingViewController as! UINavigationController).topViewController! as! ProfileViewController).operationDataManager
    }
    var usingGCDInstedOfOperation: Bool {
        get {
            return ((presentingViewController as! UINavigationController).topViewController! as! ProfileViewController).usingGCDInstedOfOperation
        }
        set {
            ((presentingViewController as! UINavigationController).topViewController! as! ProfileViewController).usingGCDInstedOfOperation = newValue
        }
    }
    var profile = ProfileInfo()
    
    var nameIsEditted: Bool {
        return nameTextField.text! != profile.name
    }
    
    var descriptionIsEditted: Bool {
        return descriptionTextView.text != profile.description
    }
    
    var imageIsEditted: Bool {  // TODO: think about equality of images (ref or obj)
        return photoImageView.image! != profile.image
    }
    
    private func prepareDataFromViewForSaving() {
        if nameIsEditted {
            gcdDataManager.nameIsEditted = true
            operationDataManager.nameIsEditted = true
            
            profile.name = nameTextField.text!
        }
        
        if descriptionIsEditted {
            gcdDataManager.descriptionIsEditted = true
            operationDataManager.descriptionIsEditted = true
            
            profile.description = descriptionTextView.text
        }
        
        if imageIsEditted {
            gcdDataManager.imageIsEditted = true
            operationDataManager.imageIsEditted = true
            
            profile.image = photoImageView.image!
        }
    }
    
    private func writeDataToFileFromProfile() {
        activityIndicator.startAnimating()
        prepareDataFromViewForSaving()
        if usingGCDInstedOfOperation {
            gcdDataManager.writeDataToFile(from: profile)
        } else {
            operationDataManager.writeDataToFile(from: profile)
        }
        activityIndicator.stopAnimating()
        disableButtons()
    }
    
    @IBAction func saveWithGCD(_ sender: Any) {
        endEditingBothNameAndDescription()
        usingGCDInstedOfOperation = true
        writeDataToFileFromProfile()
    }
    
    @IBAction func saveWithOperation(_ sender: Any) {
        endEditingBothNameAndDescription()
        usingGCDInstedOfOperation = false
        writeDataToFileFromProfile()
    }
    
    @IBAction func cancelEditProfile(_ sender: Any) {
        endEditingBothNameAndDescription()
        
        gcdDataManager.nameIsEditted = false  // TODO: move this code into a function
        gcdDataManager.descriptionIsEditted = false
        gcdDataManager.imageIsEditted = false
        
        operationDataManager.nameIsEditted = false
        operationDataManager.descriptionIsEditted = false
        operationDataManager.imageIsEditted = false
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishEditing(_ sender: Any) {  // TODO: add tap gesture to whole view to close the keyboard
        endEditingBothNameAndDescription()
    }
    
    private func endEditingBothNameAndDescription(force: Bool = true) {
        nameTextField.endEditing(force)
        descriptionTextView.endEditing(force)
    }
}

//extension EditProfileViewController: UITextFieldDelegate {
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//    }
//}

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if nameIsEditted || descriptionIsEditted || imageIsEditted {  // replace by descriptionIsEditted only
            enableButtons()
        } else {
            disableButtons()
        }
    }
}

extension EditProfileViewController {
    private struct ColorConstants {
        static let disabledButtonsAlpha: CGFloat = 0.3
    }
}
