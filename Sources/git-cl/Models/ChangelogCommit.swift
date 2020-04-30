import Foundation

public struct ChangelogCommit {
    private let releaseRegexPattern = #"^v?\d+\.\d+\.\d+$"#
    private let releaseOrPreReleaseRegexPattern = #"^v?\d+\.\d+\.\d+(-[0-9A-Za-z-\.]+)?$"#
    public let commit: Commit
    public let changelogEntries: [ChangelogEntry]

    public func release(_ includePreReleases: Bool = false) -> String? {
        for tag in self.commit.tags {
            if tag.matches(regexPattern(includePreReleases)) {
                return tag
            }
        }
        return nil
    }

    private func regexPattern(_ includePreReleases: Bool) -> String {
        if includePreReleases {
            return releaseOrPreReleaseRegexPattern
        } else {
            return releaseRegexPattern
        }
    }
}
