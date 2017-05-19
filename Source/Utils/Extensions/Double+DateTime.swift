import Foundation

public extension Double {

  public var second: TimeInterval {
    return self
  }

  public var minute: TimeInterval {
    return second * 60
  }

  public var hour: TimeInterval {
    return minute * 60
  }

  public var day: TimeInterval {
    return hour * 24
  }

  public var week: TimeInterval {
    return day * 7
  }

  public var month: TimeInterval {
    return day * 30
  }

  public var year: TimeInterval {
    return day * 365
  }

  public var ago: Date {
    return Date(timeIntervalSinceNow: -self)
  }

  public var future: Date {
    return Date(timeIntervalSinceNow: self)
  }
    
}
