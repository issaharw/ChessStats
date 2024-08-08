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
    let libullet: TimeClassStats
    let liblitz: TimeClassStats
    
    init(dateFetched: Date, daily: TimeClassStats, rapid: TimeClassStats, bullet: TimeClassStats, blitz: TimeClassStats, libullet: TimeClassStats, liblitz: TimeClassStats) {
        self.dateFetched = dateFetched
        self.daily = daily
        self.rapid = rapid
        self.bullet = bullet
        self.blitz = blitz
        self.libullet = libullet
        self.liblitz = liblitz
    }
    
    convenience init(from: ProfileStatRecord, libullet: LichessTimeClassStats, liblitz: LichessTimeClassStats, dateFetched: Date = Date()) {
        self.init(dateFetched: dateFetched, daily: TimeClassStats(from: from.daily, timeClass: "daily"),
                                            rapid: TimeClassStats(from: from.rapid, timeClass: "rapid"),
                                            bullet: TimeClassStats(from: from.bullet, timeClass: "bullet"),
                                            blitz: TimeClassStats(from: from.blitz, timeClass: "blitz"),
                                            libullet: TimeClassStats(from: libullet, timeClass: "libullet"),
                                            liblitz: TimeClassStats(from: liblitz, timeClass: "liblitz"))
    }
    
    var id: Date {
        dateFetched
    }
    
    func getStat(for type: String) -> TimeClassStats? {
        switch type {
        case "bullet": return bullet
        case "blitz": return blitz
        case "libullet": return libullet
        case "liblitz": return liblitz
        case "rapid": return rapid
        case "daily": return daily
        default: return nil
        }
    }
}

@Model
class TimeClassStats: Identifiable {
    let timeClass: String
    let current: Int
    let best: Int
    
    init(timeClass: String, current: Int, best: Int) {
        self.timeClass = timeClass
        self.current = current
        self.best = best
    }
    
    convenience init(from: ChessModeStats, timeClass: String) {
        self.init(timeClass: timeClass, current: from.last.rating, best: from.best.rating)
    }
    
    convenience init(from: LichessTimeClassStats, timeClass: String) {
        self.init(timeClass: timeClass, current: Int(from.perf.glicko.rating), best: from.stat.highest.int)
    }
    
