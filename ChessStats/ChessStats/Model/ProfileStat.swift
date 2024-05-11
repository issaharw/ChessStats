//
//  ProfileStat.swift
//  ChessStats
//
//  Created by Issahar Weiss on 11/05/2024.
//

import Foundation

struct ProfileStat: Codable {
    let daily: ChessModeStats
    let rapid: ChessModeStats
    let bullet: ChessModeStats
    let blitz: ChessModeStats

    enum CodingKeys: String, CodingKey {
        case daily = "chess_daily"
        case rapid = "chess_rapid"
        case bullet = "chess_bullet"
        case blitz = "chess_blitz"
    }
}

struct ChessModeStats: Codable {
    let last: ChessGameStats
    let best: ChessBestGameStats
    let record: ChessRecord
}

struct ChessGameStats: Codable {
    let rating: Int
    let date: Int
    let rd: Int?
}

struct ChessBestGameStats: Codable {
    let rating: Int
    let date: Int
    let game: URL
}

struct ChessRecord: Codable {
    let win, loss, draw: Int
    let timePerMove: Int?
    let timeoutPercent: Double?

    enum CodingKeys: String, CodingKey {
        case win, loss, draw
        case timePerMove = "time_per_move"
        case timeoutPercent = "timeout_percent"
    }
}


// Example of decoding from JSON string:
let profileStatJson = """
{
    "chess_daily": {
        "last": {
            "rating": 1157,
            "date": 1715447742,
            "rd": 99
        },
        "best": {
            "rating": 1286,
            "date": 1702757199,
            "game": "https://www.chess.com/game/daily/607921307"
        },
        "record": {
            "win": 11,
            "loss": 6,
            "draw": 0,
            "time_per_move": 3641,
            "timeout_percent": 0
        }
    },
    "chess_rapid": {
        "last": {
            "rating": 1241,
            "date": 1715346214,
            "rd": 32
        },
        "best": {
            "rating": 1345,
            "date": 1695738695,
            "game": "https://www.chess.com/game/live/105306016771"
        },
        "record": {
            "win": 485,
            "loss": 454,
            "draw": 50
        }
    },
    "chess_bullet": {
        "last": {
            "rating": 929,
            "date": 1715449826,
            "rd": 20
        },
        "best": {
            "rating": 938,
            "date": 1715449540,
            "game": "https://www.chess.com/game/live/102114999869"
        },
        "record": {
            "win": 822,
            "loss": 799,
            "draw": 47
        }
    },
    "chess_blitz": {
        "last": {
            "rating": 1134,
            "date": 1715340915,
            "rd": 23
        },
        "best": {
            "rating": 1134,
            "date": 1715340915,
            "game": "https://www.chess.com/game/live/106571186187"
        },
        "record": {
            "win": 1409,
            "loss": 1347,
            "draw": 94
        }
    },
    "fide": 0,
    "tactics": {
        "highest": {
            "rating": 1900,
            "date": 1711541353
        },
        "lowest": {
            "rating": 800,
            "date": 1610516049
        }
    },
    "puzzle_rush": {}
}
"""

let sampleProfileStat = parseProfileStat(from: parseExampleJson(json: profileStatJson))

func parseExampleJson(json: String) -> [String: Any]{
    if let jsonData = json.data(using: .utf8) {
        do {
            if let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                return dictionary
            } else {
                print("Could not cast JSON content as [String: Any]")
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
    return [:]
}

func parseProfileStat(from json: [String: Any]) -> ProfileStat? {
    do {
        let data = try JSONSerialization.data(withJSONObject: json)
        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(ProfileStat.self, from: data)
    } catch {
        print("Error decoding JSON: \(error)")
        return nil
    }
}
