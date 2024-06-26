//
//  DateUtil.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation

extension Date {
    func beginningOfDay() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Jerusalem")!
        return calendar.startOfDay(for: self)
    }

    func adjustedForNightGames() -> Date {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Jerusalem")!
        let sixAM = calendar.date(bySettingHour: 6, minute: 0, second: 0, of: self)!
        if self < sixAM {
            return calendar.date(byAdding: .day, value: -1, to: self)!.beginningOfDay()
        } else {
            return self.beginningOfDay()
        }
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Jerusalem")
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter.string(from: self)
    }

    func timeFormatted() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Jerusalem")
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    func dateFormatForLog() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Jerusalem")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }

    func dateFormatForLogFile() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "Asia/Jerusalem")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

}

func now() -> Int {
    return Int(Date().timeIntervalSince1970 * 1000)
}


extension Int {
    func timeFormatted() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(self))
        return date.timeFormatted()

    }
}
