//
//  DayStats.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation

struct DayStats: Identifiable {
    let date: Date
    let numberOfGames: Int
    let gameTypeStats: [DayGameTypeStats]
    
    var id: Date {
        date
    }
}

struct DayGameTypeStats: Identifiable {
    let timeClass: String
    let date: Date
    let startRating: Int
    let endRating: Int
    let highestRating: Int
    let games: [UserGame]

    var id: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.string(from: date) + timeClass
    }

}


let sampleDayStats = DayStats(date: Date(), numberOfGames: 145, gameTypeStats: [])
