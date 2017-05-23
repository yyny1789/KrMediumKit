//
//  BaseViewController.swift
//  Client
//
//  Created by aidenluo on 7/28/16.
//  Copyright © 2016 36Kr. All rights reserved.
//

import UIKit
import Moya
import ObjectMapper

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

open class KrBaseViewController: UIViewController {
    
    //子类重写提供空页面图片
    open var emptyImage: UIImage? {
        return UIImage(named: "ic_common_placeholder_nodata")
    }
    
    open var failImage: UIImage? {
        return UIImage(named: "ic_common_placeholder_pagemissing")
    }
    
    open var emptyImageEnable: Bool {
        return true
    }
    
    open var emptyNeedClickReload: Bool {
        return false
    }
    
    //子类重写提供空页面提示文字
    open var emptyTip: String {
        return "暂无数据"
    }
    
    open var loadingViewBelowView: UIView? {
        return nil
    }
    
    open var loadingState: LoadingState = .initial {
        didSet {
            loadingView.loadingState = loadingState
            loadingStateDidChange(loadingState)
            switch loadingState {
            case .loading:
                view.bringSubview(toFront: loadingView)
                if let coverView = loadingViewBelowView {
                    view.insertSubview(loadingView, belowSubview: coverView)
                }
                loadingView.isHidden = false
            case .success:
                view.sendSubview(toBack: loadingView)
                loadingView.isHidden = true
            case .fail:
                view.bringSubview(toFront: loadingView)
                if let coverView = loadingViewBelowView {
                    view.insertSubview(loadingView, belowSubview: coverView)
                }
                loadingView.isHidden = false
                loadingView.imageView.image = emptyImageEnable ? failImage : nil
                loadingView.label.text = NSLocalizedString("点击屏幕，重新加载", comment: "")
                loadingView.label.sizeToFit()
            case .empty:
                view.bringSubview(toFront: loadingView)
                if let coverView = loadingViewBelowView {
                    view.insertSubview(loadingView, belowSubview: coverView)
                }
                loadingView.isHidden = false
                loadingView.imageView.image = emptyImageEnable ? emptyImage : nil
                loadingView.label.text = emptyTip
                loadingView.label.sizeToFit()
            default:
                view.sendSubview(toBack: loadingView)
                loadingView.isHidden = true
            }
        }
    }
    
    public var loadingView: LoadingView!
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        //rt_disableInteractivePop = false
        view.backgroundColor = UIColor.white
        loadingView = LoadingView(frame: view.bounds)
        loadingView.imageView.image = emptyImage
        loadingView.label.text = emptyTip
        loadingView.frame = view.bounds
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.loadingViewTap))
        loadingView.addGestureRecognizer(tap)
        view.addSubview(loadingView)
        loadingState = .success
        
        KrBaseViewControllerSettings.baseViewControllerViewDidLoad(viewController: self)
    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        trackViewDidAppear()
        setNeedsStatusBarAppearanceUpdate()
        
        KrBaseViewControllerSettings.baseViewControllerViewDidAppear(viewController: self)
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KrBaseViewControllerSettings.baseViewControllerViewWillAppear(viewController: self)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KrBaseViewControllerSettings.baseViewControllerViewWillDisappear(viewController: self)
    }
    
    override open func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        KrBaseViewControllerSettings.baseViewControllerViewDidDisappear(viewController: self)
    }
    
    deinit {
        KrBaseViewControllerSettings.baseViewControllerDeinit(viewController: self)
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingView.frame = view.bounds
    }
    
    open func loadingStateDidChange(_ state: LoadingState) {
        
    }
    
    open func loadingViewTap() {
        if loadingState == .fail || (loadingState == .empty && emptyNeedClickReload) {
            loadingState = .loading
            loadingData()
        }
    }
    
    open func loadingData() {
        
    }
    
    override open var hidesBottomBarWhenPushed: Bool {
        get {
            return navigationController?.childViewControllers.count > 1
        }
        set {
            super.hidesBottomBarWhenPushed = true
        }
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override open var prefersStatusBarHidden : Bool {
        return false
    }
    
    override open var preferredStatusBarUpdateAnimation : UIStatusBarAnimation {
        return .fade
    }
        
    open func trackViewDidAppear() {
        
    }
    
}

extension KrBaseViewController {
    
    public func requestArray<T: TargetType, O: Mappable>(_ target: T, stub: Bool = false, log: Bool = false, success: @escaping (_ result: ArrayResponse<O>) -> Void, failure: @escaping (_ error: MoyaError) -> Void) {
        
        _ = NetworkManager.manager.request(target, stub: stub, log: log, success: { (aResult: ArrayResponse<O>) in
            success(aResult)
            
            if aResult.data?.count == 0 {
                self.loadingState = .empty
            } else {
                self.loadingState = .success
            }
        }) { (error) in
            failure(error)
            self.loadingState = .fail
        }
    }
    
}
