import Foundation

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
