//
// Created by gavinning on 2022/1/6.
//

import Foundation

public enum LogLevel: Int, Comparable, CustomStringConvertible {
    case trace
    case debug
    case info
    case notice
    case warn
    case error
    case fatal

    public var alias: String {
        description.first!.uppercased()
    }

    public var description: String {
        switch self {
            case .trace: return "trace"
            case .debug: return "debug"
            case .info: return "info"
            case .notice: return "notice"
            case .warn: return "warn"
            case .error: return "error"
            case .fatal: return "fatal"
        }
    }

    public static func <(lhs: LogLevel, rhs: LogLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    public static func from(name: String) -> LogLevel {
        switch name.lowercased() {
            case "trace", "verbose", "gray" : return .trace
            case "debug": return .debug
            case "log", "info": return .info
            case "notice": return .notice
            case "warn", "warning": return .warn
            case "error": return .error
            case "fatal", "critical": return .fatal
            default: return .debug
        }
    }
}
