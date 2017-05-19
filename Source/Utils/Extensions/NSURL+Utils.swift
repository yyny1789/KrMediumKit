//
//  NSURL+Utils.swift
//  Client
//
//  Created by paul on 17/2/5.
//  Copyright © 2017年 36Kr. All rights reserved.
//

import Foundation

public extension URL {
    
    public var securedURL: URL? {
        //如果没有scheme，默认当http处理，譬如www.baidu.com
        var validURL: URL?
        if scheme == "" {
            validURL = URL(string: "https://\(absoluteString)")
        } else if scheme == "http" {
            validURL = URL(string: absoluteString.replace("http://", with: "https://"))
        }
        return validURL ?? self
    }
    
}
