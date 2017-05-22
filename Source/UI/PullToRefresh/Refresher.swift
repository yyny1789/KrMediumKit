//
//  PullToRefresh.swift
//  PullToPlanet
//
//  Created by aidenluo on 12/1/15.
//  Copyright © 2015 aiden. All rights reserved.
//

import UIKit
import Foundation

// MARK: - State

enum RefresherState: Equatable {
    case initial
    case loading
    case finished
    case pulling(progress: CGFloat)
}

func ==(lhs: RefresherState, rhs: RefresherState) -> Bool {
    switch (lhs, rhs) {
    case (.initial, .initial): return true
    case (.loading, .loading): return true
    case (.finished, .finished): return true
    case (.pulling, .pulling): return true
    default: return false
    }
}


class RefreshView: UIView {
    
    var viewheight: CGFloat = 64 {
        didSet {
            setNeedsLayout()
        }
    }
    
    var yPosition: CGFloat = 64
    
    func animateState(_ state: RefresherState) {
        
    }
}

class RefreshTipView: UIView {
    
    var viewHeight: CGFloat = 30
    
    var contentInsetTopWhenShowing: CGFloat = 50
    
    fileprivate(set) var tipLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    fileprivate func commonInit() {
        tipLabel.textAlignment = .center
        addSubview(tipLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tipLabel.frame = bounds
    }
 
    override func sizeToFit() {
        let inset: CGFloat = 15
        tipLabel.sizeToFit()
        var width = 2 * inset + tipLabel.size.width
        if width > UIScreen.main.bounds.width {
            width = UIScreen.main.bounds.width
        }
        frame = CGRect(x: (UIScreen.main.bounds.width - width) / 2, y: 0, width: width, height: viewHeight)
    }
    
}

// MARK: - Refresher

public class Refresher: NSObject {
    
    var view: RefreshView
    var action: VoidClosureType?
    var scrollViewDefaultInsets = UIEdgeInsets.zero
    var finishedMessage: String? {
        didSet {
            if tipView == nil {
                tipView = RefreshTipView(frame: CGRect.zero)
            }
        }
    }
    var tipView: RefreshTipView? {
        didSet {
            tipView?.backgroundColor = UIColor(hex: 0x4285F4)
            tipView?.tipLabel.textColor = UIColor.white
            tipView?.tipLabel.font = UIFont.systemFont(ofSize: 12)
            tipView?.layer.shadowColor = UIColor(hex: 0x4285F4).cgColor
            tipView?.layer.shadowOffset = CGSize(width: 0, height: 2)
            tipView?.layer.shadowRadius = 6
            tipView?.layer.shadowOpacity = 0.5
       }
    }
    var isTipViewShowing: Bool = false
    
    fileprivate var previousScrollViewOffset: CGPoint = CGPoint.zero
    fileprivate var hasAddObserver = false
    weak var scrollView: UIScrollView? {
        didSet {
            if let scrollView = scrollView {
                scrollViewDefaultInsets = scrollView.contentInset
                scrollView.addSubview(view)
                view.frame = CGRect(x: 0, y: -view.yPosition, width: scrollView.bounds.size.width, height: view.viewheight)
                view.autoresizingMask = .flexibleWidth
            }
        }
    }
    fileprivate var isRefreshing = false
    init(view: RefreshView = RefreshDefaultView()) {
        self.view = view
        super.init()
    }
    
    // MARK: - KVO
    
    fileprivate var KVOContext = "RefreshKVOContext"
    func addScrollViewObserving() {
        if !hasAddObserver {
            scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .initial, context: &KVOContext)
            hasAddObserver = true
        }
        
    }
    
