import UIKit

public extension UIView {

  public func optimize() {
    clipsToBounds = true
    layer.drawsAsynchronously = true
    isOpaque = true
  }
}
