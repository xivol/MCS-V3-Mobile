//
//  PhotoController.swift
//  advImProcessing
//
//  Created by Илья Лошкарёв on 28.11.2017.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit
import Photos

protocol AssetDataSource {
    var asset: PHAsset! { get }
}

class PhotoController: UIViewController, AssetDataSource {
    
    var asset: PHAsset!
    
    let imageManager = PHCachingImageManager()

    @IBOutlet weak var imageView: OpenGLImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard asset != nil else {return}
        
        imageManager.requestImage(for: asset, targetSize: imageView.bounds.size,
                                 contentMode: .aspectFit, options: nil) {
            [weak self] image, info in
            if let image = image {
                self?.imageView.image = CIImage(image: image)
            }
        }
    }
    
    @IBAction func unwindToPhoto(with segue: UIStoryboardSegue) {
        guard let source = segue.source as? AssetDataSource else { return }
        asset = source.asset
    }

}

