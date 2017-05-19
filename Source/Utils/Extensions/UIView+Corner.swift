//
//  UIView+Corner.swift
//  Client
//
//  Created by aidenluo on 22/01/2017.
//  Copyright © 2017 36Kr. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    public func roundCorners(_ byRoundingCorners: UIRectCorner,
                      radius: CGFloat = 5) {
        let size = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: byRoundingCorners, cornerRadii: size)
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
