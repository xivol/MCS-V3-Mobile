//
//  GalleryViewCell.swift
//  advImProcessing
//
//  Created by Илья Лошкарёв on 30.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

class GalleryViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: UIImageView!
    
    var representedAssetIdentifier: String!
    
    var thumbnailImage: UIImage! {
        didSet {
            imageView.image = thumbnailImage
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage = nil
    }
}

