//
//  UserGame.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation
import SwiftData

let DRAW_RESULTS = ["agreed", "repetition", "stalemate", "insufficient", "50move", "timevsinsufficient"]

@Model
class UserGame: Identifiable, Equatable {
    let url: String
    let uuid: String
    let endTime: Int
    let datePlayed: Date
    let pgn: String
    let timeControl: String
    let timeClass: String
    let color: String
    let result: String
    let rating: Int
    let opponentUsername: String
    let score: Double
    let wonBy: String
    
    // for SwiftData predicate
    let year: String
    let month: Int
    
    init(url: String, uuid: String, endTime: Int, datePlayed: Date, pgn: String, timeControl: String, timeClass: String, color: String, result: String, rating: Int, opponentUsername: String, wonBy: String, year: String, month: Int) {
        self.url = url
        self.uuid = uuid
        self.endTime = endTime
        self.datePlayed = datePlayed
        self.pgn = pgn
        self.timeControl = timeControl
        self.timeClass = timeClass
        self.color = color
        self.result = result
        self.rating = rating
        self.opponentUsername = opponentUsername
        self.wonBy = wonBy
        if (result == "win") {
            score = 1
        }
        else if (DRAW_RESULTS.contains(result)) {
            score = 0.5
        }
        else {
            score = 0
        }
        
        self.year = year
        self.month = month        
    }
    
    var id: String {
        uuid
    }
    
    static func == (lug: UserGame, rug: UserGame) -> Bool {
        return lug.uuid == rug.uuid
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func fromChessGame(game: Game, username: String = "issaharw") -> UserGame {
        let date = Date(timeIntervalSince1970: TimeInterval(game.endTime))
        let adjustedDate = date.adjustedForNightGames()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Jerusalem")!

        // Extract the year and month from the current date
        let year = String(calendar.component(.year, from: date))
        let month = calendar.component(.month, from: date)

        if game.white.username.lowercased() == username.lowercased() {
            return UserGame(
                url: game.url,
                uuid: game.uuid,
                endTime: game.endTime,
                datePlayed: adjustedDate,
                pgn: game.pgn,
                timeControl: game.timeControl,
                timeClass: game.timeClass,
                color: "white",
                result: game.white.result,
                rating: game.white.rating,
                opponentUsername: game.black.username,
                wonBy: game.black.result,
                year: year,
                month: month
            )
        }
        else {
            return UserGame(
                url: game.url,
                uuid: game.uuid,
                endTime: game.endTime,
                datePlayed: adjustedDate,
                pgn: game.pgn,
                timeControl: game.timeControl,
                timeClass: game.timeClass,
                color: "black",
                result: game.black.result,
                rating: game.black.rating,
                opponentUsername: game.white.username,
                wonBy: game.white.result,
                year: year,
                month: month
            )
        }
    }
}


let sampleUserGame = UserGame.fromChessGame(game: sampleGame!)
