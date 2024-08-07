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
    
    init(date: Date, numberOfGames: Int, gameTypeStats: [DayGameTypeStats]) {
        self.date = date
        self.numberOfGames = numberOfGames
        self.gameTypeStats = gameTypeStats.sorted { Globals.shared.timeClassSorting.firstIndex(of: $0.timeClass) ?? 99 < Globals.shared.timeClassSorting.firstIndex(of: $1.timeClass) ?? 99 }
    }
    
    var id: Date {
        date
    }
}

struct DayGameTypeStats: Identifiable {
    let platform: String
    let timeClass: String
    let date: Date
    let startRating: Int
    let endRating: Int
    let highestRating: Int
    let games: [UserGame]

    init(platform: String, timeClass: String, date: Date, startRating: Int, endRating: Int, highestRating: Int, games: [UserGame]) {
        self.platform = platform
        self.timeClass = timeClass
        self.date = date
        self.startRating = startRating
        self.endRating = endRating
        self.highestRating = highestRating
        self.games = games
    }
    
    var id: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        return dateFormatter.string(from: date) + timeClass
    }

}


let sampleDayStats = DayStats(date: Date(), numberOfGames: 145, gameTypeStats: [])
