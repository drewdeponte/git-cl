import Foundation
import ArgumentParser

struct LatestCommand: ParsableCommand {
    enum CodingKeys: String, CodingKey {
        case commits = "commits"
    }

    private let git: GitShell
    private let changelogCommits: ChangelogCommits

    static var configuration: CommandConfiguration {
        return .init(
            commandName: "latest",
            abstract: "Latest Release",
            discussion: "Returns the latest release portion of the changelog"
        )
    }

    @Flag(name: .shortAndLong, help: "Generate a list of commits from the latest release")
    var commits: Bool

    init() {
        self.git = try! GitShell(bash: Bash())
        self.changelogCommits = ChangelogCommits(commits: try! self.git.commits())
    }

    init(from decoder: Decoder) throws {
        self.git = try! GitShell(bash: Bash())
        self.changelogCommits = ChangelogCommits(commits: try! self.git.commits())

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commits = try container.decode(Bool.self, forKey: .commits)
    }

    func run() throws {
        var categorizedEntries: [OldChangelog.Category: [OldChangelog.Entry]] = [:]
        var releaseID: String?
        var releaseDate: Date?

        outerLoop: for changelogCommit: ChangelogCommit in self.changelogCommits {
            if !changelogCommit.changelogEntries.isEmpty {
                for entry in changelogCommit.changelogEntries {
                    switch entry {
                    case .release(let msg):
                        if releaseID != nil {
                            break outerLoop
                        } else {
                            releaseID = msg
                            releaseDate = changelogCommit.commit.date
                        }
                    default:
                        if releaseID != nil {
                            categorizedEntries.upsertAppend(value: entry.message, for: entry.typeString)
                        }
                    }
                }
            }

            // If we have gotten this far it isn't a release commit
            if releaseID != nil {
                if self.commits {
                    print(commitSummary(changelogCommit))
                }
            }
        }

        if !self.commits {
            print(markdownRelease(releaseID: releaseID!, date: releaseDate!, categorizedEntries: categorizedEntries))
        }
    }
}
