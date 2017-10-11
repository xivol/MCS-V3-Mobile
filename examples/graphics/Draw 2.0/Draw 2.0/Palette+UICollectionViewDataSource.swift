//
//  Palette+UICollectionViewDataSource.swift
//  Draw 2.0
//
//  Created by Илья Лошкарёв on 05.10.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

private let cellReuseIdentifier = "PaletteCell"

extension Palette: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presentInfinite ? 10_000 : colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath)
        
        cell.contentView.layer.cornerRadius = cell.bounds.width / 2
        cell.contentView.layer.borderColor = UIColor.darkGray.cgColor
        cell.contentView.layer.borderWidth = 1
        
        cell.contentView.backgroundColor = colors[indexPath.row % colors.count]
        
        return cell
    }
}

