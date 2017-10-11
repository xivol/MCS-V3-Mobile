//
//  PaletteCollectionViewController.swift
//  Draw 2.0
//
//  Created by Илья Лошкарёв on 04.10.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

class PaletteCollectionViewController: UICollectionViewController {

    weak var palette: Palette?
    var firstLayout: Bool = true
    
    var numberOfColorsToDisplay: Int {
        return self.collectionView?.dataSource?.collectionView(collectionView!, numberOfItemsInSection: 0) ?? 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        palette = (UIApplication.shared.delegate as! AppDelegate).palette
        collectionView?.dataSource = palette
        // Select middle item
        selectColor(at: numberOfColorsToDisplay / 2)
        
    }
    
    func selectColor(at position: Int) {
        palette?.stroke = palette?.color(at: position) ?? UIColor.white
        collectionView?.selectItem(at: IndexPath(indexes: [0, position]), animated: false, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Select middle item if selection cleared
        if self.clearsSelectionOnViewWillAppear {
            selectColor(at: numberOfColorsToDisplay / 2)
        }
        firstLayout = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // On first appear scroll to selected item
        if firstLayout {
            collectionView?.scrollToItem(at: collectionView?.indexPathsForSelectedItems?[0] ?? IndexPath(), at: .centeredHorizontally, animated: false)
            firstLayout = false
        }
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        palette?.stroke = palette?.color(at: indexPath.row) ?? UIColor.white
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }

}
