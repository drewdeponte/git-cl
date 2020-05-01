import Foundation
import ArgumentParser

struct ReleasedCommand: ParsableCommand {
    enum CodingKeys: String, CodingKey {
        case commits = "commits"
        case release = "release"
        case pre = "pre"
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

    @Flag(name: .shortAndLong, help: "Include pre-releases in the output")
    var pre: Bool

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
        self.pre = try container.decode(Bool.self, forKey: .pre)
        self.release = try container.decode(String.self, forKey: .release)
    }
    
    func run() throws {
        let releases = try self.git.tags()
            .compactMap({ Release($0) })
            .filter({ self.pre ? true : !$0.isPreRelease })

        if let selectedRelease = releases.first(where: { $0.tag == self.release }) {
            let details = ReleaseDetails(for: selectedRelease.tag, using: self.git, includePreReleases: self.pre)!
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
