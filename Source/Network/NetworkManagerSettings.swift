//
//  NetworkManagerSettings.swift
//  KitDemo
//
//  Created by 杨洋 on 2017/5/19.
//  Copyright © 2017年 com.36kr. All rights reserved.
//

import Foundation

public protocol NetworkManagerSettingsProtocol: class {
    func loseLoginStatusHandle()
}

public struct NetworkManagerSettings {
    
    public static var settingsconfigure: NetworkManagerSettingsProtocol?
    
    /// 打印网络请求 log
    public static var consolelogEnable: Bool = true
    
    public static var userAgent: String?
    public static var customHTTPHeader: [String: String]?
    
    /// 丢失登录态 code
    public static var loseLoginStatusCode: Int?
    
    /// 丢失登录态回调
    static func loseLoginStatusHandle() {
        settingsconfigure?.loseLoginStatusHandle()
    }
    
}
