//
//  BaseViewControllerSettings.swift
//  KitDemo
//
//  Created by 杨洋 on 2017/5/22.
//  Copyright © 2017年 com.36kr. All rights reserved.
//

import Foundation
import UIKit

public protocol KrBaseViewControllerSettingsProtocol: class {
    
    func baseViewControllerViewDidLoad(viewController: UIViewController)
    func baseViewControllerViewWillAppear(viewController: UIViewController)
    func baseViewControllerViewDidAppear(viewController: UIViewController)
    func baseViewControllerViewWillDisappear(viewController: UIViewController)
    func baseViewControllerViewDidDisappear(viewController: UIViewController)
    func baseViewControllerDeinit(viewController: UIViewController)
    
}

public struct KrBaseViewControllerSettings {
    
    public static var settingsconfigure: KrBaseViewControllerSettingsProtocol?
    
    static func baseViewControllerViewDidLoad(viewController: UIViewController) {
        settingsconfigure?.baseViewControllerViewDidLoad(viewController: viewController)
    }
    
    static func baseViewControllerViewWillAppear(viewController: UIViewController) {
        settingsconfigure?.baseViewControllerViewWillAppear(viewController: viewController)
    }
    
    static func baseViewControllerViewDidAppear(viewController: UIViewController) {
        settingsconfigure?.baseViewControllerViewDidAppear(viewController: viewController)
    }
    
    static func baseViewControllerViewWillDisappear(viewController: UIViewController) {
        settingsconfigure?.baseViewControllerViewWillDisappear(viewController: viewController)
    }
    
    static func baseViewControllerViewDidDisappear(viewController: UIViewController) {
        settingsconfigure?.baseViewControllerViewDidDisappear(viewController: viewController)
    }
    
    static func baseViewControllerDeinit(viewController: UIViewController) {
        settingsconfigure?.baseViewControllerDeinit(viewController: viewController)
    }
    
}
