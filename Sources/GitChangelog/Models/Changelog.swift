import Foundation

public struct OldChangelog: Codable {
    public typealias Category = String
    public typealias Entry = String
    public typealias ReleaseID = String

    public struct Release: Codable {
        public let date: Date
        public let id: OldChangelog.ReleaseID
        public var categorizedEntries: [Category: [Entry]]
    }

    public var unreleased: Release = Release(date: Date(), id: "don't care", categorizedEntries: [:])
    public var releases: [ReleaseID: Release] = [:]
}

public class Changelog: Codable {
    public class Entry: Codable {
        var commitSha: String = ""
        var version: String = ""
        var date: Date = Date()
        var entries: [String: [String]] = [:]
        
        init(version: String) {
            self.version = version
        }
        
        init() {
            
        }
    }
    
    var unreleased: Entry = Entry(version: "Unreleased")
    var releases: [Entry] = []
}
