import Foundation

public struct MarkdownGenerator {
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
    
    public func generate(_ type: ChangelogType, from changelog: Changelog, with url: URL?) -> String {
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
        
        if let url = url {
            result +=  self.generateVersionDiffs(from: changelog, with: url)
        }
        return result
    }
    
    public func generateUnreleased(from changelog: Changelog) -> String {
        var result = "\n\n## Unreleased - now\n"
        
        changelog.unreleased.categorizedEntries.forEach { category, entries in
            result += "\n### \(category.capitalized)\n"
            entries.forEach { result += "- \($0)\n" }
        }
        
        return result
    }
    
    public func generateReleased(from changelog: Changelog) -> String {
        var result = ""
        
        changelog.releases.sorted(by: { $0.key > $1.key }).forEach { releaseID, release in
            result += "\n\n## \(releaseID) - \(self.dateFormatter.string(from: release.date))\n"
            release.categorizedEntries.forEach { (category, entries) in
                result += "\n### \(category.capitalized)\n"
                entries.forEach { result += "- \($0)\n" }
            }
        }
        
        return result
    }
    
    func generateVersionDiffs(from changelog: Changelog, with url: URL) -> String {
        var result = "\n\n"
        let sortedReleases = changelog.releases.sorted(by: { $0.key > $1.key })
        for index in 0..<sortedReleases.count {
            // If it's the first index, we need to set it as un-released
            if index == 0 {
                let release = sortedReleases[index]
                let ref = url.absoluteString + "/compare/\(release.key)...HEAD"
                result += "[Unreleased]: \(ref)\n"
                continue
            }
            
            // If it's the last release, we need to set the tag
            if index == sortedReleases.count - 1 {
                let release = sortedReleases[index]
                let ref = url.absoluteString + "/releases/tag/\(release.key)"
                result += "[\(release.key)]: \(ref)\n"
                continue
            }
            
            // Check if our index is in range
            if index - 1 >= 0 {
                let release = sortedReleases[index]
                let previousRelease = sortedReleases[index - 1]
                let ref = url.absoluteString + "/compare/\(release.key)...\(previousRelease.key)"
                result += "[\(release.key)]: \(ref)\n"
            }
        }
        
        return result
    }
}

