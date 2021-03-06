//
//  NetworkCacheEntity.swift
//  KitDemo
//
//  Created by 杨洋 on 2017/5/21.
//  Copyright © 2017年 com.36kr. All rights reserved.
//

import Foundation
import RealmSwift

class NetworkCacheEntity: Object {
    
    dynamic var cacheName: String?
    dynamic var cacheData: Data?
    
    override class func primaryKey() -> String? {
        return "cacheName"
    }
    
}
