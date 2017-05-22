//
//  RefreshView.swift
//  Client
//
//  Created by aidenluo on 12/6/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

import UIKit

class RefreshDefaultView: RefreshView {
    
    let circleLayer = CAShapeLayer()
    
    var lineWidth: CGFloat = 1.5 {
        didSet {
            circleLayer.lineWidth = lineWidth
            setNeedsLayout()
        }
    }
    
    var animating: Bool = true {
        didSet {
            updateAnimation()
        }
    }
    
    var radius: CGFloat = 12.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    
    var strokeEnd: CGFloat = 1.5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    let strokeEndAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = HUGE
        group.animations = [animation]
        
        return group
    }()
    
    let strokeStartAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "strokeStart")
        animation.beginTime = 0.5
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 2
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        
        let group = CAAnimationGroup()
        group.duration = 2.5
        group.repeatCount = HUGE
        group.animations = [animation]
        
        return group
    }()
    
    let rotationAnimation: CAAnimation = {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = Double.pi * 2
        animation.duration = 1.0
        animation.repeatCount = HUGE
        return animation
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func tintColorDidChange() {
        super.tintColorDidChange()
        circleLayer.strokeColor = tintColor.cgColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let radius = self.radius
        let startAngle = CGFloat(-Double.pi)
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        circleLayer.position = center
        circleLayer.path = path.cgPath
        circleLayer.strokeEnd = self.strokeEnd
    }
    
    func setup() {
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = nil
        layer.addSublayer(circleLayer)
        tintColorDidChange()
        updateAnimation()
        self.tintColor = UIColor(hex: 0x464c56)
    }
    
    func updateAnimation() {
        if animating {
            circleLayer.add(strokeEndAnimation, forKey: "strokeEnd")
            circleLayer.add(strokeStartAnimation, forKey: "strokeStart")
            circleLayer.add(rotationAnimation, forKey: "rotation")
        }
        else {
            circleLayer.removeAnimation(forKey: "strokeEnd")
            circleLayer.removeAnimation(forKey: "strokeStart")
            circleLayer.removeAnimation(forKey: "rotation")
        }
    }
    
    override func animateState(_ state: RefresherState) {
        switch state {
        case .initial:
            animating = false
            strokeEnd = 0
        case .pulling(let progress):
            strokeEnd = progress
        case .loading:
            animating = true
        case .finished:
            break
        }
    }
    
}
