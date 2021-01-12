import Foundation

public struct ReleaseDetails {
    let tag: Tag
    let startingSha1: String
    let endingSha1: String // excluded
    let date: Date
    let changelogCommits: [ChangelogCommit]
    let changelogEntries: [OldChangelog.Category: [OldChangelog.Entry]]

    public init?(for tag: Tag, using git: GitShell, startsOnRelease: Bool = true, includePreReleases: Bool) {
        var categorizedEntries: [OldChangelog.Category: [OldChangelog.Entry]] = [:]
        var changelogCommits: [ChangelogCommit] = []
        var startingSha1: String?
        var endingSha1: String?
        var lastSha1: String?
        var date: Date?

        let commits = try! git.commits(for: tag)
        for changelogCommit in ChangelogCommits(commits: commits) {
            lastSha1 = changelogCommit.commit.sha

            if let _ = startingSha1 {
                if let _ = changelogCommit.release(includePreReleases) {
                    endingSha1 = changelogCommit.commit.sha
                    break
                }

                changelogCommits.append(changelogCommit)
                for entry in changelogCommit.changelogEntries {
                    categorizedEntries.upsertAppend(value: entry.message, for: entry.typeString)
                }
            } else {
                if !startsOnRelease {
                    if let _ = changelogCommit.release(includePreReleases) {
                        return nil
                    }
                }

                startingSha1 = changelogCommit.commit.sha
                date = changelogCommit.commit.date
                changelogCommits.append(changelogCommit)
                for entry in changelogCommit.changelogEntries {
                    categorizedEntries.upsertAppend(value: entry.message, for: entry.typeString)
                }
            }
        }

        if endingSha1 == nil {
            endingSha1 = lastSha1!
        }

        self.tag = tag
        self.startingSha1 = startingSha1!
        self.endingSha1 = endingSha1!
        self.date = date!
        self.changelogEntries = categorizedEntries
        self.changelogCommits = changelogCommits
    }
}
