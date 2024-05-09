//
//  MonthArchive.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation

struct MonthArchive: Identifiable, Hashable {
    let archiveUrl: String
    let year: String
    private let monthIndex: Int
    let month: String
    
    init(url: String) {
        archiveUrl = url
        (year, monthIndex) = getMonthAndYearOfArchive(archiveUrl: url)
        month = getMonthName(from: monthIndex)
    }

    var id: String {
        archiveUrl
    }
    
    func isInMonth(date: Date) -> Bool {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Jerusalem")!

        // Extract the year and month from the current date
        let year = String(calendar.component(.year, from: date))
        let month = calendar.component(.month, from: date)
        return year == self.year && month == self.monthIndex
    }
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

