import Foundation

extension Dictionary where Key == OldChangelog.Category, Value == [OldChangelog.Entry] {
    public mutating func upsertAppend(value: OldChangelog.Entry, for key: OldChangelog.Category) {
        if let _ = self[key] {
            self[key]!.append(value)
        } else {
            self[key] = [value]
        }
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return (self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil)
    }
}

func markdown(_ categorizedEntries: [OldChangelog.Category: [OldChangelog.Entry]]) -> String {
    var result = ""
    categorizedEntries.sorted(by: { $0.0 < $1.0 }).forEach { category, entries in
        result += "\n### \(category.capitalized)\n"
        entries.forEach { result += "- \($0)\n" }
    }
    return result
}

func commitSummary(_ changelogCommit: ChangelogCommit) -> String {
    return "\(changelogCommit.commit.sha.prefix(6)) \(changelogCommit.commit.summary)"
}

func markdownUnreleased(_ categorizedEntries: [OldChangelog.Category: [OldChangelog.Entry]], withLinkRef: Bool = false) -> String {
    var result = withLinkRef ? "\n## [Unreleased] - now\n" : "\n## Unreleased - now\n"
    result += markdown(categorizedEntries)
    return result
}

func markdownRelease(releaseID: String, date: Date, categorizedEntries: [OldChangelog.Category: [OldChangelog.Entry]], withLinkRef: Bool = false) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = .current
    dateFormatter.dateFormat = "yyyy-MM-dd"

    var result = ""
    result += withLinkRef ? "\n## [\(releaseID)] - \(dateFormatter.string(from: date))\n" : "\n## \(releaseID) - \(dateFormatter.string(from: date))\n"
    result += markdown(categorizedEntries)
    return result
}
