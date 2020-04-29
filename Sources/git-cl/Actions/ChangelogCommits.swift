import Foundation

public struct ChangelogCommits: Sequence {
    let commits: Commits

    public func makeIterator() -> ChangelogCommitsIterator {
        return ChangelogCommitsIterator(self)
    }
}

public struct ChangelogCommitsIterator: IteratorProtocol {
    private let changelogCommits: ChangelogCommits
    private var commitsIterator: CommitsIterator
    private let regexPattern = #"(added|changed|deprecated|removed|fixed|security):\w?(.*)"#

    init(_ changelogCommits: ChangelogCommits) {
        self.changelogCommits = changelogCommits
        self.commitsIterator = changelogCommits.commits.makeIterator()
    }

    public mutating func next() -> ChangelogCommit? {
        if let commit = self.commitsIterator.next() {
            guard let body = commit.body else {
                return ChangelogCommit(commit: commit, changelogEntries: [])
            }

            let changelogBody = body
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: "[changelog]")
                .dropFirst()
                .joined(separator: "\n")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let regex = try! NSRegularExpression(pattern: self.regexPattern, options: [])

            var changelogEntries: [ChangelogEntry] = []

            let nsrange = NSRange(changelogBody.startIndex..<changelogBody.endIndex, in: changelogBody)
            regex.enumerateMatches(in: changelogBody, options: [], range: nsrange) { match, _, stop in
                guard let match = match else { return }

                if match.numberOfRanges == 3 {
                    guard let firstCaptureRange = Range(match.range(at: 1), in: changelogBody),
                        let secondCaptureRange = Range(match.range(at: 2), in: changelogBody) else { return }

                    let category = changelogBody[firstCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)
                    let message = changelogBody[secondCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)

                    switch category {
                    case "added":
                        changelogEntries.append(ChangelogEntry.added(message))
                    case "changed":
                        changelogEntries.append(ChangelogEntry.changed(message))
                    case "deprecated":
                        changelogEntries.append(ChangelogEntry.deprecated(message))
                    case "removed":
                        changelogEntries.append(ChangelogEntry.removed(message))
                    case "fixed":
                        changelogEntries.append(ChangelogEntry.fixed(message))
                    case "security":
                        changelogEntries.append(ChangelogEntry.security(message))
                    default:
                        return
                    }
                }
            }
            return ChangelogCommit(commit: commit, changelogEntries:changelogEntries)
        } else {
            return nil
        }
    }
}
