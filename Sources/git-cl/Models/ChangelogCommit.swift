import Foundation

public struct ChangelogCommit {
    private let releaseRegexPattern = #"^v?\d+\.\d+\.\d+$"#
    public let commit: Commit
    public let changelogEntries: [ChangelogEntry]

    var release: String? {
        for tag in self.commit.tags {
            if tag.matches(releaseRegexPattern) {
                return tag
            }
        }
        return nil
    }
}
