import Rainbow

public struct Logger {
    var app: String
    var label: String?
    var level = LogLevel.trace
    var disableConsoleLog = false
    var handlers: [LogHandler]

    public init(app: String = "Default", label: String? = nil, level: LogLevel = .trace, disableConsoleLog: Bool = false, handler: LogHandler = LogColor()) {
        self.init(app: app, label: label, level: level, disableConsoleLog: disableConsoleLog, handlers: [handler])
    }

    public init(app: String = "Default", label: String? = nil, level: LogLevel = .trace, disableConsoleLog: Bool = false, handlers: [LogHandler]) {
        self.app = app
        self.label = label
        self.level = level
        self.disableConsoleLog = disableConsoleLog
        self.handlers = handlers
    }

    private func log(level: LogLevel, _ items: [Any], _ base: LogBase) {
        let message = LogMessage(
            app: app,
            label: label,
            base: base,
            meta: nil,
            level: level,
            value: items.map { "\($0)" }.joined(separator: " ")
        )
        if enabled(level) { handlers.forEach { $0.log(message) } }
    }

    private func enabled(_ level: LogLevel) -> Bool {
        disableConsoleLog == false && level >= self.level
    }
}

public extension Logger {
    func trace(_ items: Any..., file: String = #file, fn: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .trace, items, LogBase(file, fn, line, column))
    }

    func debug(_ items: Any..., file: String = #file, fn: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .debug, items, LogBase(file, fn, line, column))
    }

    func info(_ items: Any..., file: String = #file, fn: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .info, items, LogBase(file, fn, line, column))
    }

    func notice(_ items: Any..., file: String = #file, fn: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .notice, items, LogBase(file, fn, line, column))
    }

    func warn(_ items: Any..., file: String = #file, fn: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .warn, items, LogBase(file, fn, line, column))
    }

    func error(_ items: Any..., file: String = #file, fn: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .error, items, LogBase(file, fn, line, column))
    }

    func fatal(_ items: Any..., file: String = #file, fn: String = #function, line: Int = #line, column: Int = #column) {
        log(level: .fatal, items, LogBase(file, fn, line, column))
    }
}
