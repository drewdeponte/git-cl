import Foundation
import ArgumentParser

struct UnreleasedCommand: ParsableCommand {
    enum CodingKeys: String, CodingKey {
        case commits = "commits"
    }

    private let git: GitShell
    private let changelogCommits: ChangelogCommits
    
    static var configuration: CommandConfiguration {
        return .init(
            commandName: "unreleased",
            abstract: "Unreleased Changes",
            discussion: "Returns the unreleased portion of the changelog"
        )
    }
    
    @Flag(name: .shortAndLong, help: "Generate a list of unreleased commits")
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

        outerLoop: for changelogCommit: ChangelogCommit in self.changelogCommits {
            if let _ = changelogCommit.release() {
                break outerLoop
            }

            if !changelogCommit.changelogEntries.isEmpty {
                for entry in changelogCommit.changelogEntries {
                    categorizedEntries.upsertAppend(value: entry.message, for: entry.typeString)
                }
            }

            // If we have gotten this far it isn't a release commit
            if self.commits {
                print(commitSummary(changelogCommit))
            }
        }

        if !self.commits {
            print(markdownUnreleased(categorizedEntries))
        }
    }
}
