//  https://github.com/shu223/iOS-10-Sampler/blob/master/iOS-10-Sampler/Samples/PropertyAnimatorViewController.swift
//
//  PropertyAnimatorViewController.swift
//  Created by Shuichi Tsutsumi on 9/10/16.
//  Copyright © 2016 Shuichi Tsutsumi. All rights reserved.
//
import UIKit
import PlaygroundSupport

class PropertyAnimatorViewController: UIViewController {
    
    private var targetLocation: CGPoint!
    
    private var objectView: UIView!
    private let spring = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        objectView = UIView(frame: CGRect(origin: view.bounds.origin, size: CGSize(width: 50, height: 50)))
        objectView.backgroundColor = colorAt(location: objectView.center)
        view.addSubview(objectView)
        targetLocation = objectView.center
    }
    
    private func colorAt(location: CGPoint) -> UIColor {
        let hue: CGFloat = (location.x / UIScreen.main.bounds.width + location.y / UIScreen.main.bounds.height) / 2
        return UIColor(hue: hue, saturation: 0.78, brightness: 0.75, alpha: 1)
    }
    
    private func processTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else {return}
        let loc = touch.location(in: view)
        
        if loc == targetLocation {
            return
        }
        
        animateTo(location: loc)
    }
    
    private func animateTo(location: CGPoint) {
        var duration: TimeInterval
        var timing: UITimingCurveProvider
        if !spring {
            duration = 0.4
            timing = UICubicTimingParameters(animationCurve: .easeOut)
        } else {
            duration = 0.6
            timing = UISpringTimingParameters(dampingRatio: 0.5)
        }
        
        let animator = UIViewPropertyAnimator(
            duration: duration,
            timingParameters: timing)
        
        animator.addAnimations {
            self.objectView.center = location
            self.objectView.backgroundColor = self.colorAt(location: location)
        }
        
        animator.startAnimation()
        
        targetLocation = location
    }
    
    // =========================================================================
    // MARK: - Touch handlers
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        processTouches(touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        processTouches(touches)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = PropertyAnimatorViewController()
