import Foundation
import ArgumentParser

struct UnreleasedCommand: ParsableCommand {
    enum CodingKeys: String, CodingKey {
        case commits = "commits"
        case pre = "pre"
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
        let checkedOutBranch = try! self.git.getCheckedOutBranch()
        if let details = ReleaseDetails(for: checkedOutBranch, using: self.git, startsOnRelease: false, includePreReleases: self.pre) {
            if self.commits {
                details.changelogCommits.forEach { (changelogCommit) in
                     print(commitSummary(changelogCommit))
                 }
            } else {
                print(markdownUnreleased(details.changelogEntries, withLinkRef: true))
            }
        } else if !self.commits {
            print(markdownUnreleased([:]))
        }
    }
}
