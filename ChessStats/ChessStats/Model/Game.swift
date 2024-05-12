//
//  Game.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation

struct Games: Codable {
    let games: [Game]
}

// Main structure for the Chess game
struct Game: Codable, Identifiable{
    let url: String
    let pgn: String
    let timeControl: String
    let endTime: Int
    let rated: Bool
    let tcn: String
    let uuid: String
    let initialSetup: String
    let fen: String
    let timeClass: String
    let rules: String
    let white: Player
    let black: Player

    enum CodingKeys: String, CodingKey {
        case url, pgn, rated, tcn, uuid, fen, rules, white, black
        case timeControl = "time_control"
        case endTime = "end_time"
        case initialSetup = "initial_setup"
        case timeClass = "time_class"
    }
    
    var id: String {
        url
    }
}

// Define structures for nested objects (players)
struct Player: Codable {
    let rating: Int
    let result: String
    let id: URL
    let username: String
    let uuid: String

    enum CodingKeys: String, CodingKey {
        case rating, result, username, uuid
        case id = "@id"
    }
}
