import Foundation

// MARK: - Components

public extension Date {
  
  public func components(_ unit: NSCalendar.Unit, retrieval: (DateComponents) -> Int) -> Int {
    let calendar = Calendar.current
    let components = (calendar as NSCalendar).components(unit, from: self)
    return retrieval(components)
  }
  
  public var second: Int {
    return components(.second) {
      return $0.second!
    }
  }
  
  public var minute: Int {
    return components(.minute) {
      return $0.minute!
    }
  }
  
  public var hour: Int {
    return components(.hour) {
      return $0.hour!
    }
  }
  
  public var day: Int {
    return components(.day) {
      return $0.day!
    }
  }
  
  public var month: Int {
    return components(.month) {
      return $0.month!
    }
  }
  
  public var year: Int {
    return components(.year) {
      return $0.year!
    }
  }
  
  public var weekday: Int {
    return components(.weekday) {
      return $0.weekday!
    }
  }
}

public extension Date {
    
    public func chineseDateStringWithDate() -> String? {
        let chineseYears = ["甲子", "乙丑", "丙寅", "丁卯", "戊辰", "己巳", "庚午", "辛未", "壬申", "癸酉",
                            "甲戌", "乙亥", "丙子", "丁丑", "戊寅", "己卯", "庚辰", "辛己", "壬午", "癸未",
                            "甲申", "乙酉", "丙戌", "丁亥", "戊子", "己丑", "庚寅", "辛卯", "壬辰", "癸巳",
                            "甲午", "乙未", "丙申", "丁酉", "戊戌", "己亥", "庚子", "辛丑", "壬寅", "癸丑",
                            "甲辰", "乙巳", "丙午", "丁未", "戊申", "己酉", "庚戌", "辛亥", "壬子", "癸丑",
                            "甲寅", "乙卯", "丙辰", "丁巳", "戊午", "己未", "庚申", "辛酉", "壬戌", "癸亥"]
        let chineseMonths = ["正月", "二月", "三月", "四月", "五月", "六月",
                             "七月", "八月", "九月", "十月", "冬月", "腊月"]
        let chineseDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十",
                           "十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十",
                           "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        
        let calendar = Calendar(identifier: Calendar.Identifier.chinese)
        let components = (calendar as NSCalendar).components([NSCalendar.Unit.year, .month, .day], from: self)
        let yearIndex = components.year! - 1
        let monthIndex = components.month! - 1
        let dayIndex = components.day! - 1
        
        guard yearIndex < chineseYears.count &&
            yearIndex >= 0 &&
            monthIndex < chineseMonths.count &&
            monthIndex >= 0 &&
            dayIndex < chineseDays.count &&
            dayIndex >= 0 else {
                return nil
        }
        let yearString = chineseYears[yearIndex]
        let monthString = chineseMonths[monthIndex]
        let dayString = chineseDays[dayIndex]
        return yearString + " " + monthString + dayString
    }
    
    public func weekStringInChinese() -> String {
        let weeks = ["星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六"]
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([.weekday], from: self)
        return weeks[components.weekday! - 1]
    }
    
    // 把日期数字拆开返回，23 -> [2, 3]
    public func numbersForDay() -> [Int] {
        let calendar = Calendar.autoupdatingCurrent
        let components = (calendar as NSCalendar).components([NSCalendar.Unit.day], from: self)
        let day = Double(components.day!)
        let base: Double = 10
        
        if day < base {
            return [0, Int(day)]
        }
        let unit = day.truncatingRemainder(dividingBy: base)
        let tens = floor(day / 10.0)

        return [Int(tens), Int(unit)]
    }
    
    public func isInSameDay(_ date: Date?) -> Bool {
        guard let date = date else {
            return false
        }
        let calendar = Calendar.autoupdatingCurrent
        let components1 = (calendar as NSCalendar).components([NSCalendar.Unit.year, .weekday, .day], from: self)
        let components2 = (calendar as NSCalendar).components([NSCalendar.Unit.year, .weekday, .day], from: date)
        return components1.year == components2.year && components1.weekday == components2.weekday && components1.day == components2.day
    }
    
    public static func moreThanOneDay(_ date: Date?) -> Bool {
        guard let date = date else {
            return false
        }
        
        let timeInterval = date.timeIntervalSince(Date())
        return abs(timeInterval) > 24 * 60 * 60
    }

}
