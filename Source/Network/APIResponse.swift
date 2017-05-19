//
//  Response.swift
//
//  Created by aidenluo on 1/25/16
//  Copyright (c) . All rights reserved.
//

import Foundation
import ObjectMapper

struct APIResponse<Data: Mappable>: Mappable {

    var data: Data?
    var code: Int = -1
    var msg: String = ""

    init?(map: Map){

    }

    mutating func mapping(map: Map) {
		data <- map["data"]
		code <- map["code"]
		msg <- map["msg"]
    }

}

struct APIArrayResponse<Data: Mappable>: Mappable {
    
    var data: [Data]?
    var code: Int = -1
    var msg: String = ""
    
    init?(map: Map){
        
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
        code <- map["code"]
        msg <- map["msg"]
    }
    
}
