import Foundation
import ArgumentParser

struct FullCommand: ParsableCommand {
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
        
    }
    
    init(from decoder: Decoder) throws {
        
    }
    
    func run() throws {
        let changes = try self.changelogAction.parse()
        let markdown = try self.markdownAction.generate(
            .both,
            from: changes,
            with: self.changelogAction.repositoryURL()
        )
        print(markdown)
    }
}
