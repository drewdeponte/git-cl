import Foundation
import ArgumentParser

struct FullCommand: ParsableCommand {
    private let git: GitShell
    private let changelogCommits: ChangelogCommits

    static var configuration: CommandConfiguration {
        return .init(
            commandName: "full",
            abstract: "All Unreleased and Released Changes",
            discussion: "Returns all of the unreleased and released in changelog"
        )
    }
        
    let changelogAction = ChangelogAction()
    let markdownAction = MarkdownAction()
    
    init() {
        self.git = try! GitShell(bash: Bash())
        self.changelogCommits = try! ChangelogCommits(commits: self.git.commits())
    }
    
    init(from decoder: Decoder) throws {
        self.git = try! GitShell(bash: Bash())
        self.changelogCommits = try! ChangelogCommits(commits: self.git.commits())
    }
    
    func run() throws {
        var categorizedEntries: [OldChangelog.Category: [OldChangelog.Entry]] = [:]
        var versionShas: [(String, String, String)] = []
        var releaseID: String?
        var releaseDate: Date?
        var releaseSha: String?
        var lastSha: String?

        print("""
        # Changelog

        All notable changes to this project will be documented in this file.

        The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
        and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

        """)

        for changelogCommit: ChangelogCommit in self.changelogCommits {
            if !changelogCommit.changelogEntries.isEmpty {
                for entry in changelogCommit.changelogEntries {
                    switch entry {
                    case .release(let msg):
                        // track release shas for generating link references at the end
                        if let releaseID = releaseID, let _ = releaseDate, let releaseSha = releaseSha {
                            versionShas.append((releaseID, releaseSha, changelogCommit.commit.sha))
                        } else { // handle Unreleased
                            versionShas.append(("Unreleased", "HEAD", changelogCommit.commit.sha))
                        }

                        // print the previous release or unreleased
                        if let releaseID = releaseID, let releaseDate = releaseDate, let _ = releaseSha {
                            print(markdownRelease(releaseID: releaseID, date: releaseDate, categorizedEntries: categorizedEntries, withLinkRef: true))
                        } else {
                            print(markdownUnreleased(categorizedEntries, withLinkRef: true))
                        }

                        // reset the categorizedEntries and associated tracking state
                        releaseID = msg
                        releaseDate = changelogCommit.commit.date
                        releaseSha = changelogCommit.commit.sha
                        categorizedEntries = [:]
                    default:
                        categorizedEntries.upsertAppend(value: entry.message, for: entry.typeString)
                    }
                }
            }
            lastSha = changelogCommit.commit.sha
        }

        // track release shas for generating link references at the end
        if let releaseID = releaseID, let _ = releaseDate, let releaseSha = releaseSha {
            versionShas.append((releaseID, releaseSha, lastSha!))
        } else { // handle Unreleased
            versionShas.append(("Unreleased", "HEAD", lastSha!))
        }

        // print the previous release or unreleased
        if let releaseID = releaseID, let releaseDate = releaseDate {
            print(markdownRelease(releaseID: releaseID, date: releaseDate, categorizedEntries: categorizedEntries, withLinkRef: true))
        } else {
            print(markdownUnreleased(categorizedEntries, withLinkRef: true))
        }

        // print the link references
        let compareBaseURL = self.repositoryURL()!
        versionShas.forEach { versionShaInfo in
            print("[\(versionShaInfo.0)]: \(compareBaseURL.absoluteString)/compare/\(versionShaInfo.2.prefix(7))...\(versionShaInfo.1.prefix(7))")
        }
    }

    private func repositoryURL() -> URL? {
        let urlString = try! self.git.findRespoitoryOriginURL()!.absoluteString
        return URL(string: urlString.replacingOccurrences(of: ":", with: "/").replacingOccurrences(of: "git@", with: "https://"))
    }
}
