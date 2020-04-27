import Foundation

public class MarkdownAction {
    public enum ChangelogType {
        case both
        case unreleased
        case released
    }
    
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()
    
    private let markdownChanglogBase = """
    # Changelog

    All notable changes to this project will be documented in this file.

    The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
    and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
    """
    
    init() { }
    
    public func generate(_ type: ChangelogType, from changelog: OldChangelog, with url: URL?) -> String {
        var result = self.markdownChanglogBase
        switch type {
        case .both:
            result += self.generateUnreleased(from: changelog)
            result += self.generateReleased(from: changelog)
            
        case .unreleased:
            result += self.generateUnreleased(from: changelog)
            
        case .released:
            result += self.generateReleased(from: changelog)
        }
        
        // Generate the diff links for both unreleased and released (full markdown file)
        if type == .both {
            if let url = url {
                result += self.generateVersionDiffs(from: changelog, with: url)
            }
        }
        return result
    }
    
    public func generateUnreleased(from changelog: OldChangelog) -> String {
        var result = "\n\n## [Unreleased] - now\n"
        
        changelog.unreleased.categorizedEntries.forEach { category, entries in
            result += "\n### \(category.capitalized)\n"
            entries.forEach { result += "- \($0)\n" }
        }
        
        return result
    }
    
    public func generateReleased(from changelog: OldChangelog) -> String {
        var result = ""
        
        changelog.releases.sorted(by: { $0.key > $1.key }).forEach { releaseID, release in
            result += "\n\n## [\(releaseID)] - \(self.dateFormatter.string(from: release.date))\n"
            release.categorizedEntries.forEach { (category, entries) in
                result += "\n### \(category.capitalized)\n"
                entries.forEach { result += "- \($0)\n" }
            }
        }
        
        return result
    }
    
    public func generateRelease(from changelog: OldChangelog, for release: String) -> String {
        guard let changelogRelease = changelog.releases[release] else {
            return "No changelog found"
        }
        
        var result = ""
        result += "\n\n## \(release) - \(self.dateFormatter.string(from: changelogRelease.date))\n"
        changelogRelease.categorizedEntries.forEach { (category, entries) in
            result += "\n### \(category.capitalized)\n"
            entries.forEach { result += "- \($0)\n" }
        }
        
        return result
    }
    
    func generateVersionDiffs(from changelog: OldChangelog, with url: URL) -> String {
        let result = "\n\n"
        
//        let sortedReleases = changelog.releases.sorted(by: { $0.key > $1.key })
//        var releases = sortedReleases.enumerated().map({ (key: "\($0.element.key)", index: $0.offset + 1) })
//        releases.insert((key: "Unreleased", index: 0), at: 0)
//        
//        for (key, index) in releases {
//            let previousIndex = index > 0 ? index - 1 : 0
//            // If the index is 0 and the releases contains only 1 release, we dont generate the diff links
//            if index == 0 && index == releases.count - 1 {
//                result = ""
//                continue
//            }
//            
//            // The first index will always be the unreleased section
//            if index == 0 {
//                result += "[\(key)]: \(url.absoluteString + "/compare/\(sortedReleases[previousIndex].key)...HEAD")\n"
//                continue
//            }
//            
//            if index == releases.count - 1 {
//                result += "[\(key)]: \(url.absoluteString + "/releases/tag/\(key)")\n"
//            } else {
//                result += "[\(key)]: \(url.absoluteString + "/compare/\(sortedReleases[index].key)...\(key)")\n"
//            }
//        }
        
        return result
    }
}

