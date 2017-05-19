//
//  UIImageView+Utils.swift
//  Client
//
//  Created by 孟冰川 on 15/12/14.
//  Copyright © 2015年 36Kr. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func transformToCycle(_ radius: CGFloat){
        let maskLayer = CAShapeLayer()
        let roundedPath = UIBezierPath(arcCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: 0, endAngle: CGFloat(Double.pi * 2.0), clockwise: true)
        maskLayer.path = roundedPath.cgPath
        self.layer.mask = maskLayer;
    }
    
}


