import Foundation

public func matchesRelease(_ value: String) -> Bool {
    let releaseOrPreReleaseRegexPattern = #"^v?\d+\.\d+\.\d+(-[0-9A-Za-z-\.]+)?$"#

    return value.matches(releaseOrPreReleaseRegexPattern)
}

public struct Release {
    let major: Int
    let minor: Int
    let patch: Int
    let pre: String?
    let tag: Tag

    var isPreRelease: Bool {
        return self.pre != nil
    }
}

extension Release {
    public init?(_ tag: Tag) {
        self.tag = tag
        guard matchesRelease(tag) else { return nil }

        let sections = tag.split(separator: "-")
        guard sections.count >= 1 else { return nil }

        let mainSection = sections[0]
        let versComponents = mainSection.components(separatedBy: ".")
        guard versComponents.count == 3 else { return nil }

        var pre: String?
        if sections.count >= 2 { // has a pre section
            pre = sections[1...].joined(separator: "-")
        }

        self.major = Int(versComponents[0].replacingOccurrences(of: "v", with: ""))!
        self.minor = Int(versComponents[1])!
        self.patch = Int(versComponents[2])!
        self.pre = pre
    }
}

extension Release: Comparable {
    public static func < (lhs: Release, rhs: Release) -> Bool {
        if lhs.major != rhs.major {
            return lhs.major < rhs.major
        } else {
            if lhs.minor != rhs.minor {
                return lhs.minor < rhs.minor
            } else {
                if lhs.patch != rhs.patch {
                    return lhs.patch < rhs.patch
                } else { // go into pre-release
                    return lhs.patch < rhs.patch
                }
            }
        }
    }
}
