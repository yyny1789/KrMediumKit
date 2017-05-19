//
//  UIView+Snapshot.swift
//  Client
//
//  Created by aidenluo on 8/19/16.
//  Copyright © 2016 36Kr. All rights reserved.
//

import Foundation
import UIKit

public extension UIView {
    
    public func snapshot(_ scale: CGFloat = UIScreen.main.scale) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, scale);
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot!
    }
    
}
