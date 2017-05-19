import Foundation

public extension String {

  var length: Int { return characters.count }
  var isPresent: Bool { return !isEmpty }

  public func replace(_ string: String, with withString: String) -> String {
    return replacingOccurrences(of: string, with: withString)
  }

  public func truncate(_ length: Int, suffix: String = "...") -> String {
    return self.length > length
      ? substring(to: characters.index(startIndex, offsetBy: length)) + suffix
      : self
  }

  public func split(_ delimiter: String) -> [String] {
    let components = self.components(separatedBy: delimiter)
    return components != [""] ? components : []
  }

  public func contains(_ find: String) -> Bool {
    return range(of: find) != nil
  }

  public func trim() -> String {
    return trimmingCharacters(in: CharacterSet.whitespaces)
  }

  public var uppercaseFirstLetter: String {
    guard isPresent else { return self }

    var string = self
    string.replaceSubrange(string.startIndex...string.startIndex,
                        with: String(string[string.startIndex]).capitalized)

    return string
  }
}
