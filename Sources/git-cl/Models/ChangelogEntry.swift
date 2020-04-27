import Foundation

public enum ChangelogEntry {
    case release(String)
    case added(String)
    case changed(String)
    case deprecated(String)
    case removed(String)
    case fixed(String)
    case security(String)

    public var typeString: String {
        switch self {
        case .added: return "added"
        case .changed: return "changed"
        case .deprecated: return "deprecated"
        case .fixed: return "fixed"
        case .release: return "release"
        case .removed: return "removed"
        case .security: return "security"
        }
    }

    public var message: String {
        switch self {
        case .added(let msg): return msg
        case .changed(let msg): return msg
        case .deprecated(let msg): return msg
        case .fixed(let msg): return msg
        case .release(let msg): return msg
        case .removed(let msg): return msg
        case .security(let msg): return msg
        }
    }
}
