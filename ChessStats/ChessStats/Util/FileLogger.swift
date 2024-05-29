import Foundation

class FileLogger {
    static let shared = FileLogger()
    private let logFileURL: URL
    private let dataFileURL: URL
    
    private init() {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        logFileURL = urls[0].appendingPathComponent("app-\(Date().dateFormatForLogFile()).log")
        dataFileURL = urls[0].appendingPathComponent("data-\(Date().dateFormatForLogFile()).log")
    }
    
    func log(_ message: String) {
        let timestamp = Date().dateFormatForLog()
        let logMessage = "- \(timestamp): \(message)\n"
        
        if let data = logMessage.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: logFileURL.path) {
                if let fileHandle = try? FileHandle(forWritingTo: logFileURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                try? data.write(to: logFileURL, options: .atomic)
            }
        }
    }
    
    func logData(header: String, data: String) {
        let timestamp = Date().dateFormatForLog()
        let logMessage = "--------------------------------- \n\(timestamp): \(header)\n\(data)\n"
        
        if let data = logMessage.data(using: .utf8) {
            if FileManager.default.fileExists(atPath: dataFileURL.path) {
                if let fileHandle = try? FileHandle(forWritingTo: dataFileURL) {
                    fileHandle.seekToEndOfFile()
                    fileHandle.write(data)
                    fileHandle.closeFile()
                }
            } else {
                try? data.write(to: dataFileURL, options: .atomic)
            }
        }
    }
    
    func readLogs() -> String? {
        return try? String(contentsOf: logFileURL)
    }

    func readDataLogs() -> String? {
        return try? String(contentsOf: dataFileURL)
    }
}

func debug(_ message: String) {
    FileLogger.shared.log(message)
}

func debugData(header: String, data: String) {
    FileLogger.shared.logData(header: header, data: data)
}

