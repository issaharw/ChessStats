//
//  MonthArchive.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation
import SwiftData

@Model
class MonthArchive: Identifiable, Hashable {
    let archiveUrl: String
    let year: String
    let monthIndex: Int
    let month: String
    
    init(url: String) {
        archiveUrl = url
        let (parsedYear, parsedMonthIndex) = getMonthAndYearOfArchive(archiveUrl: url)
        self.year = parsedYear
        self.monthIndex = parsedMonthIndex
        self.month = getMonthName(from: parsedMonthIndex)
    }

    var id: String {
        archiveUrl
    }
    
    static func == (lhs: MonthArchive, rhs: MonthArchive) -> Bool {
        return lhs.archiveUrl == rhs.archiveUrl
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(archiveUrl)
    }
    
    func isCurrentMonth() -> Bool {
        return isInMonth(date: Date())
    }
    
    func isInMonth(date: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Jerusalem")!

        // Extract the year and month from the current date
        let year = String(calendar.component(.year, from: date))
        let month = calendar.component(.month, from: date)
        return year == self.year && month == self.monthIndex
    }
    
    func getStartAndEndOfMonthInMS() -> (startOfMonth: Int64, endOfMonth: Int64) {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Jerusalem")!
        
        var components = DateComponents()
        components.year = Int(year)
        components.month = monthIndex
        components.day = 1
        
        guard let startOfMonth = calendar.date(from: components),
              let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth) else {
            return (startOfMonth: 0, endOfMonth: 0)
        }
        
        let startOfMonthMillis = Int64(startOfMonth.timeIntervalSince1970 * 1000)
        let endOfMonthMillis = Int64(calendar.startOfDay(for: endOfMonth).timeIntervalSince1970 * 1000 + 86400000 - 1) // end of the day in milliseconds
        
        return (startOfMonthMillis, endOfMonthMillis)
    }
}

class MonthArchives: Codable {
    let archives: [String]
}

private func getMonthAndYearOfArchive(archiveUrl: String) -> (String, Int) {
    let components = archiveUrl.split(separator: "/")
    if components.count >= 2 {
        let month = Int(String(components.last!))!
        let year = String(components.dropLast().last!)
        print("Year: \(year), Month: \(month)")
        return (year, month)
    }
    else {
        return ("", 0)
    }
}


private func getMonthName(from number: Int) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MMMM" // Format for full month name
    
    var components = DateComponents()
    components.month = number
    components.day = 1 // Optional: Just to ensure it's a valid date
    
    let calendar = Calendar.current
    if let date = calendar.date(from: components) {
        return dateFormatter.string(from: date)
    } else {
        return ""
    }
}

