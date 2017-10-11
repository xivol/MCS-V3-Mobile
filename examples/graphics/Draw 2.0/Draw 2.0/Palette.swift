//
//  Palette.swift
//  Draw 2.0
//
//  Created by Илья Лошкарёв on 04.10.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit
protocol PaletteDelegate: class {
    func palette(_ palette: Palette, didUpdateStrokeColor strokeColor: UIColor)
    func palette(_ palette: Palette, didUpdateFillColor fillColor: UIColor)
}

class Palette: NSObject {
    
    weak var delegate: PaletteDelegate?
    
    let colors: [UIColor]
    
    private var indexStroke = 0
    private var indexFill = 0
    
    var stroke: UIColor {
        get { return colors[indexStroke] }
        set {
            if let newStroke = colors.index(of: newValue) {
                indexStroke = newStroke
                delegate?.palette(self, didUpdateStrokeColor: colors[indexStroke])
            }
        }
    }
    
    var fill: UIColor {
        get { return colors[indexFill] }
        set {
            if let newFill = colors.index(of: newValue) {
                indexStroke = newFill
                delegate?.palette(self, didUpdateFillColor: colors[indexFill])
            }
        }
    }
    
    func color(at index: Int) -> UIColor
    {
        return colors[index % colors.count]
    }
    
    var presentInfinite: Bool = true
    
    init(_ colors: [UIColor])  {
        self.colors = colors
        super.init()
    }
    
    override convenience init() {
        let all_colors = [ UIColor.brown, UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green, UIColor.cyan, UIColor.blue, UIColor.magenta, UIColor.purple, UIColor.black, UIColor.darkGray, UIColor.gray, UIColor.lightGray, UIColor.white]
        self.init(all_colors)
    }
    
}
