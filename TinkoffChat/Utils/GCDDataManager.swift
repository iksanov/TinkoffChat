//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by MacBookPro on 13/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class GCDDataManager: DataManager {  // TODO: make it singleton
    
    // TODO: try to insert sleep(10) inside
    // (to check loading process with activity indicator and order of filling UI elements with content in ProfileVC)
    override func readDataFromFile(to profile: inout ProfileInfo) {
        super.readDataFromFile(to: &profile)
//        DispatchQueue.init(label: "gcdQueue").async {
//            let dispatchGroup = DispatchGroup()
//
//            guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { assert(false) }
//
//            let nameFileURL = dir.appendingPathComponent(self.nameFilename)
//            dispatchGroup.enter()
//            let nameFromFile = try? String(contentsOf: nameFileURL, encoding: .utf8)
//            if let nameFromFileString = nameFromFile {
//                profile.name = nameFromFileString
//            }
//            dispatchGroup.leave()
//
//            let descriptionFileURL = dir.appendingPathComponent(self.descriptionFilename)
//            dispatchGroup.enter()
//            let descriptionFromFile = try? String(contentsOf: descriptionFileURL, encoding: .utf8)
//            if let descriptionFromFileString = descriptionFromFile {
//                profile.description = descriptionFromFileString
//            }
//            dispatchGroup.leave()
//
//            let imageFileURL = dir.appendingPathComponent(self.imageFilename)
//            dispatchGroup.enter()
//            if let imageFromFile = UIImage(contentsOfFile: imageFileURL.path) {
//                profile.image = imageFromFile
//            }
//            dispatchGroup.leave()
//
//            dispatchGroup.wait()
//        }
    }
    
    override func writeDataToFile(from profile: ProfileInfo) {
        super.writeDataToFile(from: profile)
//        DispatchQueue.init(label: "gcdQueue").async {
//
//            let dispatchGroup = DispatchGroup()
//
//            guard let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { assert(false) }
//
//            if self.nameIsEditted {  // TODO: think about retain cycle with closure
//                print("SAVING NAME in GCD")
//                dispatchGroup.enter()
//                let fileURL = dir.appendingPathComponent(self.nameFilename)
//                do {
//                    try profile.name.write(to: fileURL, atomically: false, encoding: .utf8)
//                }
//                catch { assert(false) }
//                dispatchGroup.leave()
//            }
//
//
//            if self.descriptionIsEditted {  // TODO: make them parallel
//                print("SAVING DESCRIPTION in GCD")
//                dispatchGroup.enter()
//                let fileURL = dir.appendingPathComponent(self.descriptionFilename)
//                do {
//                    try profile.description.write(to: fileURL, atomically: false, encoding: .utf8)
//                }
//                catch { assert(false) }
//                dispatchGroup.leave()
//            }
//
//            if self.imageIsEditted {
//                print("SAVING IMAGE in GCD")
//                dispatchGroup.enter()
//                let fileURL = dir.appendingPathComponent(self.imageFilename)
//
//                guard let data = profile.image.jpegData(compressionQuality: 1.0) ?? profile.image.pngData() else { assert(false) }
//                try? data.write(to: fileURL)
//                dispatchGroup.leave()
//            }
//
//            dispatchGroup.wait()
//        }
    }
}
