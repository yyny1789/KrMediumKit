//
//  UIPanGestureRecognizer+Direction.swift
//  Client
//
//  Created by aidenluo on 9/2/16.
//  Copyright © 2016 36Kr. All rights reserved.
//

import Foundation
import UIKit

public enum Direction: Int {
    case up
    case down
    case left
    case right
    
    var isX: Bool { return self == .left || self == .right }
    var isY: Bool { return !isX }
}

public extension UIPanGestureRecognizer {
    
    public var direction: Direction? {
        let velocity = self.velocity(in: view)
        let vertical = fabs(velocity.y) > fabs(velocity.x)
        switch (vertical, velocity.x, velocity.y) {
        case (true, _, let y) where y < 0: return .up
        case (true, _, let y) where y > 0: return .down
        case (false, let x, _) where x > 0: return .right
        case (false, let x, _) where x < 0: return .left
        default: return nil
        }
    }
}
