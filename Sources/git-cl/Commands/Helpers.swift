import Foundation

extension Dictionary where Key == Changelog.Category, Value == [Changelog.Entry] {
    public mutating func upsertAppend(value: Changelog.Entry, for key: Changelog.Category) {
        if let _ = self[key] {
            self[key]!.append(value)
        } else {
            self[key] = [value]
        }
    }
}

func markdown(_ categorizedEntries: [Changelog.Category: [Changelog.Entry]]) -> String {
    var result = ""
    categorizedEntries.forEach { category, entries in
        result += "\n### \(category.capitalized)\n"
        entries.forEach { result += "- \($0)\n" }
    }
    return result
}

func commitSummary(_ changelogCommit: ChangelogCommit) -> String {
    return "\(changelogCommit.commit.sha.prefix(6)) \(changelogCommit.commit.summary)"
}
