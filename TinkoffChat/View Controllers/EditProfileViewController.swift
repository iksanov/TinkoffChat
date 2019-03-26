//
//  EditProfileViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 13/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var photoChooser: UIButton!  // TODO: set width from code (using constant)

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!  // test hugging and comression for different content volume
    @IBOutlet var descriptionTextView: UITextView!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet var GCDButton: UIButton!
    @IBOutlet var operationButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidesWhenStopped = true
        descriptionTextView.delegate = self
        nameTextField.delegate = self
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameTextField.returnKeyType = .done
        nameTextField.clearButtonMode = .whileEditing
        
        configureButtons()
        
        nameTextField.text = profile.name
        descriptionTextView.text = profile.description
        photoImageView.image = profile.image
        
        registerForKeyboardNotifications()
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
    
    private func registerForKeyboardNotifications() {  // TODO: fix keyboard managing for iPhones without home buttons
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)  // TODO: check documentation
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)  // TODO: try to remove (_:)
    }
    
    @objc func keyboardWasShown(_ notification: Notification) {  // TODO: add scrollView and finish guide from bookmarks
        let info = notification.userInfo
        if let keyboardSize = (info?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        let info = notification.userInfo
        if let keyboardSize = (info?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            }
        }
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

    var storageManager: StorageManager {
        return ((presentingViewController as! UINavigationController).topViewController! as! ProfileViewController).storageManager
    }
//    var gcdDataManager: GCDDataManager {
//        return ((presentingViewController as! UINavigationController).topViewController! as! ProfileViewController).gcdDataManager
//    }
//    var operationDataManager: OperationDataManager {
//        return ((presentingViewController as! UINavigationController).topViewController! as! ProfileViewController).operationDataManager
//    }
//    var usingGCDInstedOfOperation: Bool {
//        get {
//            return ((presentingViewController as! UINavigationController).topViewController! as! ProfileViewController).usingGCDInstedOfOperation
//        }
//        set {
//            ((presentingViewController as! UINavigationController).topViewController! as! ProfileViewController).usingGCDInstedOfOperation = newValue
//        }
//    }
    var profile = ProfileInfo()
    
    var nameIsEditted: Bool {
        return nameTextField.text! != profile.name
    }
    
    var descriptionIsEditted: Bool {
        return descriptionTextView.text != profile.description
    }
    
    var imageIsEditted: Bool {  // TODO: it always returns True
        return photoImageView.image! != profile.image  // TODO: think about equality of images (ref or obj)
    }
    
    private func prepareDataFromViewForSaving() {
        if nameIsEditted {
//            gcdDataManager.nameIsEditted = true
//            operationDataManager.nameIsEditted = true
            
            profile.name = nameTextField.text!
        }
        
        if descriptionIsEditted {
//            gcdDataManager.descriptionIsEditted = true
//            operationDataManager.descriptionIsEditted = true
            
            profile.description = descriptionTextView.text
        }
        
        if imageIsEditted {
//            gcdDataManager.imageIsEditted = true
//            operationDataManager.imageIsEditted = true
            
            profile.image = photoImageView.image!
        }
    }
    
    private func writeDataToFileFromProfile() {
        activityIndicator.startAnimating()
        prepareDataFromViewForSaving()
//        if usingGCDInstedOfOperation {
//            gcdDataManager.writeDataToFile(from: profile)
//        } else {
//            operationDataManager.writeDataToFile(from: profile)
//        }
        storageManager.coreDataStack.saveContext.performAndWait {
            storageManager.saveData(from: profile, with: storageManager.coreDataStack.saveContext)  // TODO: understand which context is necessary
        }
        activityIndicator.stopAnimating()
        disableButtons()
    }
    
    @IBAction func saveWithGCD(_ sender: Any) {
        endEditingBothNameAndDescription()
//        usingGCDInstedOfOperation = true
        writeDataToFileFromProfile()
    }
    
    @IBAction func saveWithOperation(_ sender: Any) {
        endEditingBothNameAndDescription()
//        usingGCDInstedOfOperation = false
        writeDataToFileFromProfile()
    }
    
    @IBAction func cancelEditProfile(_ sender: Any) {
        endEditingBothNameAndDescription()
        
//        gcdDataManager.nameIsEditted = false  // TODO: move this code into a function
//        gcdDataManager.descriptionIsEditted = false
//        gcdDataManager.imageIsEditted = false
//        
//        operationDataManager.nameIsEditted = false
//        operationDataManager.descriptionIsEditted = false
//        operationDataManager.imageIsEditted = false
        
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

extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if nameIsEditted || descriptionIsEditted || imageIsEditted {  // replace by descriptionIsEditted only
            enableButtons()
        } else {
            disableButtons()
        }
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            photoImageView.image = image
            if imageIsEditted {
                enableButtons()
            } else {
                print("Image wasn't editted")
                disableButtons()
            }
            if picker.sourceType == .camera {
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController {
    private struct SizeRatio {
        static let chooserCornerRadiusToChooserWidth: CGFloat = 0.5
        static let chooserImageInsetToChooserWidth: CGFloat = 0.25
    }
    private struct ColorConstants {
        static let disabledButtonsAlpha: CGFloat = 0.3
    }
    private var chooserCornerRadius: CGFloat {
        return photoChooser.bounds.width * SizeRatio.chooserCornerRadiusToChooserWidth
    }
    private var chooserImageInset: CGFloat {
        return photoChooser.bounds.width * SizeRatio.chooserImageInsetToChooserWidth
    }
}
