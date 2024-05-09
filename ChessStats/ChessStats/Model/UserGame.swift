//
//  UserGame.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation

let DRAW_RESULTS = ["agreed", "repetition", "stalemate", "insufficient", "50move", "timevsinsufficient"]


struct UserGame: Identifiable {
    let url: String
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
    
    init(url: String, endTime: Int, datePlayed: Date, pgn: String, timeControl: String, timeClass: String, color: String, result: String, rating: Int, opponentUsername: String) {
        self.url = url
        self.endTime = endTime
        self.datePlayed = datePlayed
        self.pgn = pgn
        self.timeControl = timeControl
        self.timeClass = timeClass
        self.color = color
        self.result = result
        self.rating = rating
        self.opponentUsername = opponentUsername
        if (result == "win") {
            score = 1
        }
        else if (DRAW_RESULTS.contains(result)) {
            score = 0.5
        }
        else {
            score = 0
        }
    }
    
    var id: String {
        url
    }
    
    static func fromChessGame(game: Game, username: String = "issaharw") -> UserGame {
        let date = Date(timeIntervalSince1970: TimeInterval(game.endTime))
        let adjustedDate = date.adjustedForNightGames()

        if game.white.username.lowercased() == username.lowercased() {
            return UserGame(
                url: game.url,
                endTime: game.endTime,
                datePlayed: adjustedDate,
                pgn: game.pgn,
                timeControl: game.timeControl,
                timeClass: game.timeClass,
                color: "white",
                result: game.white.result,
                rating: game.white.rating,
                opponentUsername: game.black.username
            )
        }
        else {
            return UserGame(
                url: game.url,
                endTime: game.endTime,
                datePlayed: adjustedDate,
                pgn: game.pgn,
                timeControl: game.timeControl,
                timeClass: game.timeClass,
                color: "black",
                result: game.black.result,
                rating: game.black.rating,
                opponentUsername: game.white.username
            )
        }
    }
}


