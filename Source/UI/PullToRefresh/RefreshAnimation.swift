//
//  RefreshAnimation.swift
//  KitDemo
//
//  Created by 杨洋 on 2017/5/22.
//  Copyright © 2017年 com.36kr. All rights reserved.
//

import Foundation
import QuartzCore

final class RefreshAnimation {
    
    class func continuousRotation() -> CAAnimation {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0
        animation.toValue = 2.0 * Double.pi
        animation.duration = 1.0
        animation.repeatCount = Float(INT_MAX)
        animation.isRemovedOnCompletion = false
        return animation
    }
}
