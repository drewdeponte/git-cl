import XCTest
import Foundation

final class GitCLTests: XCTestCase {
    func regexTest() throws {
        let regexPattern = #"(added|changed|deprecated|removed|fixed|security)(?-i):\w?(.*)"#
        
        let body = """
        This is a commit Summary

        This is the message
        [changelog]
        added: ONE THING
        ADDED: Another Thing
        Added: Seomthing
        """
        let changelogBody = body
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "[changelog]")
            .dropFirst()
            .joined(separator: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let regex = try! NSRegularExpression(pattern: regexPattern, options: [.caseInsensitive])

        var changelogEntries: [String] = []

        let nsrange = NSRange(changelogBody.startIndex..<changelogBody.endIndex, in: changelogBody)
        regex.enumerateMatches(in: changelogBody, options: [], range: nsrange) { match, _, stop in
            guard let match = match else { return }

            if match.numberOfRanges == 3 {
                guard let firstCaptureRange = Range(match.range(at: 1), in: changelogBody),
                    let secondCaptureRange = Range(match.range(at: 2), in: changelogBody) else { return }

                let category = changelogBody[firstCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)
                let message = changelogBody[secondCaptureRange].trimmingCharacters(in: .whitespacesAndNewlines)
                
                switch category.lowercased() {
                case "added":
                    changelogEntries.append("added: \(message)")
                case "changed":
                    changelogEntries.append("changed: \(message)")
                case "deprecated":
                    changelogEntries.append("deprecated: \(message)")
                case "removed":
                    changelogEntries.append("removed: \(message)")
                case "fixed":
                    changelogEntries.append("fixed: \(message)")
                case "security":
                    changelogEntries.append("security: \(message)")
                default:
                    return
                }
            }
        }
        
        
        XCTAssertEqual(changelogEntries.count, 3)
    }

    static var allTests = [
        ("regexTest", regexTest),
    ]
}
