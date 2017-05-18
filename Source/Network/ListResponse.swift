//
//  ListResponse.swift
//  Client
//
//  Created by paul on 16/8/3.
//  Copyright © 2016年 36Kr. All rights reserved.
//

import UIKit
import ObjectMapper

open struct ListResponse<T: Mappable>: Mappable {
    
    open var code: Int = -1
    open var data: [T]?
    open var first: Int?
    open var before: Int?
    open var current: Int?
    open var last: Int?
    open var next: Int?
    open var totalPages: Int?
    open var totalItems: Int?
    open var limit: Int?
    open var totalItemsFromNodeServer: Int?
    open var page: Int?
    open var pageSize: Int?
    open var refreshText: String?
    
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

open struct PageResponse<T: Mappable>: Mappable {
    
    open var code: Int = -1
    open var page: Int?
    open var totalCount: Int?
    open var pageSize: Int?
    open var ts: Int?
    open var data: [T]?
    
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
