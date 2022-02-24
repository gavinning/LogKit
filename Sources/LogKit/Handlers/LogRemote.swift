//
// Created by gavinning on 2022/2/23.
//

import Foundation

public struct LogRemote: LogHandler {
    var level: LogLevel

    public init(level: LogLevel = .error) {
        self.level = level
    }

    public func log(_ message: LogMessage) {
        guard message.level >= level else { return }
        print("Send log message to remote server:", message.description)
    }
}
