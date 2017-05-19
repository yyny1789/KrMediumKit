import Foundation

public enum Regex: String {
    
    case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
    case Number = "^[0-9]*?$"
    
    var pattern: String {
        return rawValue
    }
}

public extension String {
    
    public func match(_ pattern: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, characters.count)) != nil
        } catch {
            return false
        }
    }
    
    public func getSpecificStr(_ regex: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: NSRegularExpression.Options.caseInsensitive)
            let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            
            if let match = matches.first {
                let range = match.rangeAt(1)
                if let swiftRange = rangeFromNSRange(range, forString: self) {
                    let result = self.substring(with: swiftRange)
                    return result
                }
            }
        } catch {
            // regex was bad!
        }
        return nil
    }
    
    
    
}
