//
//  ArrayResponse.swift
//  Client
//
//  Created by paul on 16/8/5.
//  Copyright © 2016年 36Kr. All rights reserved.
//

import UIKit
import ObjectMapper

struct ArrayResponse<T: Mappable>: Mappable {

    var code: Int?
    var data: [T]?
    var message: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
        if data == nil {
            data <- map["data.items"]
        }
        message <- map["msg"]
    }
    
}
