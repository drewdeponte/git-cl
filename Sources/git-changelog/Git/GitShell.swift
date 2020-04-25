import Foundation

public class GitShell {
    public enum Error: Swift.Error {
        case gitLogFailure
    }

    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = .current
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private let path: String

    public init(bash: Bash, path: String? = nil) throws {
        if let p = path {
            self.path = p
        } else {
            self.path = try bash.which("git")
        }
    }

    public func commits(fromRef: String? = nil, toRef: String? = nil, maxCount: Int? = nil) throws -> [Commit] {
        // Grab our additional commands
        var aditionalCommands = [String]()
        if let fromRef = fromRef, let toRef = toRef {
            aditionalCommands.append("\(fromRef)..\(toRef)")
        } else if let fromRef = fromRef {
            aditionalCommands.append("\(fromRef)..HEAD")
        }
        if let maxCount = maxCount {
            aditionalCommands.append("--max-count=\(maxCount)")
        }
        
        let result = try run(self.path, arguments: ["log", "--pretty=format:----GIT-CHANGELOG-COMMIT-BEGIN----%n%H%n%as%n%B"] + aditionalCommands)
        guard result.isSuccessful else { throw Error.gitLogFailure }

        if let output = result.standardOutput {
            let commitTextBlobs = output.components(separatedBy: "----GIT-CHANGELOG-COMMIT-BEGIN----\n").dropFirst()
            return commitTextBlobs.map { (commitTextBlob) -> Commit in
                let lines = commitTextBlob.trimmingCharacters(in: .whitespacesAndNewlines) .components(separatedBy: "\n")
                return Commit(sha: lines[0], date: formatter.date(from: lines[1])!, body: lines[2..<lines.count].joined(separator: "\n"))
            }
        }
        return []
    }

    public func findDotGit() throws -> URL? {
        let result = try run(self.path, arguments: ["rev-parse", "--show-toplevel"])
        guard result.isSuccessful == true else { return nil }
        guard let output = result.standardOutput else { return nil }
        let repositoryTopLevelPath = output.trimmingCharacters(in: .whitespacesAndNewlines)
        let pathComponents = [repositoryTopLevelPath, ".git"]

        let dotGitURL = URL(fileURLWithPath: pathComponents.joined(separator: "/"))
//        guard let dotGitURL = NSURL.fileURL(withPathComponents: pathComponents) else {
//            return nil
//        }

        if self.directoryExists(atPath: dotGitURL.path) {
            return dotGitURL
        } else {
            return nil
        }
    }
    
    func directoryExists(atPath path: String) -> Bool {
        var isDirectory = ObjCBool(true)
        let exists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
