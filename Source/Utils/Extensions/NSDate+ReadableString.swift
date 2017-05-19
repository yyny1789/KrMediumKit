//
//  NSDate+ReadableString.swift
//  Client
//
//  Created by paul on 16/8/15.
//  Copyright © 2016年 36Kr. All rights reserved.
//

import Foundation

public extension Date {
    
    public var readableString: String {
        return timeIntervalSince1970.dateStringRepresentation
    }
    
}

public extension Date {
    // 只关注多少天之前 无具体日期显示
    public var daysAgo: String {
        let calendar = Calendar.current
        let now = Date()
        let diff = now.timeIntervalSince1970 - timeIntervalSince1970
        if calendar.isDateInToday(self) {
            if diff < 60 {
                return "刚刚"
            } else if diff < 60 * 60 {
                return "\(Int(diff/60))分钟前"
            } else {
                return "\(Int(diff/3600))小时前"
            }
        } else if calendar.isDateInYesterday(self) {
            return "1天前"
        }
        let scondsOfDay: TimeInterval = 60 * 60 * 24
        return "\(Int(diff/scondsOfDay))天前"
    }
    
}
