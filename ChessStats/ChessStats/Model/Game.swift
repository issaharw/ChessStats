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
    let accuracies: Accuracies?
    let tcn: String
    let uuid: String
    let initialSetup: String
    let fen: String
    let timeClass: String
    let rules: String
    let white: Player
    let black: Player

    enum CodingKeys: String, CodingKey {
        case url, pgn, rated, tcn, uuid, fen, rules, white, black, accuracies
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

struct Accuracies: Codable {
    let white: Double
    let black: Double
}

private let sampleJson = """
{
        "url": "https://www.chess.com/game/daily/651804655",
        "pgn": "[Event \"Let's Play!\"]\n[Site \"Chess.com\"]\n[Date \"2024.04.30\"]\n[Round \"-\"]\n[White \"ARchessplaer\"]\n[Black \"Issaharw\"]\n[Result \"0-1\"]\n[CurrentPosition \"8/8/8/1p6/1P1K3p/5k1P/2p5/8 w - - 0 49\"]\n[Timezone \"UTC\"]\n[ECO \"C23\"]\n[ECOUrl \"https://www.chess.com/openings/Bishops-Opening-2...Nc6\"]\n[UTCDate \"2024.04.30\"]\n[UTCTime \"14:12:07\"]\n[WhiteElo \"867\"]\n[BlackElo \"1140\"]\n[TimeControl \"1/259200\"]\n[Termination \"Issaharw won by resignation\"]\n[StartTime \"14:12:07\"]\n[EndDate \"2024.05.01\"]\n[EndTime \"11:15:34\"]\n[Link \"https://www.chess.com/game/daily/651804655\"]\n\n1. e4 {[%clk 68:13:14]} 1... e5 {[%clk 71:32:39]} 2. Bc4 {[%clk 71:36:54]} 2... Nc6 {[%clk 71:50:52]} 3. a3 {[%clk 71:57:52]} 3... d6 {[%clk 71:54:07]} 4. h3 {[%clk 71:59:40]} 4... Nf6 {[%clk 71:59:44]} 5. d3 {[%clk 71:54:22]} 5... Be7 {[%clk 71:49:06]} 6. Nc3 {[%clk 71:31:45]} 6... Nd4 {[%clk 71:59:31]} 7. Nf3 {[%clk 71:58:08]} 7... c5 {[%clk 71:59:30]} 8. Nxd4 {[%clk 71:59:13]} 8... exd4 {[%clk 71:43:53]} 9. Bb5+ {[%clk 61:38:46]} 9... Bd7 {[%clk 71:47:43]} 10. Bxd7+ {[%clk 71:59:19]} 10... Qxd7 {[%clk 71:59:48]} 11. Ne2 {[%clk 71:58:10]} 11... O-O {[%clk 71:59:48]} 12. O-O {[%clk 71:51:50]} 12... d5 {[%clk 71:52:28]} 13. exd5 {[%clk 71:58:41]} 13... Qxd5 {[%clk 71:59:41]} 14. Nf4 {[%clk 71:59:26]} 14... Qe5 {[%clk 71:58:55]} 15. Re1 {[%clk 71:57:51]} 15... Qc7 {[%clk 71:57:07]} 16. c3 {[%clk 71:58:44]} 16... Rfe8 {[%clk 71:58:27]} 17. c4 {[%clk 71:57:10]} 17... Bd6 {[%clk 71:58:12]} 18. Nd5 {[%clk 71:57:35]} 18... Nxd5 {[%clk 71:59:39]} 19. cxd5 {[%clk 71:51:30]} 19... h6 {[%clk 71:59:15]} 20. Bd2 {[%clk 71:50:30]} 20... Bf4 {[%clk 71:55:57]} 21. g3 {[%clk 71:57:41]} 21... Bxd2 {[%clk 71:59:41]} 22. Qxd2 {[%clk 71:57:10]} 22... Qd6 {[%clk 71:59:28]} 23. Rxe8+ {[%clk 71:59:13]} 23... Rxe8 {[%clk 71:58:56]} 24. Re1 {[%clk 71:59:29]} 24... Rxe1+ {[%clk 71:59:51]} 25. Qxe1 {[%clk 71:59:49]} 25... Qxd5 {[%clk 71:59:49]} 26. Qe8+ {[%clk 71:59:36]} 26... Kh7 {[%clk 71:59:54]} 27. Qe4+ {[%clk 71:56:30]} 27... Qxe4 {[%clk 71:59:37]} 28. dxe4 {[%clk 71:49:07]} 28... Kg6 {[%clk 71:54:48]} 29. Kf1 {[%clk 71:57:13]} 29... Kf6 {[%clk 71:59:39]} 30. Ke2 {[%clk 71:57:49]} 30... Ke5 {[%clk 71:59:02]} 31. f3 {[%clk 71:59:27]} 31... c4 {[%clk 71:59:45]} 32. Kd2 {[%clk 71:44:28]} 32... f5 {[%clk 71:53:44]} 33. exf5 {[%clk 71:59:20]} 33... Kxf5 {[%clk 71:45:32]} 34. Kc2 {[%clk 71:48:49]} 34... Ke5 {[%clk 71:59:34]} 35. b3 {[%clk 71:44:46]} 35... c3 {[%clk 71:59:31]} 36. Kd3 {[%clk 71:58:58]} 36... Kd5 {[%clk 71:59:46]} 37. Kc2 {[%clk 71:39:09]} 37... b5 {[%clk 71:58:41]} 38. Kd3 {[%clk 71:58:26]} 38... a5 {[%clk 71:59:19]} 39. b4 {[%clk 71:56:12]} 39... axb4 {[%clk 71:59:17]} 40. axb4 {[%clk 71:56:23]} 40... Ke5 {[%clk 71:59:09]} 41. Kc2 {[%clk 71:56:47]} 41... g5 {[%clk 71:48:20]} 42. Kd3 {[%clk 71:44:57]} 42... h5 {[%clk 71:56:09]} 43. Kc2 {[%clk 71:51:55]} 43... h4 {[%clk 71:59:43]} 44. gxh4 {[%clk 71:51:20]} 44... gxh4 {[%clk 71:59:39]} 45. Kd3 {[%clk 71:59:40]} 45... Kf4 {[%clk 71:59:23]} 46. Ke2 {[%clk 71:59:26]} 46... Kg3 {[%clk 71:59:17]} 47. Kd3 {[%clk 71:59:25]} 47... Kxf3 {[%clk 71:59:53]} 48. Kxd4 {[%clk 71:56:50]} 48... c2 {[%clk 71:59:50]} 0-1\n",
        "time_control": "1/259200",
        "end_time": 1714562134,
        "rated": true,
        "accuracies": {
            "white": 79.68,
            "black": 87.77
        },
        "tcn": "mC0KfA5QiqZRpx!Tlt90bsQBgvYIvBKBAH6ZHZ7Zsm8?ehRJCJZJmDJKfeKYks98sA0RDJTJAJ3VclRDowDldlYRe848ae8eleRJe8!38CJCtC3UgfUTfmTKnvIAml1LCLKLlkLKjrAsktKJtkXHktWGrzGzqzJKtk2MktVNtkNFwFMFktKDtmDwmtwvtBsk",
        "uuid": "a103b71a-06fb-11ef-a0fe-c7475b01000b",
        "initial_setup": "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1",
        "fen": "8/8/8/1p6/1P1K3p/5k1P/2p5/8 w - - 0 49",
        "start_time": 1714486327,
        "time_class": "daily",
        "rules": "chess",
        "white": {
            "rating": 867,
            "result": "resigned",
            "@id": "https://api.chess.com/pub/player/archessplaer",
            "username": "ARchessplaer",
            "uuid": "f5d1a83c-14c7-11ee-90a8-8ff3b0e759f5"
        },
        "black": {
            "rating": 1140,
            "result": "win",
            "@id": "https://api.chess.com/pub/player/issaharw",
            "username": "Issaharw",
            "uuid": "f5fb52f0-5560-11eb-afff-676dabd8a6af"
        }
    }
""".data(using: .utf8)!

let sampleGame = parseGameJson(json: sampleJson)

private func parseGameJson(json: Data) -> Game? {
    let decoder = JSONDecoder()
    do {
        return try decoder.decode(Game.self, from: json)
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
}

