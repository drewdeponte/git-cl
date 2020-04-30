import Foundation
import ArgumentParser

struct ReleasedCommand: ParsableCommand {
    enum CodingKeys: String, CodingKey {
        case commits = "commits"
        case release = "release"
    }

    private let git: GitShell
    private let changelogCommits: ChangelogCommits
    
    static var configuration: CommandConfiguration {
        return .init(
            commandName: "released",
            abstract: "All Released Changes",
            discussion: "Returns all of the release in changelog"
        )
    }
    
    @Flag(name: .shortAndLong, help: "Generate a list of released commits")
    var commits: Bool

    @Argument(help: "The release id")
    var release: String

    init() {
        self.git = try! GitShell(bash: Bash())
        self.changelogCommits = ChangelogCommits(commits: try! self.git.commits())
    }
    
    init(from decoder: Decoder) throws {
        self.git = try! GitShell(bash: Bash())
        self.changelogCommits = ChangelogCommits(commits: try! self.git.commits())
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commits = try container.decode(Bool.self, forKey: .commits)
        self.release = try container.decode(String.self, forKey: .release)
    }
    
    func run() throws {
        var releaseCommits: [ChangelogCommit] = []
        var categorizedEntries: [OldChangelog.Category: [OldChangelog.Entry]] = [:]

        var releaseID: String?
        var releaseDate: Date?
        var matchedRelease: Bool = false

        outerLoop: for changelogCommit: ChangelogCommit in self.changelogCommits {
            if let commitRelease = changelogCommit.release() {
                if matchedRelease {
                    break outerLoop
                } else {
                    releaseID = commitRelease
                    releaseDate = changelogCommit.commit.date
                    matchedRelease = (commitRelease == self.release)
                    releaseCommits = []
                    categorizedEntries = [:]
                }
            }

            if !changelogCommit.changelogEntries.isEmpty {
                for entry in changelogCommit.changelogEntries {
                    categorizedEntries.upsertAppend(value: entry.message, for: entry.typeString)
                }
            }
            releaseCommits.append(changelogCommit)
        }

        if matchedRelease {
            if self.commits {
                releaseCommits.forEach { changelogCommit in
                    print(commitSummary(changelogCommit))
                }
            } else {
                print(markdownRelease(releaseID: releaseID!, date: releaseDate!, categorizedEntries: categorizedEntries))
            }
        }
    }
}
