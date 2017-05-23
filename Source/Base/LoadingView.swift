//
//  LoadingView.swift
//  Client
//
//  Created by aidenluo on 1/14/16.
//  Copyright © 2016 36Kr. All rights reserved.
//

import UIKit
//import SVProgressHUD

public enum LoadingState {
    case initial
    case loading
    case success
    case fail
    case empty
}

public class LoadingView: UIView {
    
    var indicatorCenterYOffset: CGFloat = -64
    var imageViewCenterYOffset: CGFloat = 0
    
    let indicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_toast_loading")?.withRenderingMode(.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hex: 0x464c56)
        imageView.size = CGSize(width: 25, height: 25)
        return imageView
    }()
    
    let imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "ic_common_placeholder_nodata")
        view.sizeToFit()
        view.isHidden = true
        return view
    }()
    
    let label: UILabel = {
        let view = UILabel()
        view.backgroundColor = UIColor.clear
        view.font = UIFont.systemFont(ofSize: 14)
        view.textColor = UIColor(hex: 0x969fa9)
        view.numberOfLines = 0
        view.text = "服务器开小差，没有拿到数据\n\n请点击屏幕再试一次"
        view.textAlignment = .center
        view.sizeToFit()
        view.isHidden = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        addSubview(indicator)
        addSubview(imageView)
        addSubview(label)
    }
    
    var loadingState: LoadingState = .initial {
        didSet {
            switch loadingState {
            case .loading:
                if indicator.layer.action(forKey: "progressAnimation") == nil {
                    indicator.layer.add(RefreshAnimation.continuousRotation(), forKey: "progressAnimation")
                }
                imageView.isHidden = true
                label.isHidden = true
                indicator.isHidden = false
            case .fail:
                indicator.isHidden = true
                imageView.isHidden = false
                label.isHidden = false
            case .empty:
                indicator.isHidden = true
                imageView.isHidden = false
                label.isHidden = false
            default: break
            }
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        indicator.center = CGPoint(x: bounds.midX, y: bounds.midY + indicatorCenterYOffset)
        imageView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        imageView.top = 144 + imageViewCenterYOffset
        label.width = width - 40
        label.center = CGPoint(x: bounds.midX, y: bounds.midY)
        label.top = imageView.bottom + 10
    }

}
