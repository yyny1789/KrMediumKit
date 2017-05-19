//
//  Int+Utils.swift
//  Client
//
//  Created by Shannon Wu on 12/8/15.
//  Copyright © 2015 36Kr. All rights reserved.
//

import Foundation

let doubleDateFormmater: DateFormatter =  {
    let formatter = DateFormatter()
    return formatter
}()

public extension Int {
    public var stringValue: String {
        return "\(self)"
    }
    
    public var readableString: String {
        if self < 0 {
            return ""
        }
        let base = 10000
        if self >= base {
            if self % base == 0 {
                return "\(self/base)万"
            }
            return String(format: "%.1f万", Double(self)/Double(base))
        }
        return "\(self)"
    }
    
}


public extension Double {
    // 截取到小数点后几位
    public func format(_ f: Int) -> String {
        return NSString(format: "%.\(f)f" as NSString, self) as String
    }
    
    public var dateStringRepresentationShortNews: String {
        let oldDate = Date(timeIntervalSince1970: self)
        doubleDateFormmater.dateFormat = "HH:mm"
        return doubleDateFormmater.string(from: oldDate)
    }
    
    public var dateStringRepresentation: String {
        let calender = Calendar.current
        let now = Date()
        let oldDate = Date(timeIntervalSince1970: self)
        if calender.isDateInToday(oldDate) {
            let timeInterval = now.timeIntervalSince1970 - self
            if timeInterval < 60 {
                return "刚刚"
            } else if timeInterval < 60 * 60 {
                return "\(Int(timeInterval/60))分钟前"
            } else {
                return "\(Int(timeInterval/3600))小时前"
            }
        } else if calender.isDateInYesterday(oldDate) {
            return "昨天"
        } else {
            doubleDateFormmater.dateFormat = "yyyy-MM-dd"
            return doubleDateFormmater.string(from: oldDate)
        }
    }
    
    public var normalTime:String{
        let oldDate = Date(timeIntervalSince1970: self)
        doubleDateFormmater.dateFormat = "yyyy-MM-dd"
        return doubleDateFormmater.string(from: oldDate)
    }
    
}
