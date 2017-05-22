//
//  UIScrollView+Refresher.swift
//  Client
//
//  Created by aidenluo on 12/5/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

import Foundation
import UIKit

private var RefresherAssociatedObjectKey: UInt8 = 0
private var LoadmoreAssociatedObjectKey: UInt8 = 0
public extension UIScrollView {
    
    public var refresher: Refresher? {
        get {
            return objc_getAssociatedObject(self, &RefresherAssociatedObjectKey) as? Refresher
        }
        set {
            objc_setAssociatedObject(self, &RefresherAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var loadmore: Loadmore? {
        get {
            return objc_getAssociatedObject(self, &LoadmoreAssociatedObjectKey) as? Loadmore
        }
        set {
            objc_setAssociatedObject(self, &LoadmoreAssociatedObjectKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public func setupPullToRefresh(_ refresh: Refresher = Refresher(), action: VoidClosureType?) {
        self.refresher = refresh
        self.refresher?.scrollView = self
        self.refresher?.action = action
        self.refresher?.addScrollViewObserving()
        updateScrollViewConentInset()
    }
    
    public func removePullToRefresh() {
        self.refresher?.removeScrollViewObserving()
        self.refresher = nil
    }
    
    public func beiginRefresh() {
        self.refresher?.startRefreshing()
    }
    
    public func endRefresh() {
        self.refresher?.endRefreshing()
    }
    /**
     添加Loadmore最好是拉取到数据后，判断是否有后续数据再决定是否添加，而不是初始化
     */
    public func setupLoadmore(_ loadmore: Loadmore = Loadmore(), action: VoidClosureType?) {
        self.loadmore = loadmore
        self.loadmore?.scrollView = self
        self.loadmore?.action = action
        self.loadmore?.addScrollViewObserving()
        updateScrollViewConentInset()
    }
    
    public func removeLoadmore() {
        self.loadmore?.removeScrollViewObserving()
        self.loadmore = nil
    }
    
    public func endLoadmore(hasMore more: Bool = true) {
        self.loadmore?.endLoadingmore(more)
    }
    
    public func errorLoadingmore() {
        self.loadmore?.errorLoadingmore()
    }
    
    public func resetNoMoreData() {
        self.loadmore?.view.isHidden = false
        self.loadmore?.resetLoadmoreState()
    }
    
    public func hideLoadmore() {
        self.loadmore?.view.isHidden = true
    }
    
    fileprivate func updateScrollViewConentInset() {
        if self.refresher?.state == .initial {
            self.refresher?.scrollViewDefaultInsets = contentInset
        }
        if self.loadmore?.state == .initial {
            self.loadmore?.scrollViewDefaultInsets = contentInset
        }
    }
    
}
