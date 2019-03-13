//
//  GCDDataManager.swift
//  TinkoffChat
//
//  Created by MacBookPro on 13/03/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import Foundation

class GCDDataManager {  // TODO: make it singleton
    
    init(_ nameFilename: String = "userName.txt", _ descriptionFilename: String = "userDescription.txt", _ imageFilename: String = "userPhoto.png") {
        self.nameFilename = nameFilename
        self.descriptionFilename = descriptionFilename
        self.imageFilename = imageFilename
    }
    
    let nameFilename: String
    let descriptionFilename: String
    let imageFilename: String
    
    func readData(to profile: ProfileInfo) {
        
    }
    
    func writeData(from profile: ProfileInfo) {
        
    }
}
