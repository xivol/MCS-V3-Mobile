//
//  ViewController.swift
//  Draw 2.0
//
//  Created by Илья Лошкарёв on 04.10.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit

class ViewController: UIViewController, PaletteDelegate {
    @IBOutlet weak var imageView: DrawView!
    
    @IBOutlet weak var colorView: UIBarButtonItem!
    @IBOutlet weak var toolbar: UIToolbar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let palette = (UIApplication.shared.delegate as! AppDelegate).palette!
        palette.delegate = self
        imageView.clear()
        toolbar.setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default)
    }
    
    @IBAction func trash(_ sender: Any) {
        imageView.clear()
    }
    
    @IBAction func share(_ sender: Any) {
        let activity = UIActivityViewController(activityItems: [imageView.image as Any], applicationActivities: nil)
        present(activity, animated:true, completion:nil)
    }
    
    func palette(_ palette: Palette, didUpdateFillColor fillColor: UIColor) {
        //
    }
    
    func palette(_ palette: Palette, didUpdateStrokeColor strokeColor: UIColor) {
        imageView.strokeColor = strokeColor
        toolbar.backgroundColor = strokeColor
        toolbar.tintColor = strokeColor
    }
    
}
