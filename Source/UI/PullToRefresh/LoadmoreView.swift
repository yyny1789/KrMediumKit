//
//  LoadmoreView.swift
//  Client
//
//  Created by aidenluo on 12/6/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

import UIKit

class LoadmoreDefaultView: LoadmoreView {
    
    let indicator: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ic_toast_loading")?.withRenderingMode(.alwaysTemplate)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor(hex: 0x464c56)
        imageView.size = CGSize(width: 25, height: 25)
        return imageView
    }()
    
    let tip: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor(hex: 0x969fa9)
        label.isUserInteractionEnabled = true
        return label
    }()
    
    var leftLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe7e7e7)
        view.bounds.size = CGSize(width: 25, height: 1)
        return view
    }()
    
    var rightLine: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xe7e7e7)
        view.bounds.size = CGSize(width: 25, height: 1)
        return view
    }()
    
    
    var animating: Bool = true {
        didSet {
            updateAnimation()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        indicator.center = center
        tip.sizeToFit()
        tip.center = center
        leftLine.center = center
        leftLine.frame.origin.x = tip.frame.origin.x - leftLine.frame.size.width - 10
        rightLine.center = center
        rightLine.frame.origin.x = tip.frame.origin.x + tip.frame.size.width + 10
    }
    
    func setup() {
        addSubview(indicator)
        addSubview(tip)
        addSubview(leftLine)
        addSubview(rightLine)
        tip.isHidden = true
        leftLine.isHidden = true
        rightLine.isHidden = true
    }
    
    func updateAnimation() {
        indicator.layer.removeAllAnimations()
        if animating {
            indicator.layer.add(RefreshAnimation.continuousRotation(), forKey: "progressAnimation")
        }
    }

    override func animateState(_ state: LoadmoreState) {
        switch state {
        case .initial:
            animating = false
            indicator.isHidden = false
            tip.isHidden = true
            leftLine.isHidden = true
            rightLine.isHidden = true
        case .loading:
            animating = true
            indicator.isHidden = false
            tip.isHidden = true
            leftLine.isHidden = true
            rightLine.isHidden = true
        case .finished(let hasMore):
            animating = false
            if !hasMore {
                tip.isHidden = false
                tip.text = "喂喂，你碰到我的底线了"
                leftLine.isHidden = false
                rightLine.isHidden = false
                indicator.isHidden = true
                setNeedsLayout()
            }
        case .error:
            animating = false
            tip.isHidden = false
            tip.text = "点击重新加载"
            leftLine.isHidden = false
            rightLine.isHidden = false
            indicator.isHidden = true
            setNeedsLayout()
        }
    }
}
