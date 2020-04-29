import Foundation

public struct Commits: Sequence {
    let formattedGitLogOutput: String

    public func makeIterator() -> CommitsIterator {
        return CommitsIterator(self)
    }
}

public struct CommitsIterator: IteratorProtocol {
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private var previousRange: Range<String.Index>?
    private var isExhausted: Bool = false
    private let commits: Commits
    
    init(_ commits: Commits) {
        self.commits = commits
    }

    private func isFirstMatch() -> Bool {
        return self.previousRange == nil
    }

    public mutating func next() -> Commit? {
        guard !isExhausted else { return nil }

        var searchRange: Range<String.Index>?
        if let prevRange = self.previousRange {
            searchRange = prevRange.upperBound..<self.commits.formattedGitLogOutput.endIndex
        } else {
            searchRange = self.commits.formattedGitLogOutput.startIndex..<self.commits.formattedGitLogOutput.endIndex
        }

        if let range = self.commits.formattedGitLogOutput.range(of: "----GIT-CHANGELOG-COMMIT-BEGIN----\n", range: searchRange) {
            if self.isFirstMatch() {
                self.previousRange = range
                return self.next()
            } else {
                // grab the content between the end of the previous range and the beginning of the new range
                let contentRange: Range<String.Index> = self.previousRange!.upperBound..<range.lowerBound
                let rawCommitContent = self.commits.formattedGitLogOutput[contentRange]
                let lines = rawCommitContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")
                self.previousRange = range

                var hasBody =  false
                if lines.endIndex >= 5 {
                    hasBody = true
                }
            
                return Commit(sha: lines[0], date: dateFormatter.date(from: lines[2])!, summary: lines[3], body: (hasBody ? lines[5..<lines.count].joined(separator: "\n") : nil), tags: self.extractTags(str: lines[1]))
            }
        } else { // should be the end of the content
            if isFirstMatch() { return nil }

            self.isExhausted = true
            let contentRange: Range<String.Index> = self.previousRange!.upperBound..<self.commits.formattedGitLogOutput.endIndex
            let rawCommitContent = self.commits.formattedGitLogOutput[contentRange]
            let lines = rawCommitContent.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: "\n")

            self.previousRange = nil
            self.isExhausted = true

            var hasBody =  false
            if lines.endIndex >= 5 {
                hasBody = true
            }

            return Commit(sha: lines[0], date: dateFormatter.date(from: lines[2])!, summary: lines[3], body: (hasBody ? lines[5..<lines.count].joined(separator: "\n") : nil), tags: self.extractTags(str: lines[1]))
        }
    }

    private func extractTags(str: String) -> [String] {
        let cleansedStr = str.replacingOccurrences(of: " (", with: "").replacingOccurrences(of: ")", with: "").trimmingCharacters(in: .whitespacesAndNewlines)

        var tags: [String] = []
        cleansedStr.split(separator: ",").forEach { item in
            let cleansedItem = item.trimmingCharacters(in: .whitespacesAndNewlines)
            if cleansedItem.count > 5 {
                if cleansedItem.prefix(5) == "tag: " { // we have a tag
                    let tagValueStartIndex = cleansedItem.index(cleansedItem.startIndex, offsetBy: 5, limitedBy: cleansedItem.endIndex)!
                    let tagVal = String(cleansedItem[tagValueStartIndex..<cleansedItem.endIndex])
                    tags.append(tagVal)
                }
            }
        }
        return tags
    }
}

public class GitShell {
    public enum Error: Swift.Error {
        case gitLogFailure
    }

    private let path: String

    public init(bash: Bash, path: String? = nil) throws {
        if let p = path {
            self.path = p
        } else {
            self.path = try bash.which("git")
        }
    }

    public func commits() throws -> Commits {
        let result = try run(self.path, arguments: ["--no-pager", "log", "--pretty=format:----GIT-CHANGELOG-COMMIT-BEGIN----%n%H%n%d%n%as%n%B"])
        guard result.isSuccessful else { throw Error.gitLogFailure }
        guard let output = result.standardOutput else { return Commits(formattedGitLogOutput: "") }
        
        return Commits(formattedGitLogOutput: output)
    }

    public func findDotGit() throws -> URL? {
        let result = try run(self.path, arguments: ["rev-parse", "--show-toplevel"])
        guard result.isSuccessful == true else { return nil }
        guard let output = result.standardOutput else { return nil }

        let repositoryTopLevelPath = output.trimmingCharacters(in: .whitespacesAndNewlines)
        let pathComponents = [repositoryTopLevelPath, ".git"]

        guard let dotGitURL = NSURL.fileURL(withPathComponents: pathComponents) else { return nil }

        if directoryExists(atPath: dotGitURL.path) {
            return dotGitURL
        } else {
            return nil
        }
    }
    
    public func findRespoitoryOriginURL() throws -> URL? {
        let result = try run(self.path, arguments: ["remote", "get-url", "origin"])
        guard result.isSuccessful == true else { return nil }
        guard var output = result.standardOutput else { return nil }
        if output.contains("ssh") {
            output = output
                .replacingOccurrences(of: "git@", with: "https://")
                .replacingOccurrences(of: ":", with: "/")
        }
        return URL(string: String(output.dropLast(5)))
    }
}

fileprivate func directoryExists(atPath path: String) -> Bool {
    var isDirectory = ObjCBool(true)
    let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
    return exists && isDirectory.boolValue
}
