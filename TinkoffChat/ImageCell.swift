//
//  ImageCell.swift
//  TinkoffChat
//
//  Created by MacBookPro on 17/04/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!

    
    func configureCell(from imageData: ImageData) {
//        backgroundColor = UIColor(displayP3Red: CGFloat(arc4random_uniform(255))/256, green: 170.0/256, blue: 255.0/256, alpha: 1.0)
        imageView.image = UIImage(named: "image_placeholder")
    }
}
