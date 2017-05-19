import UIKit

public extension UIView {
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        } set (value) {
            self.frame = CGRect (x: value, y: self.y, width: self.width, height: self.height)
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        } set (value) {
            self.frame = CGRect (x: self.x, y: value, width: self.width, height: self.height)
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: value, height: self.height)
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        } set (value) {
            self.frame = CGRect (x: self.x, y: self.y, width: self.width, height: value)
        }
    }
    
    public var left: CGFloat {
        get {
            return self.x
        } set (value) {
            self.x = value
        }
    }
    
    public var right: CGFloat {
        get {
            return self.x + self.width
        } set (value) {
            self.x = value - self.width
        }
    }
    
    public var top: CGFloat {
        get {
            return self.y
        } set (value) {
            self.y = value
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.y + self.height
        } set (value) {
            self.y = value - self.height
        }
    }
    
    public var position: CGPoint {
        get {
            return self.frame.origin
        } set (value) {
            self.frame = CGRect (origin: value, size: self.frame.size)
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        } set (value) {
            self.frame = CGRect (origin: self.frame.origin, size: value)
        }
    }
    
    public func leftWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.left - offset
    }
    
    public func rightWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.right + offset
    }
    
    public func topWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.top - offset
    }
    
    public func bottomWithOffset (_ offset: CGFloat) -> CGFloat {
        return self.bottom + offset
    }
}

