import Foundation

struct Changelog {
    typealias Category = String
    typealias Entry = String
    typealias ReleaseID = String

    struct Release {
        let date: Date
        let id: Changelog.ReleaseID
        var categorizedEntries: [Category: [Entry]]
    }

    var unreleased: Release = Release(date: Date(), id: "", categorizedEntries: [:])
    var releases: [ReleaseID: Release] = [:]
}
