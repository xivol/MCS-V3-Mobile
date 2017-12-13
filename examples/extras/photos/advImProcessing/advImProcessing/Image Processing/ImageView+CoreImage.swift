//
//  ImageView.swift
//
//  Created by Simon Gladman on 09/01/2016.
//  Copyright © 2016 Simon Gladman. All rights reserved.
//

import GLKit
import UIKit

/// `OpenGLImageView` wraps up a `GLKView` and its delegate into a single class to simplify the
/// display of `CIImage`.
///
/// `OpenGLImageView` is hardcoded to simulate ScaleAspectFit: images are sized to retain their
/// aspect ratio and fit within the available bounds.
///
/// `OpenGLImageView` also respects `backgroundColor` for opaque colors
class OpenGLImageView: GLKView
{
    let eaglContext = EAGLContext(api: .openGLES2)!
    
    lazy var ciContext: CIContext = {
        [unowned self] in
        return CIContext(eaglContext: self.eaglContext,
                         options: [kCIContextWorkingColorSpace: NSNull()])
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame, context: eaglContext)
    }
    
    override init(frame: CGRect, context: EAGLContext)
    {
        super.init(frame: frame, context: context)
        delegate = self
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        context = self.eaglContext
        delegate = self
    }
    
    /// The image to display
    var image: CIImage? {
        didSet {
            display()
        }
    }
}

extension OpenGLImageView: GLKViewDelegate {
    
    func glkView(_ view: GLKView, drawIn rect: CGRect) {
        guard let image = image else {
            print("no image")
            return
        }
        
        let targetRect = image.extent.aspectFitInRect(
            target: CGRect(origin: CGPoint.zero,
                           size: CGSize(width: drawableWidth,
                                        height: drawableHeight)))
        
        let ciBackgroundColor = CIColor(
            color: backgroundColor ?? UIColor.white)
        
        ciContext.draw(CIImage(color: ciBackgroundColor),
                       in: CGRect(x: 0,
                                  y: 0,
                                  width: drawableWidth,
                                  height: drawableHeight),
                       from: CGRect(x: 0,
                                    y: 0,
                                    width: drawableWidth,
                                    height: drawableHeight))
        
        ciContext.draw(image,
                       in: targetRect,
                       from: image.extent)
    }
}

extension CGRect
{
    func aspectFitInRect(target: CGRect) -> CGRect
    {
        let scale: CGFloat = {
            let scale = target.width / self.width
            
            if self.height * scale <= target.height {
                return scale
            } else {
                return target.height / self.height
            }
        }()
        
        let width = self.width * scale
        let height = self.height * scale
        let x = target.midX - width / 2
        let y = target.midY - height / 2
        
        return CGRect(x: x,
                      y: y,
                      width: width,
                      height: height)
    }
}

