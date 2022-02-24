//
// Created by gavinning on 2022/1/6.
//

import Helper
import Rainbow

public enum LogColorField: String {
    case APP
    case LABEL
    case TIME
    case LEVEL
    case FN
    case FILEPATH
    case FILENAME
    case LINE
    case COLUMN
    case MESSAGE
}

public enum LogColorMode: String {
    case base = "[TIME:LEVEL] MESSAGE"
    case long = "[TIME:LEVEL:APP] MESSAGE [FN:FILENAME:LINE:COLUMN]"
    case full = "[TIME:LEVEL:APP:LABEL] MESSAGE [FN:FILEPATH:LINE:COLUMN]"
}

public typealias FieldAction = (_ message: LogMessage) -> String

public struct LogColor: LogHandler {
    var format: String
    var custom: Dictionary<String, FieldAction>

    /// 染色日志处理
    ///
    /// ```
    /// mode:
    ///     base = "[TIME:LEVEL] MESSAGE"
    ///     long = "[TIME:LEVEL:APP] MESSAGE [FN:FILENAME:LINE:COLUMN]"
    ///     full = "[TIME:LEVEL:APP:LABEL] MESSAGE [FN:FILEPATH:LINE:COLUMN]"
    ///
    /// Example:
    ///     LogColor(mode: .base)
    ///     LogColor(mode: .long)
    ///     LogColor(mode: .full)
    ///
    ///     LogColor(customFields: ["TIME": (message) -> String])
    ///     LogColor(customFields: ["UUID": (message) -> String])
    ///     LogColor(customFields: ["CUSTOM": (message) -> String])
    /// ```
    ///
    /// - Parameters:
    ///   - mode:   日志格式化模式
    ///   - custom: 日志自定义输出字段
    ///
    public init(mode: LogColorMode = .base, customFields custom: Dictionary<String, FieldAction> = [:]) {
        self.init(format: mode.rawValue, customFields: custom)
    }

    /// 染色日志处理
    ///
    /// 可处理字段参照 `LogField`
    ///
    /// ```
    /// Example:
    ///     LogColor(format: "[TIME:LEVEL] MESSAGE")
    ///     LogColor(format: "[TIME:LEVEL:APP] MESSAGE [FN:FILENAME:LINE:COLUMN]")
    ///     LogColor(format: "[TIME:LEVEL:APP:LABEL] MESSAGE [FN:FILEPATH:LINE:COLUMN]")
    ///
    ///     LogColor(customFields: ["TIME": (message) -> String])
    ///     LogColor(customFields: ["UUID": (message) -> String])
    ///     LogColor(customFields: ["CUSTOM": (message) -> String])
    /// ```
    ///
    /// - Parameters:
    ///   - format: 日志格式化字符串
    ///   - custom: 日志自定义输出字段
    public init(format: String, customFields custom: Dictionary<String, FieldAction> = [:]) {
        self.format = format
        self.custom = custom
    }

    public func log(_ message: LogMessage) {
        print(LogColorHandler(message, format, custom).render())
    }
}

struct LogColorHandler {
    var format: String
    var message: LogMessage
    var logMap: Dictionary<LogColorField, String>
    var custom: Dictionary<String, FieldAction>

    init(_ message: LogMessage, _ format: String, _ custom: Dictionary<String, FieldAction>) {
        self.format = format
        self.custom = custom
        self.message = message
        logMap = [
            .APP: message.app,
            .LABEL: message.label ?? .empty,
            .TIME: message.timestamp,
            .LEVEL: message.level.alias,
            .FN: message.base.fn,
            .FILEPATH: message.base.file,
            .FILENAME: Path(message.base.file).basename,
            .LINE: message.base.line.description,
            .COLUMN: message.base.column.description,
        ]
    }

    func render() -> String {
        var template = format
        // 优先级从上到下
        renderCustom(&template)
        renderNormal(&template)
        renderMessage(&template)
        return template
    }

    /// 处理常规字段
    private func renderNormal(_ template: inout String) {
        logMap.forEach { (key, value) in
            template = template.replacingOccurrences(of: key.rawValue, with: value)
        }
    }

    /// 处理自定义字段
    private func renderCustom(_ template: inout String) {
        custom.map { (key, value) in (key, value(message))  }.forEach { (key, value) in
            template = template.replacingOccurrences(of: key, with: value)
        }
    }

    /// 处理Message并染色
    private func renderMessage(_ template: inout String) {
        let tmp = template.components(separatedBy: LogColorField.MESSAGE.rawValue)
        tmp.forEach { template = template.replacingOccurrences(of: $0, with: $0.lightBlack ) }
        template = template.replacingOccurrences(of: LogColorField.MESSAGE.rawValue, with: colorMessage())
    }

    // 日志分级染色
    private func colorMessage() -> String {
        switch message.level {
            case .trace: return message.value.lightBlack
            case .debug: return message.value.hex("1EA9A2")
            case .info: return message.value.green
            case .notice: return message.value.lightBlue
            case .warn: return message.value.yellow
            case .error: return message.value.red
            case .fatal: return message.value.red.bold.underline
        }
    }
}
