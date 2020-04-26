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
    
    public func generate(_ type: ChangelogType, from changelog: Changelog) -> String {
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
        
        changelog.releases.forEach { releaseID, release in
            result += "\n\n## \(releaseID) - \(self.dateFormatter.string(from: release.date))\n"
            release.categorizedEntries.forEach { (category, entries) in
                result += "\n### \(category.capitalized)\n"
                entries.forEach { result += "- \($0)\n" }
            }
        }
        
        return result
    }
}
