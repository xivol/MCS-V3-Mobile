//
//  DrawView.swift
//  Draw 2.0
//
//  Created by Илья Лошкарёв on 04.10.17.
//  Copyright © 2017 Илья Лошкарёв. All rights reserved.
//

import UIKit
import Foundation

class DrawView: UIImageView {
    
    var strokeWidth: CGFloat = 10.0
    var strokeColor = UIColor.blue
    var lastPoint = CGPoint.zero
    
    weak var palette: Palette?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            lastPoint = touch.location(in: self)
            drawLine(from: lastPoint, to: lastPoint)
            
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let touch = touches.first {
            let currentPoint = touch.location(in: self)
            drawLine(from: lastPoint, to: currentPoint)
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
    }
    
    func drawLine(from fromPoint: CGPoint, to toPoint:CGPoint) {
        UIGraphicsBeginImageContext(self.bounds.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setAllowsAntialiasing(true)
        
        self.image?.draw(in: self.bounds)
        
        let linePath = UIBezierPath()
        
        linePath.move(to: fromPoint)
        linePath.addLine(to: toPoint)
        
        let dist = hypot(fromPoint.x - toPoint.x, fromPoint.y - toPoint.y)
        
        linePath.lineWidth = 1 + strokeWidth * exp(-min(dist, 20)/20)
        linePath.lineCapStyle = .round
        linePath.lineJoinStyle = .round
        
        strokeColor.setStroke()
        linePath.stroke()
        
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    func clear() {
        UIGraphicsBeginImageContext(self.bounds.size)
        let rect = UIBezierPath(rect: self.bounds)
        UIColor.white.setFill()
        rect.fill()
        self.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }

}
