//
//  DataManager.swift
//  TinkoffChat
//
//  Created by MacBookPro on 16/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class DataManager {
    init(nameFilename: String = "userName.txt", descriptionFilename: String = "userDescription.txt", imageFilename: String = "userPhoto.png") {
        self.nameFilename = nameFilename
        self.descriptionFilename = descriptionFilename
        self.imageFilename = imageFilename
    }
    
    let nameFilename: String
    let descriptionFilename: String
    let imageFilename: String
    
    let dir: URL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
    
    var nameFileURL: URL {
        return dir.appendingPathComponent(self.nameFilename)
    }
    
    var descriptionFileURL: URL {
        return dir.appendingPathComponent(self.descriptionFilename)
    }
    
    var imageFileURL: URL {
        return dir.appendingPathComponent(self.imageFilename)
    }
    
    var nameIsEditted = false
    var descriptionIsEditted = false
    var imageIsEditted = false
    
    func readDataFromFile(to profile: inout ProfileInfo) {
        print("inside readDataFromFile")
        
//        sleep(3)  // TODO: remove sleep()
        
        let nameFromFile = try? String(contentsOf: nameFileURL, encoding: .utf8)
        if let nameFromFileString = nameFromFile {
            profile.name = nameFromFileString
            print("read name: \(nameFromFileString) at \(nameFileURL)")
        }
        
        let descriptionFromFile = try? String(contentsOf: descriptionFileURL, encoding: .utf8)
        if let descriptionFromFileString = descriptionFromFile {
            profile.description = descriptionFromFileString
            print("read description: \(descriptionFromFileString) at \(descriptionFileURL)")
        }
        
        if let imageFromFile = UIImage(contentsOfFile: imageFileURL.path) {
            profile.image = imageFromFile
            print("read image at \(imageFileURL)")
        }
    }
    
    func writeDataToFile(from profile: ProfileInfo) {
        print("inside writeDataToFile")
        
//        sleep(3)  // TODO: remove sleep()
        
        if self.nameIsEditted {  // TODO: think about retain cycle with closure
            try! profile.name.write(to: nameFileURL, atomically: false, encoding: .utf8)
            print("write name: \(profile.name) at \(nameFileURL)")
        }
        
        if self.descriptionIsEditted {
            try! profile.description.write(to: descriptionFileURL, atomically: false, encoding: .utf8)
            print("write description: \(profile.description) at \(descriptionFileURL)")
        }
        
        if self.imageIsEditted {
            let data = profile.image.jpegData(compressionQuality: 1.0) ?? profile.image.pngData()!
            try! data.write(to: imageFileURL)
            print("write image at \(imageFileURL)")
        }
    }
}
