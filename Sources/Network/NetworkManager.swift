//
//  NetworkManager.swift
//  Client
//
//  Created by aidenluo on 7/26/16.
//  Copyright © 2016 36Kr. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import ReachabilitySwift
import Device
import AdSupport

open class NetworkManager {
    
    open class var manager: NetworkManager {
        
        struct SingletonWrapper {
            static let singleton = NetworkManager()
        }
        
        return SingletonWrapper.singleton
    }
    
    open let userAgent: String = {
        var appVersion: String = AppVersion.marketingVersion.versionString
        if appVersion.isOlderVersionThan("5.0") {
            appVersion = "5.0"
        }
        let model = Device.version()
        let systemVersion = UIDevice.current.systemVersion
        let screenScale = UIScreen.main.scale
        
        if let build = VersionManager.manager.build {
            return "36kr-iOS/\(appVersion) (\(model)); Build \(build); iOS \(systemVersion); Scale/\(screenScale);"
        }
        return "36kr-iOS/\(appVersion) (\(model)); iOS \(systemVersion); Scale/\(screenScale);"
    }()
    
    fileprivate var customHTTPHeader: [String: String] {
        let deviceId = SecurityManager.manager.deviceUniqueId
        let ts = SecurityManager.manager.timestampAndSign
        let sign = ts.sign
        let timestamp = ts.timestamp
        let ua = self.userAgent

        return ["User-Agent": ua,
                "Accept" : "application/json",
                "device" : deviceId,
                "sign" : sign,
                "timestamp" : timestamp]
    }
    
    open let reachability: Reachability? = {
        return Reachability()
    }()
    
    open func request<T: TargetType, O: Mappable>(_ target: T, stub: Bool = false, log: Bool = true, success: @escaping (_ result: O) -> Void, failure: @escaping (_ error: MoyaError) -> Void) -> Cancellable? {
        var provider: MoyaProvider<T>
        if log {
            provider = MoyaProvider<T>(endpointClosure: endpointGenerator(), stubClosure: stubGenerator(stub), plugins: [NetworkLoggerPlugin(verbose: true)])
        } else {
            provider = MoyaProvider<T>(endpointClosure: endpointGenerator(), stubClosure: stubGenerator(stub))
        }
        return provider.request(target, completion: { (result) in
            switch result {
            case .success(let response):
                do {
                    if response.statusCode == 200 {
                        let JSON = try response.mapJSON() as? NSDictionary
                        if let code = JSON?["code"] as? Int {
                            if code == 401 && LoginManager.manager.isLogin() {
                                LoginManager.manager.logout()
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LoginManager.Notification.LoginStateIsExpired), object: nil)
                                alert("登录身份已过期，请重新登录", actions: [AlertAction(title: "知道了", style: .confirm)], didDismiss: nil)
                                failure(MoyaError.jsonMapping(response))
                                return
                            }
                        }
                        let mapper = Mapper<O>()
                        if let object = mapper.map(JSONObject: JSON) {
                            success(object)
                        } else {
                            failure(MoyaError.jsonMapping(response))
                        }
                    } else {
                        failure(MoyaError.statusCode(response))
                    }
                }  catch {
                    failure(MoyaError.jsonMapping(response))
                }
            case .failure(let error):
                failure(error)
            }
        })
    }
    
    open func request<T: TargetType>(_ target: T, stub: Bool = false, log: Bool = true, success: @escaping (_ result: Data) -> Void, failure: @escaping (_ error: MoyaError) -> Void) -> Cancellable? {
        var provider: MoyaProvider<T>
        if log {
            provider = MoyaProvider<T>(endpointClosure: endpointGenerator(), stubClosure: stubGenerator(stub), plugins: [NetworkLoggerPlugin(verbose: true)])
        } else {
            provider = MoyaProvider<T>(endpointClosure: endpointGenerator(), stubClosure: stubGenerator(stub))
        }
        return provider.request(target, completion: { (result) in
            switch result {
            case .success(let response):
                if response.statusCode == 200 {
                    success(response.data)
                } else {
                    failure(MoyaError.statusCode(response))
                }
            case .failure(let error):
                failure(error)
            }
        })
    }
    
    fileprivate func endpointGenerator<T: TargetType>() -> (_ target: T) -> Endpoint<T> {
        let generator = { (target: T) -> Endpoint<T> in
            let URL = target.baseURL.appendingPathComponent(target.path).absoluteString
            let endpoint: Endpoint<T> = Endpoint<T>(url: URL, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
            return endpoint.adding(newHTTPHeaderFields: self.customHTTPHeader)
        }
        return generator
    }
    
    fileprivate func stubGenerator<T>(_ stub: Bool) -> (_ target: T) -> StubBehavior {
        let stubClosure = { (target: T) -> StubBehavior in
            if stub {
                return .immediate
            } else {
                return .never
            }
        }
        return stubClosure
    }
    
    open func generalRequest<T: TargetType>(_ target: T, completion: @escaping Completion) -> Cancellable? {
        let endpointClosure = { (target: T) -> Endpoint<T> in
            let URL = target.baseURL.appendingPathComponent(target.path).absoluteString
            let endpoint: Endpoint<T> = Endpoint<T>(url: URL, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
            return endpoint.adding(newHTTPHeaderFields: self.customHTTPHeader)
        }
        let provider = MoyaProvider<T>(endpointClosure: endpointClosure)
        return provider.request(target, completion: completion)
    }
    
}
