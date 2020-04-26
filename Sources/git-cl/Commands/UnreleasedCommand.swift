import Foundation
import ArgumentParser

struct UnreleasedCommand: ParsableCommand {
    enum CodingKeys: String, CodingKey {
        case commits = "commits"
    }
    
    static var configuration: CommandConfiguration {
        return .init(
            commandName: "unreleased",
            abstract: "Unreleased Changes",
            discussion: "Returns the unreleased portion of the changelog"
        )
    }
    
    @Flag(name: .shortAndLong, help: "Generate a list of unreleased commits")
    var commits: Bool
    
    let changelogAction = ChangelogAction()
    let markdownAction = MarkdownAction()
    
    init() {
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.commits = try container.decode(Bool.self, forKey: .commits)
    }
    
    func run() throws {
        if self.commits {
            try self.changelogAction.parse()
            print(self.changelogAction.unreleasedCommits.description)
            return
        }
        
        let changes = try self.changelogAction.parse()
        let markdown = try self.markdownAction.generate(
            .unreleased,
            from: changes,
            with: self.changelogAction.repositoryURL()
        )
        print(markdown)
    }
}
