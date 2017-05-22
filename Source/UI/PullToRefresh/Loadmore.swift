//
//  Loadmore.swift
//  Client
//
//  Created by aidenluo on 12/5/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

import Foundation
import UIKit

// MARK: - State

enum LoadmoreState: Equatable {
    case initial
    case loading
    case finished(hasMore: Bool)
    case error
}

func ==(lhs: LoadmoreState, rhs: LoadmoreState) -> Bool {
    switch (lhs, rhs) {
    case (.initial, .initial): return true
    case (.loading, .loading): return true
    case (.finished, .finished): return true
    case (.error, .error): return true
    default: return false
    }
}


class LoadmoreView: UIView {
    
    var viewheight: CGFloat = 64.0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    func animateState(_ state: LoadmoreState) {
        
    }
}

public class Loadmore: NSObject {
    
    var view: LoadmoreView
    var action: VoidClosureType?
    var triggerPercent = 0.0
    var hasMore = true
    var scrollViewDefaultInsets = UIEdgeInsets.zero
    fileprivate var hasAddObserver = false
    weak var scrollView: UIScrollView? {
        didSet {
            if let scrollView = scrollView {
                scrollViewDefaultInsets = scrollView.contentInset
                scrollView.addSubview(view)
                view.frame = CGRect(x: 0, y: scrollView.contentSize.height, width: scrollView.bounds.size.width, height: view.viewheight)
                view.autoresizingMask = .flexibleWidth
                let insets = view.frame.height + scrollViewDefaultInsets.bottom
                scrollView.contentInset.bottom = insets
            }
        }
    }
    
    init(view: LoadmoreView = LoadmoreDefaultView()) {
        self.view = view
        super.init()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.retry))
        self.view.addGestureRecognizer(tap)
    }
    
    // MARK: - KVO
    
    fileprivate var KVOContext = "LoadmoreKVOContext"

    func addScrollViewObserving() {
        if !hasAddObserver {
            scrollView?.addObserver(self, forKeyPath: "contentOffset", options: .new, context: &KVOContext)
            scrollView?.addObserver(self, forKeyPath: "contentSize", options: .new, context: &KVOContext)
            hasAddObserver = true
        }
        
    }
    
    func removeScrollViewObserving() {
        if hasAddObserver {
            scrollView?.removeObserver(self, forKeyPath: "contentOffset", context: &KVOContext)
            scrollView?.removeObserver(self, forKeyPath: "contentSize", context: &KVOContext)
            hasAddObserver = false
        }
    }

    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (context == &KVOContext && keyPath == "contentOffset" && object as? UIScrollView == scrollView) {
            guard hasMore else  {
                return
            }
            let scrollViewContentHeight = scrollView!.contentSize.height
            let scrollViewOffsetThreshold = scrollViewContentHeight - scrollView!.bounds.size.height
            let scrollViewBottomOffset = scrollView!.contentOffset.y - scrollViewDefaultInsets.bottom
            let loadmoreViewHeight = view.frame.size.height
            let offset = scrollViewBottomOffset - scrollViewOffsetThreshold + loadmoreViewHeight
            switch offset {
            case 0...1000 where (state == .initial):
                let percent = Double(offset) / Double(loadmoreViewHeight)
                if percent >= triggerPercent {
                    state = .loading
                }
            default: break
            }
        } else if (context == &KVOContext && keyPath == "contentSize" && object as? UIScrollView == scrollView) {
            view.frame = CGRect(x: 0, y: scrollView!.contentSize.height, width: scrollView!.frame.size.width, height: view.frame.size.height)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - State
    
    var state: LoadmoreState = .initial {
        didSet {
            view.animateState(state)
            switch state {
            case .loading:
                if oldValue != .loading {
                    action?()
                }
            case .finished(let hasMore):
                if hasMore {
                    let delayTime = DispatchTime.now() + Double(Int64(0.5 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
                        self.state = .initial
                    })
                }
            default:
                break
            }
        }
    }
    
    // MARK: - Start/End Refreshing
    
    func endLoadingmore(_ hasMore: Bool) {
        self.hasMore = hasMore
        state = .finished(hasMore: hasMore)
    }
    
    func errorLoadingmore() {
        hasMore = true
        state = .error
    }
    
    func resetLoadmoreState() {
        hasMore = true
        state = .initial
    }
    
    func retry() {
        if state == .error {
            state = .loading
        }
    }
    
    func updateScrollViewContentInset() {
        let insets = view.frame.height + scrollViewDefaultInsets.bottom
        scrollView?.contentInset.bottom = insets
    }

}
