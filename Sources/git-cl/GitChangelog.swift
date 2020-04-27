import Foundation

public final class GitChangelog {
   public enum Error: Swift.Error {
        case invalidArgumentCount
        case commandFailed
    }

    private let regexPattern = #"(added|changed|deprecated|removed|fixed|security|release):\w?(.*)"#
    private let arguments: [String]
    private let git: GitShell
    private let markdown: MarkdownGenerator
    private var changelog: Changelog = Changelog()
    private var currentReleaseID: Changelog.ReleaseID?

    public init(arguments: [String] = CommandLine.arguments) throws {
        self.arguments = arguments
        self.git = try GitShell(bash: Bash())
        self.markdown = MarkdownGenerator()
    }

    public func run() throws {
        guard self.arguments.count >= 1 else {
            throw Error.invalidArgumentCount
        }

        if self.arguments.count > 1 {
            let subcommand = self.arguments[1]
            switch subcommand {
            case "--version":
                print("v\(VERSION)")
                
            case "--from", "-f":
                var toRef = "HEAD"
                if self.arguments.count > 3 {
                    let to = self.arguments[3]
                    switch to {
                    case "--to", "-t":
                        toRef = self.arguments[4]
                    default:
                        toRef = "HEAD"
                    }
                }
                let fromRef = self.arguments[2]
                try self.fetchChangelog(from: fromRef, to: toRef)
            
            case "--max", "-m":
                let count = Int(self.arguments[2])
                try self.fetchChangelog(withMax: count)
                
            default:
                print("Unrecognized commande line arguments")
            }
        } else {
            try self.fetchChangelog()
        }
    }
    
    func fetchChangelog(from fromRef: String? = nil, to toRef: String? = nil, withMax maxCount: Int? = nil) throws {
        let commitsSequence: Commits = try self.git.commits(fromRef: fromRef, toRef: toRef, maxCount: maxCount)

        for commit in commitsSequence {
            // this commit has version bump

            // skip commits that don't have body because obviously they don't have any changelog entries
            guard let body = commit.body else { continue }

            let changelogBody = body.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "[changelog]").dropFirst().joined(separator: "\n").trimmingCharacters(in: .whitespacesAndNewlines)
            let regex = try NSRegularExpression(pattern: self.regexPattern, options: [])

            let nsrange = NSRange(changelogBody.startIndex..<changelogBody.endIndex, in: changelogBody)
            regex.enumerateMatches(in: changelogBody, options: [], range: nsrange) { [weak self] match, _, stop in
                guard let match = match else { return }

                if match.numberOfRanges == 3 {
                    guard let firstCaptureRange = Range(match.range(at: 1), in: changelogBody),
                        let secondCaptureRange = Range(match.range(at: 2), in: changelogBody) else { return }

                    let category = changelogBody[firstCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)
                    let message = changelogBody[secondCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)

                    switch category {
                    case "release":
                        self?.currentReleaseID = message
                        self?.changelog.releases[currentReleaseID!] = Changelog.Release(date: commit.date, id: currentReleaseID!, categorizedEntries: [:])
                    default:
                        if let releaseID = currentReleaseID {
                            if let _ = self?.changelog.releases[releaseID]!.categorizedEntries[category] {
                                self?.changelog.releases[releaseID]!.categorizedEntries[category]!.append(message)
                            } else {
                                self?.changelog.releases[releaseID]!.categorizedEntries[category] = [message]
                            }
                        } else {
                            if let _ = self?.changelog.unreleased.categorizedEntries[category] {
                                self?.changelog.unreleased.categorizedEntries[category]!.append(message)
                            } else {
                                self?.changelog.unreleased.categorizedEntries[category] = [message]
                            }
                        }
                    }
                }
            }
        }
        
        let markdown = try self.markdown.generate(.both, from: self.changelog, with: self.git.findRespoitoryOriginURL())
        print(markdown)
    }
}

extension String {
  func replaceCharactersFromSet(characterSet: CharacterSet, replacementString: String = "") -> String {
    return self.components(separatedBy: characterSet).joined(separator: replacementString)
  }
}
