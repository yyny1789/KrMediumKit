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

public final class NetworkManager {
    
    public class var manager: NetworkManager {
        
        struct SingletonWrapper {
            static let singleton = NetworkManager()
        }
        
        return SingletonWrapper.singleton
    }
    
    public let userAgent: String = NetworkManagerSettings.userAgent ?? "未设置 ua"
    
    fileprivate var customHTTPHeader: [String: String] {
        return NetworkManagerSettings.customHTTPHeader ?? ["User-Agent": userAgent]
    }
    
    public let reachability: Reachability? = {
        return Reachability()
    }()
    
    public func request<T: TargetType, O: Mappable>(_ target: T, stub: Bool = false, log: Bool = true, success: @escaping (_ result: O) -> Void, failure: @escaping (_ error: MoyaError) -> Void) -> Cancellable? {
        var provider: MoyaProvider<T>
        if NetworkManagerSettings.consolelogEnable && log {
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
                        if let code = JSON?["code"] as? Int, let loseCode = NetworkManagerSettings.loseLoginStatusCode, code == loseCode {
                            NetworkManagerSettings.loseLoginStatusHandle()
                            return
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
    
    public func request<T: TargetType>(_ target: T, stub: Bool = false, log: Bool = true, success: @escaping (_ result: Data) -> Void, failure: @escaping (_ error: MoyaError) -> Void) -> Cancellable? {
        var provider: MoyaProvider<T>
        if NetworkManagerSettings.consolelogEnable && log {
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
    
    public func generalRequest<T: TargetType>(_ target: T, completion: @escaping Completion) -> Cancellable? {
        let endpointClosure = { (target: T) -> Endpoint<T> in
            let URL = target.baseURL.appendingPathComponent(target.path).absoluteString
            let endpoint: Endpoint<T> = Endpoint<T>(url: URL, sampleResponseClosure: {.networkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
            return endpoint.adding(newHTTPHeaderFields: self.customHTTPHeader)
        }
        let provider = MoyaProvider<T>(endpointClosure: endpointClosure)
        return provider.request(target, completion: completion)
    }
    
}