    func removeScrollViewObserving() {
        if hasAddObserver {
            scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: &KVOContext)
            hasAddObserver = false
        }
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == &KVOContext && keyPath == "contentOffset" && object as? UIScrollView == scrollView) {
            
            let offset = previousScrollViewOffset.y + scrollViewDefaultInsets.top
            let refreshViewHeight = view.frame.size.height
            switch offset {
            case 0 where (state != .loading): state = .initial
            case -refreshViewHeight...0 where (state != .loading && state != .finished && scrollView?.isDragging == true):
                state = .pulling(progress: -offset / refreshViewHeight)
            case -1000...(-refreshViewHeight):
                if state == .pulling(progress: 1) && scrollView?.isDragging == false {
                    state = .loading
                } else if state != .loading && state != .finished {
                    state = .pulling(progress: 1)
                }
            default: break
            }
            if state == .loading && scrollView?.isDragging == true {
                if offset < 0 {
                    scrollView!.contentInset.top = min(-offset, view.height + scrollViewDefaultInsets.top)
                } else {
                    scrollView!.contentInset.top = scrollViewDefaultInsets.top
                }
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        
        previousScrollViewOffset.y = scrollView!.contentOffset.y
    }
    
    // MARK: - State
    
    var state: RefresherState = .initial {
        didSet {
            view.animateState(state)
            switch state {
            case .loading:
                if let scrollView = scrollView, (oldValue != .loading) {
                    isRefreshing = true
                    scrollView.contentOffset = previousScrollViewOffset
                    scrollView.bounces = false
                    removeScrollViewObserving()
                    UIView.animate(withDuration: 0.3, animations: {
                        let insets = self.view.frame.height + self.scrollViewDefaultInsets.top
                        scrollView.contentInset.top = insets
                        scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -insets)
                        }, completion: { finished in
                            self.addScrollViewObserving()
                            scrollView.bounces = true
                    })
                    
                    action?()
                }
            case .finished:
                removeScrollViewObserving()
                if let finishedMessage = finishedMessage, let tipView = tipView {
                    isTipViewShowing = true
                    tipView.tipLabel.text = finishedMessage
                    tipView.sizeToFit()
                    tipView.layer.cornerRadius = tipView.viewHeight / 2
                    tipView.layer.shadowPath = UIBezierPath(roundedRect: tipView.bounds.insetBy(dx: 5, dy: 0), cornerRadius: tipView.layer.cornerRadius).cgPath
                    var tipViewFrame = tipView.frame
                    tipViewFrame.origin.y = -tipView.viewHeight
                    tipView.frame = tipViewFrame
                    tipView.alpha = 0
                    self.scrollView?.addSubview(tipView)
                    UIView.animate(withDuration: 0.2, animations: {
                        self.view.alpha = 0
                        tipView.alpha = 1
                        self.scrollView?.contentInset.top = tipView.contentInsetTopWhenShowing + self.scrollViewDefaultInsets.top
                        }, completion: { (_) in
                            UIView.animate(withDuration: 0.2, delay: 2, options: [.curveLinear, .beginFromCurrentState, .allowUserInteraction], animations: {
                                self.scrollView?.contentInset = self.scrollViewDefaultInsets
                                self.scrollView?.contentOffset.y = -self.scrollViewDefaultInsets.top
                                }, completion: { (_) in
                                    self.isTipViewShowing = false
                                    self.view.alpha = 1
                                    tipView.removeFromSuperview()
                                    self.addScrollViewObserving()
                                    self.state = .initial
                                    self.isRefreshing = false
                            })
                    })
                } else {
                    UIView.animate(withDuration: 0.3, delay: 0.0, options: [.curveLinear, .beginFromCurrentState, .allowUserInteraction], animations: { () -> Void in
                        self.scrollView?.contentInset = self.scrollViewDefaultInsets
                        self.scrollView?.contentOffset.y = -self.scrollViewDefaultInsets.top
                        }, completion: { (_) -> Void in
                            self.addScrollViewObserving()
                            self.state = .initial
                            self.isRefreshing = false
                    })
                }
            default: break
            }
        }
    }
    
    // MARK: - Start/End Refreshing
    
    func startRefreshing() {
        guard state == .initial else { return }
        guard isRefreshing == false else { return }
        if let scrollView = scrollView {
            isRefreshing = true
            scrollView.setContentOffset(CGPoint(x: 0, y: -view.frame.height - scrollViewDefaultInsets.top), animated: true)
            let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
            DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                self.state = .loading
            })
        }
        
    }
    
    func endRefreshing() {
        if state == .loading {
            state = .finished
        }
    }
    
}
