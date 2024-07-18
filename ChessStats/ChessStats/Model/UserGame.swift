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
    let accuracy: Double?
    
    // for SwiftData predicate
    let year: String
    let month: Int
    
    init(url: String, uuid: String, endTime: Int, datePlayed: Date, pgn: String, timeControl: String, timeClass: String, color: String, result: String, rating: Int, opponentUsername: String, wonBy: String, score: Double, accuracy: Double?, year: String, month: Int) {
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
        self.score = score
        self.accuracy = accuracy
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
    
    static func fromChessComGame(game: ChessComGame, username: String = "issaharw") -> UserGame {
        let date = Date(timeIntervalSince1970: TimeInterval(game.endTime))
        let adjustedDate = date.adjustedForNightGames()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Jerusalem")!

        // Extract the year and month from the current date
        let year = String(calendar.component(.year, from: date))
        let month = calendar.component(.month, from: date)

        // starting with white. will change for black
        var color = "white"
        var result =  game.white.result
        var rating = game.white.rating
        var opponentUsername = game.black.username
        var wonBy = game.black.result
        var accuracy = game.accuracies?.white
        
        if (game.black.username.lowercased() == username.lowercased()) {
            color = "black"
            result =  game.black.result
            rating = game.black.rating
            opponentUsername = game.white.username
            wonBy = game.white.result
            accuracy = game.accuracies?.black
        }
        var score = 0.0
        if (result == "win") {
            score = 1
        }
        else if (DRAW_RESULTS.contains(result)) {
            score = 0.5
        }

        return UserGame(
            url: game.url,
            uuid: game.uuid,
            endTime: game.endTime,
            datePlayed: adjustedDate,
            pgn: game.pgn,
            timeControl: game.timeControl,
            timeClass: game.timeClass,
            color: color,
            result: result,
            rating: rating,
            opponentUsername: opponentUsername,
            wonBy: wonBy,
            score: score,
            accuracy: accuracy,
            year: year,
            month: month
        )
    }
    
    static func fromLichessGame(game: LichessGame, username: String = "issaharw") -> UserGame {
        let endTime = game.lastMoveAt/1000
        let date = Date(timeIntervalSince1970: TimeInterval(endTime))
        let adjustedDate = date.adjustedForNightGames()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Jerusalem")!

        // Extract the year and month from the current date
        let year = String(calendar.component(.year, from: date))
        let month = calendar.component(.month, from: date)

        // starting with white. will change for black
        var color = "white"
        var rating = game.players.white.rating + game.players.white.ratingDiff
        var opponentUsername = game.players.black.user.id
        var accuracy = game.players.white.analysis?.accuracy ?? 0
        
        if (game.players.black.user.id.lowercased() == username.lowercased()) {
            color = "black"
            rating = game.players.black.rating + game.players.black.ratingDiff
            opponentUsername = game.players.white.user.id
            accuracy = game.players.black.analysis?.accuracy ?? 0
        }

        var result = ""
        var score = 0.0
        if (game.winner == nil) {
            result = game.status
            score = 0.5
        }
        else if (game.winner == "white" && game.players.white.user.id.lowercased() == username.lowercased() ||
                 game.winner == "black" && game.players.black.user.id.lowercased() == username.lowercased()) {
            result = "win"
            score = 1
        }
        else {
            result = game.status
            score = 0
        }

        return UserGame(
            url: "http://lichess.org/\(game.fullId)",
            uuid: game.fullId,
            endTime: endTime,
            datePlayed: adjustedDate,
            pgn: game.pgn,
            timeControl: String(game.clock?.initial ?? 0) + "|" + String(game.clock?.increment ?? 0),
            timeClass: "li\(game.speed)",
            color: color,
            result: result,
            rating: rating,
            opponentUsername: opponentUsername,
            wonBy: game.status,
            score: score,
            accuracy: accuracy,
            year: year,
            month: month
        )
    }
}


let sampleUserGame = UserGame.fromChessComGame(game: sampleGame!)
let sampleLichessUserGame = UserGame.fromLichessGame(game: sampleLichessGame!)
