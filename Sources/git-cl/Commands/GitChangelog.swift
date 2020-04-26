import Foundation
import ArgumentParser

public class GitChangelog: ParsableCommand {
    public static var configuration: CommandConfiguration {
        return .init(
            commandName: "git-cl",
            abstract: "Git Changelog Generation",
            discussion: "Generates a CHANGELOG.md compatible file based on changelog entries in your git commits.",
            version: VERSION.description,
            subcommands: [FullCommand.self, UnreleasedCommand.self, ReleasedCommand.self]
        )
    }
    
    required public init() {
        
    }

    public func run() throws {
        print("Missing command arguments. Please run git-cl --help to see all available commands.")
    }
}

extension String {
    func replaceCharactersFromSet(characterSet: CharacterSet, replacementString: String = "") -> String {
        return self.components(separatedBy: characterSet).joined(separator: replacementString)
    }
}
