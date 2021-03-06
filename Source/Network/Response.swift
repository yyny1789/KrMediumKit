//
//  Response.swift
//  Client
//
//  Created by paul on 16/8/5.
//  Copyright © 2016年 36Kr. All rights reserved.
//

import UIKit
import ObjectMapper

struct Response<T: Mappable>: Mappable {
    
    var code: Int?
    var data: T?
    var message: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
        message <- map["msg"]
    }
    
}

struct EmptyEntity: Mappable {
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
    }
    
}
