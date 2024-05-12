//
//  ProfileStat.swift
//  ChessStats
//
//  Created by Issahar Weiss on 11/05/2024.
//

import Foundation
import SwiftData

@Model
class ProfileStat: Identifiable {
    let dateFetched: Date
    let daily: TimeClassStats
    let rapid: TimeClassStats
    let bullet: TimeClassStats
    let blitz: TimeClassStats
    
    init(dateFetched: Date, daily: TimeClassStats, rapid: TimeClassStats, bullet: TimeClassStats, blitz: TimeClassStats) {
        self.dateFetched = dateFetched
        self.daily = daily
        self.rapid = rapid
        self.bullet = bullet
        self.blitz = blitz
    }
    
    convenience init(from: ProfileStatRecord, dateFetched: Date = Date()) {
        self.init(dateFetched: dateFetched, daily: TimeClassStats(from: from.daily, timeClass: "daily"),
                                            rapid: TimeClassStats(from: from.rapid, timeClass: "rapid"),
                                            bullet: TimeClassStats(from: from.bullet, timeClass: "bullet"),
                                            blitz: TimeClassStats(from: from.blitz, timeClass: "blitz"))
    }
    
    var id: Date {
        dateFetched
    }
}

@Model
class TimeClassStats: Identifiable {
    let timeClass: String
    let last: RatingStats
    let best: RatingStats
    let record: TimeClassRecord
    
    init(timeClass: String, last: RatingStats, best: RatingStats, record: TimeClassRecord) {
        self.timeClass = timeClass
        self.last = last
        self.best = best
        self.record = record
    }
    
    convenience init(from: ChessModeStats, timeClass: String) {
        self.init(timeClass: timeClass, last: RatingStats(from: from.last), best: RatingStats(from: from.best), record: TimeClassRecord(from: from.record))
    }
    
    var id: String {
        timeClass
    }
}

@Model
class RatingStats: Identifiable {
    let rating: Int
    let date: Int
    
    init(rating: Int, date: Int) {
        self.rating = rating
        self.date = date
    }
    
    convenience init(from: ChessGameStats) {
        self.init(rating: from.rating, date: from.date)
    }
    
    var id: String {
        "\(date) - \(rating)"
    }
}

@Model
class TimeClassRecord {
    let win: Int
    let loss: Int
    let draw: Int
    let timePerMove: Int?
    let timeoutPercent: Double?

    init(win: Int, loss: Int, draw: Int, timePerMove: Int?, timeoutPercent: Double?) {
        self.win = win
        self.loss = loss
        self.draw = draw
        self.timePerMove = timePerMove
        self.timeoutPercent = timeoutPercent
    }

    convenience init(from: ChessRecord) {
        self.init(win: from.win, loss: from.loss, draw: from.draw, timePerMove: from.timePerMove, timeoutPercent: from.timeoutPercent)
    }
}




struct ProfileStatRecord: Codable {
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
    let best: ChessGameStats
    let record: ChessRecord
}

struct ChessGameStats: Codable {
    let rating: Int
    let date: Int
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
""".data(using: .utf8)!

let sampleProfileStat = parseExampleJson(json: profileStatJson)!

func parseExampleJson(json: Data) -> ProfileStat? {
    let decoder = JSONDecoder()
    do {
        let stat = try decoder.decode(ProfileStatRecord.self, from: json)
        return ProfileStat(from: stat)
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
}
