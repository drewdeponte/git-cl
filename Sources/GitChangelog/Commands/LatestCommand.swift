import Foundation
import ArgumentParser

struct LatestCommand: ParsableCommand {
    enum CodingKeys: String, CodingKey {
        case commits = "commits"
        case pre = "pre"
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

    @Flag(name: .shortAndLong, help: "Include pre-releases in the output")
    var pre: Bool

    init() {
        self.git = try! GitShell(bash: Bash())
        self.changelogCommits = ChangelogCommits(commits: try! self.git.commits())
    }

    init(from decoder: Decoder) throws {
        self.git = try! GitShell(bash: Bash())
        self.changelogCommits = ChangelogCommits(commits: try! self.git.commits())

        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commits = try container.decode(Bool.self, forKey: .commits)
        self.pre = try container.decode(Bool.self, forKey: .pre)
    }

    func run() throws {
        let releases = try self.git.tags()
            .compactMap({ Release($0) })
            .filter({ self.pre ? true : !$0.isPreRelease })
            .sorted(by: >) // sort in decending order

        if let release = releases.first {
            let details = ReleaseDetails(for: release.tag, using: self.git, includePreReleases: self.pre)!
            if self.commits {
                details.changelogCommits.forEach { (changelogCommit) in
                    print(commitSummary(changelogCommit))
                }
            } else {
                print(markdownRelease(releaseID: details.tag, date: details.date, categorizedEntries: details.changelogEntries, withLinkRef: true))
            }
        }
    }
}