    var id: String {
        timeClass
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
}

struct ChessGameStats: Codable {
    let rating: Int
    let date: Int
}


// ------------------------------ LICHESS Objects -------------------------------
struct LichessTimeClassStats: Codable {
    let perf: Perf
    let stat: Stat
}

struct Perf: Codable {
    let glicko: Glicko
}
struct Glicko: Codable {
    let rating: Double
}

struct Stat: Codable {
    let highest: Highest
}
struct Highest: Codable {
    let int: Int
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

let lichessPerfJson = """
{
    "user": {
        "name": "issaharw"
    },
    "perf": {
        "glicko": {
            "rating": 1232.5,
            "deviation": 45.07
        },
        "nb": 370,
        "progress": 7
    },
    "rank": 226284,
    "percentile": 25.1,
    "stat": {
        "count": {
            "berserk": 0,
            "win": 181,
            "all": 370,
            "seconds": 89298,
            "opAvg": 1186.79,
            "draw": 16,
            "tour": 0,
            "disconnects": 0,
            "rated": 370,
            "loss": 173
        },
        "resultStreak": {
            "win": {
                "cur": {
                    "v": 0
                },
                "max": {
                    "v": 7,
                    "from": {
                        "at": "2024-06-30T16:48:56.869Z",
                        "gameId": "FAPYV0bo"
                    },
                    "to": {
                        "at": "2024-06-30T18:00:42.748Z",
                        "gameId": "eSJSJCwk"
                    }
                }
            },
            "loss": {
                "cur": {
                    "v": 2,
                    "from": {
                        "at": "2024-07-19T05:06:49.2Z",
                        "gameId": "d902wQTX"
                    },
                    "to": {
                        "at": "2024-07-19T05:15:30.515Z",
                        "gameId": "8mfJiz00"
                    }
                },
                "max": {
                    "v": 6,
                    "from": {
                        "at": "2024-07-04T12:21:54.117Z",
                        "gameId": "sutECy2M"
                    },
                    "to": {
                        "at": "2024-07-04T15:19:06.353Z",
                        "gameId": "dharDsKY"
                    }
                }
            }
        },
        "lowest": {
            "int": 1086,
            "at": "2024-05-30T11:09:11.349Z",
            "gameId": "PfbXWf4r"
        },
        "worstLosses": {
            "results": [
                {
                    "opRating": 1048,
                    "opId": {
                        "id": "khatri_chirag_313",
                        "name": "Khatri_Chirag_313",
                        "title": null
                    },
                    "at": "2024-05-31T13:01:41.098Z",
                    "gameId": "UGh0hzK7"
                },
                {
                    "opRating": 1051,
                    "opId": {
                        "id": "mujere-1992",
                        "name": "Mujere-1992",
                        "title": null
                    },
                    "at": "2024-06-11T14:09:41.655Z",
                    "gameId": "otJ7DeEi"
                },
                {
                    "opRating": 1069,
                    "opId": {
                        "id": "tateh",
                        "name": "TateH",
                        "title": null
                    },
                    "at": "2024-06-11T11:32:39.417Z",
                    "gameId": "nHdqAR7M"
                },
                {
                    "opRating": 1075,
                    "opId": {
                        "id": "krish8617",
                        "name": "krish8617",
                        "title": null
                    },
                    "at": "2024-05-30T11:09:11.349Z",
                    "gameId": "PfbXWf4r"
                },
                {
                    "opRating": 1086,
                    "opId": {
                        "id": "kopejsk",
                        "name": "Kopejsk",
                        "title": null
                    },
                    "at": "2024-06-07T05:16:18.986Z",
                    "gameId": "bsuXzE8C"
                }
            ]
        },
        "perfType": {
            "key": "bullet",
            "name": "Bullet"
        },
        "id": "issaharw/1",
        "bestWins": {
            "results": [
                {
                    "opRating": 1333,
                    "opId": {
                        "id": "sujayjaju",
                        "name": "SujayJaju",
                        "title": null
                    },
                    "at": "2024-06-16T05:45:02.567Z",
                    "gameId": "EsFW31j1"
                },
                {
                    "opRating": 1321,
                    "opId": {
                        "id": "alexisj0509",
                        "name": "Alexisj0509",
                        "title": null
                    },
                    "at": "2024-07-12T13:43:16.524Z",
                    "gameId": "3Xxtkr1D"
                },
                {
                    "opRating": 1313,
                    "opId": {
                        "id": "spellord",
                        "name": "Spellord",
                        "title": null
                    },
                    "at": "2024-02-04T02:01:09.418Z",
                    "gameId": "gVWsajYw"
                },
                {
                    "opRating": 1287,
                    "opId": {
                        "id": "nando144",
                        "name": "Nando144",
                        "title": null
                    },
                    "at": "2024-02-08T22:55:28.935Z",
                    "gameId": "Hs5eV8IM"
                },
                {
                    "opRating": 1280,
                    "opId": {
                        "id": "maeitze",
                        "name": "maeitze",
                        "title": null
                    },
                    "at": "2024-07-04T11:14:45.67Z",
                    "gameId": "qyINGZPs"
                }
            ]
        },
        "userId": {
            "id": "issaharw",
            "name": "issaharw",
            "title": null
        },
        "playStreak": {
            "nb": {
                "cur": {
                    "v": 0
                },
                "max": {
                    "v": 65,
                    "from": {
                        "at": "2024-06-11T09:28:30.965Z",
                        "gameId": "aWlAWJzn"
                    },
                    "to": {
                        "at": "2024-06-11T16:09:59.437Z",
                        "gameId": "HW19HYsm"
                    }
                }
            },
            "time": {
                "cur": {
                    "v": 0
                },
                "max": {
                    "v": 15205,
                    "from": {
                        "at": "2024-06-11T09:28:30.965Z",
                        "gameId": "aWlAWJzn"
                    },
                    "to": {
                        "at": "2024-06-11T16:09:59.437Z",
                        "gameId": "HW19HYsm"
                    }
                }
            },
            "lastDate": "2024-07-19T05:15:30.515Z"
        },
        "highest": {
            "int": 1243,
            "at": "2024-07-19T05:06:38.837Z",
            "gameId": "yOvk5esT"
        }
    }
}
""".data(using: .utf8)!

let sampleProfileStat = parseExampleJson(json: profileStatJson, lichessJson: lichessPerfJson)!

func parseExampleJson(json: Data, lichessJson: Data) -> ProfileStat? {
    let decoder = JSONDecoder()
    do {
        let stat = try decoder.decode(ProfileStatRecord.self, from: json)
        let lichessStat = try decoder.decode(LichessTimeClassStats.self, from: lichessJson)
        return ProfileStat(from: stat, libullet: lichessStat, liblitz: lichessStat)
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
}
