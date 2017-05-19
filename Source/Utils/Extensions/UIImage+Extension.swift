import UIKit

public extension UIImage {

    public convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, true, 1)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.init(cgImage: (image?.cgImage)!)
    }

    public var hasContent: Bool {
        return cgImage != nil || ciImage != nil
    }
    
    public func fixOrientation() -> UIImage? {
        if imageOrientation == UIImageOrientation.up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch imageOrientation {
        case UIImageOrientation.down:
            fallthrough
        case UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case UIImageOrientation.left:
            fallthrough
        case UIImageOrientation.leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        case UIImageOrientation.right:
            fallthrough
        case UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
        case UIImageOrientation.up:
            fallthrough
        case UIImageOrientation.upMirrored:
            fallthrough
        default:
            ()
        }
        
        switch imageOrientation {
        case UIImageOrientation.upMirrored:
            fallthrough
        case UIImageOrientation.downMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.leftMirrored:
            fallthrough
        case UIImageOrientation.rightMirrored:
            transform = transform.translatedBy(x: size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case UIImageOrientation.up:
            fallthrough
        case UIImageOrientation.down:
            fallthrough
        case UIImageOrientation.left:
            fallthrough
        case UIImageOrientation.right:
            fallthrough
        default:
            ()
        }
        
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: ((self.cgImage)?.bitsPerComponent)!, bytesPerRow: 0, space: ((self.cgImage)?.colorSpace)!, bitmapInfo: ((self.cgImage)?.bitmapInfo.rawValue)!)
        ctx?.concatenate(transform)
        
        switch imageOrientation {
        case UIImageOrientation.left:
            fallthrough
        case UIImageOrientation.leftMirrored:
            fallthrough
        case UIImageOrientation.right:
            fallthrough
        case UIImageOrientation.rightMirrored:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
        default:
            ctx?.draw(self.cgImage!, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
        
        if let cgImage = ctx?.makeImage() {
            return UIImage(cgImage: cgImage)
        }
        return nil
    }
}
