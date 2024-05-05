//
//  Game.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation

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
        case url, pgn, rated, tcn, uuid, fen, rules, white, black, timeControl, endTime, initialSetup, timeClass
    }
    
    var id: String {
        url
    }
}

// Function to parse JSON dictionary into ChessGame
func parseGame(from dictionary: [String: Any]) -> Game? {
    do {
        let data = try JSONSerialization.data(withJSONObject: dictionary)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Game.self, from: data)
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}

func parseGames(from jsonArray: [[String: Any]]) -> [Game] {
    var chessGames: [Game] = []
    
    for jsonDict in jsonArray {
        if let chessGame = parseGame(from: jsonDict) {
            chessGames.append(chessGame)
        } else {
            print("Error parsing one of the games.")
        }
    }
    
    return chessGames
}
