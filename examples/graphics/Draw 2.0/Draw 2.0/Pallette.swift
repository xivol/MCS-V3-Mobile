//
//  Palette.swift
//  Draw 2.0
//
//  Created by Илья Лошкарёв on 04.10.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit


class Palette {
    let colors: [UIColor]
    
    private var indexStroke = 0
    private var indexFill = 0
    
    var stroke: UIColor {
        get { return colors[indexStroke] }
        set {
            if let newStroke = colors.index(of: newValue) {
                indexStroke = newStroke
            }
        }
    }
    
    var fill: UIColor {
        get { return colors[indexFill] }
        set {
            if let newFill = colors.index(of: newValue) {
                indexStroke = newFill
            }
        }
    }
    
    init(_ colors: [UIColor])  {
        self.colors = colors
    }
    
    convenience init() {
        let all_colors = [UIColor.black, UIColor.darkGray, UIColor.gray, UIColor.lightGray, UIColor.white,UIColor.orange, UIColor.red,  UIColor.yellow, UIColor.green, UIColor.cyan, UIColor.blue, UIColor.purple,UIColor.magenta, UIColor.brown,]
        self.init(all_colors)
    }
}
