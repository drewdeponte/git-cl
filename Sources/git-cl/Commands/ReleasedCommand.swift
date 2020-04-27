import Foundation
import ArgumentParser

struct ReleasedCommand: ParsableCommand {
    enum CodingKeys: String, CodingKey {
        case commits = "commits"
        case release = "release"
    }
    
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
        
    let changelogAction = ChangelogAction()
    let markdownAction = MarkdownAction()
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commits = try container.decode(Bool.self, forKey: .commits)
        self.release = try container.decode(String.self, forKey: .release)
    }
    
    func run() throws {
        if self.commits {
            try self.changelogAction.parse()
            print(self.changelogAction.releasedCommits.description)
            return
        }
        
        let changes = try self.changelogAction.parse()
        let markdown = self.markdownAction.generateRelease(
            from: changes,
            for: release
        )
        print(markdown)
    }
}
