import Foundation
import ArgumentParser

class ChangelogAction {
    private let git: GitShell
    private let markdown: MarkdownAction
    private let regexPattern = #"(added|changed|deprecated|removed|fixed|security|release):\w?(.*)"#
    
    var releasedCommits: [Commit] = []
    var unreleasedCommits: [Commit] = []
    
    init() {
        self.git = try! GitShell(bash: Bash())
        self.markdown = MarkdownAction()
    }
    
    @discardableResult
    func parse() throws -> Changelog {
        var currentRelease: String?
        let changelog = Changelog()
        let commits = try ChangelogCommits(commits: self.git.commits())
        for commit in commits {
            for changelogEntry in commit.changelogEntries {
                switch changelogEntry {
                case .release(let release):
                    currentRelease = release
                    let entry = Changelog.Entry()
                    entry.commitSha = commit.commit.sha
                    entry.version = release
                    entry.date = commit.commit.date
                    changelog.releases.append(entry)
                    if !self.releasedCommits.contains(where: { $0.sha == commit.commit.sha }) {
                        self.releasedCommits.append(commit.commit)
                    }
                default:
                    if let releaseId = currentRelease, let release = changelog.releases.first(where: { $0.version == releaseId }) {
                        if var entries = release.entries[changelogEntry.typeString.capitalized] {
                            entries.append(changelogEntry.message)
                            release.entries[changelogEntry.typeString.capitalized] = entries
                        } else {
                            release.entries[changelogEntry.typeString.capitalized] = [changelogEntry.message]
                        }
                        if !self.releasedCommits.contains(where: { $0.sha == commit.commit.sha }) {
                            self.releasedCommits.append(commit.commit)
                        }
                    } else {
                        if !self.unreleasedCommits.contains(where: { $0.sha == commit.commit.sha }) {
                            self.unreleasedCommits.append(commit.commit)
                        }
                        if let _ = changelog.unreleased.entries[changelogEntry.typeString] {
                            changelog.unreleased.entries[changelogEntry.typeString]!.append(changelogEntry.message)
                        } else {
                            changelog.unreleased.entries[changelogEntry.typeString] = [changelogEntry.message]
                        }
                    }
                }
            }
        }
        return changelog
    }
         
    func repositoryURL() throws -> URL? {
        return try self.git.findRespoitoryOriginURL()
    }
}
