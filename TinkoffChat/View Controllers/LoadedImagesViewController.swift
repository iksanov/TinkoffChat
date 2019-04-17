//
//  LoadedImagesViewController.swift
//  TinkoffChat
//
//  Created by MacBookPro on 17/04/2019.
//  Copyright © 2019 Iksanov. All rights reserved.
//

import UIKit

class LoadedImagesViewController: UIViewController {

    private let reuseIdentifier = "loaded image cell"

    @IBOutlet var loadedImagesCV: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        loadedImagesCV.delegate = self
        loadedImagesCV.dataSource = self
        
        ImageLoadManager.shared.loadImageData()
    }
    

    
//    var loadResults
    
    private func getImageData(for indexPath: IndexPath) -> ImageData {
        return ImageData(number: 42)
    }
}

extension LoadedImagesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension LoadedImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 300
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = loadedImagesCV.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        if let imageCell = cell as? ImageCell {
            let loadedImageInfo = getImageData(for: indexPath)
            imageCell.configureCell(from: loadedImageInfo)
        }
        
        return cell
    }
}

extension LoadedImagesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let paddingSpace: CGFloat = SizeConstants.horizontalInset * (SizeConstants.itemsPerRow + 1)
        let availableWidth = view.bounds.width - paddingSpace
        let widthPerItem = availableWidth / SizeConstants.itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // TODO: make equal spacing everywhere (like in the task)
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return SizeConstants.horizontalInset
//    }
    
//    func collectionView(_ collectionView: UICollectionView,
//                        layout collectionViewLayout: UICollectionViewLayout,
//                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return SizeConstants.horizontalInset
//    }
}

extension LoadedImagesViewController {
    struct SizeConstants {
        static let itemsPerRow: CGFloat = 3
        static let horizontalInset: CGFloat = 20.0
        static let verticalInset: CGFloat = 50.0
    }
    
    var sectionInsets: UIEdgeInsets {
        return UIEdgeInsets(top: SizeConstants.verticalInset,
                            left: SizeConstants.horizontalInset,
                            bottom: SizeConstants.verticalInset,
                            right: SizeConstants.horizontalInset)
    }
}
