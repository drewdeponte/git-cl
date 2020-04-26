import Foundation
import ArgumentParser

class ChangelogAction {
    private let git: GitShell
    private let markdown: MarkdownAction
    private var changelog: Changelog = Changelog()
    private var currentReleaseID: Changelog.ReleaseID?
    private let regexPattern = #"(added|changed|deprecated|removed|fixed|security|release):\w?(.*)"#
    
    var releasedCommits: [Commit] = []
    var unreleasedCommits: [Commit] = []
    
    init() {
        self.git = try! GitShell(bash: Bash())
        self.markdown = MarkdownAction()
    }
    
    @discardableResult
    func parse() throws -> Changelog {
        for commit in try self.git.commits() {
            guard let body = commit.body else { continue }
            
            let changelogBody = body
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: "[changelog]")
                .dropFirst()
                .joined(separator: "\n")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            let regex = try NSRegularExpression(pattern: self.regexPattern, options: [])
            
            let nsrange = NSRange(changelogBody.startIndex..<changelogBody.endIndex, in: changelogBody)
            regex.enumerateMatches(in: changelogBody, options: [], range: nsrange) { match, _, stop in
                guard let match = match else { return }
                
                if match.numberOfRanges == 3 {
                    guard let firstCaptureRange = Range(match.range(at: 1), in: changelogBody),
                        let secondCaptureRange = Range(match.range(at: 2), in: changelogBody) else { return }
                    
                    let category = changelogBody[firstCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)
                    let message = changelogBody[secondCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    switch category {
                    case "release":
                        self.currentReleaseID = message
                        self.changelog.releases[self.currentReleaseID!] = Changelog.Release(date: commit.date, id: currentReleaseID!, categorizedEntries: [:])
                        if !self.releasedCommits.contains(where: { $0.sha == commit.sha }) {
                            self.releasedCommits.append(commit)
                        }
                    default:
                        if let releaseID = currentReleaseID {
                            if let _ = self.changelog.releases[releaseID]!.categorizedEntries[category] {
                                self.changelog.releases[releaseID]!.categorizedEntries[category]!.append(message)
                            } else {
                                self.changelog.releases[releaseID]!.categorizedEntries[category] = [message]
                            }
                            if !self.releasedCommits.contains(where: { $0.sha == commit.sha }) {
                                self.releasedCommits.append(commit)
                            }
                        } else {
                            if !self.unreleasedCommits.contains(where: { $0.sha == commit.sha }) {
                                self.unreleasedCommits.append(commit)
                            }
                            if let _ = self.changelog.unreleased.categorizedEntries[category] {
                                self.changelog.unreleased.categorizedEntries[category]!.append(message)
                            } else {
                                self.changelog.unreleased.categorizedEntries[category] = [message]
                            }
                        }
                    }
                }
            }
        }
        return self.changelog
    }
    
    func repositoryURL() throws -> URL? {
        return try self.git.findRespoitoryOriginURL()
    }
}
