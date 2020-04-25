//
//  LogCommand.swift
//  
//
//  Created by Anthony Castelli on 4/8/20.
//

import Foundation
import ConsoleKit

final class LogCommand: Command {
    struct Signature: CommandSignature {
        @Option(name: "max", short: "m", help: "Maximum amonut of commits to fetch")
        var max: Int?
        
        @Option(name: "from", short: "f", help: "From reference")
        var from: String?
        
        @Option(name: "to", short: "t", help: "To reference")
        var to: String?
        
        @Flag(name: "yes", short: "y", help: "Automatically chooses yes for everything")
        var yes: Bool
        
        init() { }
    }

    var help: String {
        return "Generates a new Markdown Changelog."
    }
    
    let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = .current
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    func run(using context: CommandContext, signature: Signature) throws {
        let changelog = try GitChangelog()
        
        let loadingBar = context.console.loadingBar(title: "Generating changelog")
        loadingBar.start()
        let results = try changelog.fetchChangelog(from: signature.from, to: signature.to, withMax: signature.max)
        
        loadingBar.succeed()
        
        let markdown = self.generateChangelog(using: context, from: results)
        
        if signature.yes {
            context.console.output("Saving CHANGELOG.md".consoleText(.info))
            try self.save(using: context, from: markdown)
            return
        }
        let shouldSave = context.console.ask("Do you want to save this file? y/n".consoleText(.info))
        if shouldSave == "y" || shouldSave == "yes" {
            try self.save(using: context, from: markdown)
        }
    }
    
    func generateChangelog(using context: CommandContext, from changelog: Changelog) -> String {
        var markdownChanglog = """
        # Changelog

        All notable changes to this project will be documented in this file.

        The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
        and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
        """

        markdownChanglog += "\n\n## Unreleased - now\n"

        changelog.unreleased.categorizedEntries.forEach { category, entries in
            markdownChanglog += "\n### \(category.capitalized)\n"
            entries.forEach { markdownChanglog += "- \($0)\n" }
        }

        changelog.releases.forEach { releaseID, release in
            markdownChanglog += "\n\n## \(releaseID) - \(self.dateFormatter.string(from: release.date))\n"
            release.categorizedEntries.forEach { category, entries in
                markdownChanglog += "\n### \(category.capitalized)\n"
                entries.forEach { markdownChanglog += "- \($0)\n" }
            }
        }
        
        context.console.output(ConsoleText(stringLiteral: markdownChanglog))
        return markdownChanglog
    }
    
    func save(using context: CommandContext, from markdown: String) throws {
        let currentDirectory = FileManager.default.currentDirectoryPath
        try markdown.write(
            to: URL(fileURLWithPath: currentDirectory + "/CHANGELOG.md"), atomically: true,
            encoding: .utf8
        )
        context.console.output("CHANGELOG.md Saved!".consoleText(.success))
    }
}
