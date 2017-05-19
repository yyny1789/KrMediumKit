import Foundation

public extension String {

    public var localized: String {
        return localizedString(self)
    }
    
    public var securedURLString: String {
        var set = CharacterSet()
        set.formUnion(.urlHostAllowed)
        set.formUnion(.urlPathAllowed)
        set.formUnion(.urlQueryAllowed)
        set.formUnion(.urlFragmentAllowed)
        var urlValue =  self.addingPercentEncoding(withAllowedCharacters: set).flatMap { URL(string: $0) }
        
        urlValue = URL(string: self)
        
        if let url = urlValue {
            //如果没有scheme，默认当http处理，譬如www.baidu.com
            if url.scheme == "" {
                return "https://" + self
            } else if url.scheme == "http" {
                return replace("http://", with: "https://")
            }
        }
        return self
    }
    
    //版本比较
    public func isOlderVersionThan(_ otherVersion: String) -> Bool {
        return self.compare(otherVersion, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedAscending
    }
    
    public func isNewerVersionThan(_ otherVersion: String) -> Bool {
        return self.compare(otherVersion, options: NSString.CompareOptions.numeric) == ComparisonResult.orderedDescending
    }
    
}
