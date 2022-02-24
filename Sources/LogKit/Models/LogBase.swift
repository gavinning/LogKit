//
// Created by gavinning on 2022/1/6.
//

import Helper

public struct LogBase: CustomStringConvertible {
    public let file: String
    public let fn: String
    public let line: Int
    public let column: Int
    public var description: String { toString() }

    public enum FileType {
        case base
        case full
    }

    public init(_ file: String = #file, _ fn: String = #function, _ line: Int = #line, _ column: Int = #column) {
        self.file = file
        self.fn = fn
        self.line = line
        self.column = column
    }

    public func toString(type: FileType = .base) -> String {
        "\(fn):\(filename(type)):\(line):\(column)"
    }

    private func filename(_ type: FileType = .base) -> String {
        type == .base ? Path(file).basename : file
    }
}
