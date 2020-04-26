import Foundation

public struct Changelog {
    public typealias Category = String
    public typealias Entry = String
    public typealias ReleaseID = String

    public struct Release {
        public let date: Date
        public let id: Changelog.ReleaseID
        public var categorizedEntries: [Category: [Entry]]
    }

    public var unreleased: Release = Release(date: Date(), id: "don't care", categorizedEntries: [:])
    public var releases: [ReleaseID: Release] = [:]
}
