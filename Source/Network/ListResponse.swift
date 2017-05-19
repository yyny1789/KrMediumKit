//
//  ListResponse.swift
//  Client
//
//  Created by paul on 16/8/3.
//  Copyright © 2016年 36Kr. All rights reserved.
//

import UIKit
import ObjectMapper

struct ListResponse<T: Mappable>: Mappable {
    
    var code: Int = -1
    var data: [T]?
    var first: Int?
    var before: Int?
    var current: Int?
    var last: Int?
    var next: Int?
    var totalPages: Int?
    var totalItems: Int?
    var limit: Int?
    var totalItemsFromNodeServer: Int?
    var page: Int?
    var pageSize: Int?
    var refreshText: String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        data <- map["data.items"]
        first <- map["data.first"]
        before <- map["data.before"]
        current <- map["data.current"]
        last <- map["data.last"]
        next <- map["data.next"]
        totalPages <- map["data.total_pages"]
        totalItems <- map["data.total_items"]
        limit <- map["data.limit"]
        totalItemsFromNodeServer <- map["data.total_items_ptime"]
        page <- map["data.page"]
        pageSize <- map["data.page_size"]
        refreshText <- map["data.refresh_text"]
    }

}

struct PageResponse<T: Mappable>: Mappable {
    
    var code: Int = -1
    var page: Int?
    var totalCount: Int?
    var pageSize: Int?
    var ts: Int?
    var data: [T]?
    
    init?(map: Map){
        
    }
    
    mutating func mapping(map: Map) {
        code <- map["code"]
        data <- map["data.data"]
        if data == nil {
            data <- map["data.items"]
        }
        totalCount <- map["data.total_count"]
        page <- map["data.page"]
        pageSize <- map["data.page_size"]
        ts <- map["data.ts"]
    }
    
}
