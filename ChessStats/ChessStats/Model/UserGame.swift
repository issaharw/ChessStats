//
//  UserGame.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation
import SwiftData


@Model
struct UserGame: Identifiable {
    let url: String
    let endTime: Int
    let pgn: String
    let timeControl: String
    let timeClass: String
    let color: String
    let result: String
    let rating: Int
    let opponentUsername: String
    
    init(url: String, endTime: Int, pgn: String, timeControl: String, timeClass: String, color: String, result: String, rating: Int, opponentUsername: String) {
        self.url = url
        self.endTime = endTime
        self.pgn = pgn
        self.timeControl = timeControl
        self.timeClass = timeClass
        self.color = color
        self.result = result
        self.rating = rating
        self.opponentUsername = opponentUsername
    }
    
    var id: String {
        url
    }
    
    static func fromChessGame(game: Game, username: String = "issaharw") -> UserGame {
        if game.white.username.lowercased() == username.lowercased() {
            return UserGame(
                url: game.url,
                endTime: game.endTime,
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


