//
// Created by gavinning on 2022/1/6.
//

import Helper
import Foundation

public struct LogMessage: CustomStringConvertible {
    public var app: String
    public var label: String?
    public var base: LogBase
    public var meta: LogMeta?
    public var level: LogLevel
    public var value: String
    public var timestamp: String { Date().format(from: "yyyy-MM-dd'T'HH:mm:ss+0800") }

    public var description: String {
        "[\(timestamp):\(app):\(label ?? ""):\(level.alias):\(base.description)]\(value)"
    }
}
