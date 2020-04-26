import Foundation

public struct Commit {
    public let sha: String
    public let date: Date
    public let summary: String
    public let body: String?
}


extension Commit: CustomStringConvertible {
    public var description: String {
        return "\(self.sha.prefix(6)) \(self.summary)"
    }
}

extension Array where Element == Commit {
    var description: String {
        return self.map(\.description).joined(separator: "\n")
    }
}
