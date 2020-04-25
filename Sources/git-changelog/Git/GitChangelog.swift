import Foundation

public final class GitChangelog {
    public enum Error: Swift.Error {
        case commandFailed
    }
    
    private let git: GitShell
    private var changelog: Changelog = Changelog()
    private var currentReleaseID: Changelog.ReleaseID?
    private let regexPattern = #"(added|changed|deprecated|removed|fixed|security|release):\w?(.*)"#
    
    public init() throws {
        self.git = try GitShell(bash: Bash())
    }
    
    func fetchChangelog(from fromRef: String? = nil, to toRef: String? = nil, withMax maxCount: Int? = nil) throws -> Changelog {
        let commits = try self.git.commits(fromRef: fromRef, toRef: toRef, maxCount: maxCount)
        try commits.forEach { commit in
            let changelogBody = commit.body
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: "[changelog]")
                .dropFirst()
                .joined(separator: "\n")
                .trimmingCharacters(in: .whitespacesAndNewlines)
            
            let regex = try NSRegularExpression(pattern: self.regexPattern, options: [])
            let nsrange = NSRange(changelogBody.startIndex..., in: changelogBody)
            regex.enumerateMatches(in: changelogBody, options: [], range: nsrange) { match, _, stop in
                
                guard let match = match else { return }
                
                if match.numberOfRanges == 3 {
                    guard let firstCaptureRange = Range(match.range(at: 1),
                                                        in: changelogBody),
                        let secondCaptureRange = Range(match.range(at: 2),
                                                       in: changelogBody) else {
                                                        return
                    }
                    
                    let category = changelogBody[firstCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)
                    let message = changelogBody[secondCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    switch category {
                    case "release":
                        currentReleaseID = message
                        changelog.releases[currentReleaseID!] = Changelog.Release(date: commit.date, id: currentReleaseID!, categorizedEntries: [:])
                    default:
                        if let releaseID = currentReleaseID {
                            if let _ = changelog.releases[releaseID]!.categorizedEntries[category] {
                                changelog.releases[releaseID]!.categorizedEntries[category]!.append(message)
                            } else {
                                changelog.releases[releaseID]!.categorizedEntries[category] = [message]
                            }
                        } else {
                            if let _ = changelog.unreleased.categorizedEntries[category] {
                                changelog.unreleased.categorizedEntries[category]!.append(message)
                            } else {
                                changelog.unreleased.categorizedEntries[category] = [message]
                            }
                        }
                    }
                }
            }
        }
        return self.changelog
    }
}

extension String {
    func replaceCharactersFromSet(characterSet: CharacterSet, replacementString: String = "") -> String {
        return self.components(separatedBy: characterSet).joined(separator: replacementString)
    }
}
