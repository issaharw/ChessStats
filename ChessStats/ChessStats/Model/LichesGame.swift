//
//  LichesGame.swift
//  ChessStats
//
//  Created by Issahar Weiss on 13/06/2024.
//

import Foundation

struct LichessGame: Codable {
    let id: String
    let rated: Bool
    let variant: String
    let speed: String
    let perf: String
    let createdAt: Int
    let lastMoveAt: Int
    let status: String
    let source: String
    let players: Players
    let fullId: String
    let winner: String?
    let moves: String
    let pgn: String
    let clock: Clock?
}

struct Players: Codable {
    let white: LichessPlayer
    let black: LichessPlayer
}

struct LichessPlayer: Codable {
    let user: User
    let rating: Int
    let ratingDiff: Int
    let analysis: Analysis?
}

struct User: Codable {
    let name: String
    let id: String
}

struct Analysis: Codable {
    let inaccuracy: Int
    let mistake: Int
    let blunder: Int
    let acpl: Int
    let accuracy: Double
}

struct Clock: Codable {
    let initial: Int
    let increment: Int
    let totalTime: Int
}

let jsonData = """
{
    "id": "zNropBM4",
    "rated": true,
    "variant": "standard",
    "speed": "blitz",
    "perf": "blitz",
    "createdAt": 1718245873007,
    "lastMoveAt": 1718246470950,
    "status": "resign",
    "source": "pool",
    "players": {
        "white": {
            "user": {
                "name": "vvttpl",
                "id": "vvttpl"
            },
            "rating": 1402,
            "ratingDiff": 5,
            "analysis": {
                "inaccuracy": 3,
                "mistake": 3,
                "blunder": 3,
                "acpl": 55,
                "accuracy": 85
            }
        },
        "black": {
            "user": {
                "name": "issaharw",
                "id": "issaharw"
            },
            "rating": 1369,
            "ratingDiff": -5,
            "analysis": {
                "inaccuracy": 6,
                "mistake": 6,
                "blunder": 4,
                "acpl": 80,
                "accuracy": 82
            }
        }
    },
    "fullId": "zNropBM4Qviy",
    "winner": "white",
    "moves": "e4 e5 Nf3 Nc6 d4 exd4 c3 dxc3 Nxc3 Nf6 e5 Ng8 Bc4 d6 Qb3 Qe7 O-O dxe5 Re1 Be6 Bxe6 fxe6 Nxe5 Nxe5 Rxe5 O-O-O Bg5 Nf6 Qxe6+ Qxe6 Rxe6 Bd6 Nb5 Rhf8 Nxa7+ Kb8 Nb5 h6 Be3 Nd5 Nxd6 Rxd6 Rxd6 cxd6 Bd4 Rc8 b3 Nb4 Bxg7 h5 h4 d5 g3 Nd3 Rd1 Nb4 Be5+ Ka8 f4 Nxa2 Rxd5 Nb4 Rd4 Nc2 Rc4 Rc6 Rxc6 bxc6 f5 Ne3 f6 Ng4 Bc3 Nxf6 Bxf6 Kb7 Kf2 Kb6 Ke3 Kb5 Kd3 Kb4 Kc2 c5 Be7 Kb5 Kc3 Kc6 Kc4 Kd7 Bxc5 Ke6 b4 Kf5 b5 Kg4 Bd6 Kh3 b6 Kg4 b7 Kh3 b8=Q Kg4 Qc8+ Kf3 Qf8+",
    "clocks": [
        30003,
        30003,
        30203,
        30187,
        30323,
        30339,
        30571,
        30523,
        30827,
        30659,
        30819,
        30475,
        30963,
        30635,
        30811,
        30027,
        30819,
        30131,
        26755,
        30059,
        26587,
        30227,
        25875,
        30251,
        26027,
        30179,
        25531,
        30187,
        21419,
        29811,
        21611,
        29107,
        20883,
        28763,
        19027,
        28403,
        18347,
        28019,
        15579,
        26411,
        14347,
        25939,
        14243,
        25347,
        14347,
        23379,
        13403,
        23491,
        13243,
        23019,
        13195,
        22619,
        12835,
        21739,
        12299,
        21515,
        11995,
        21307,
        12091,
        21259,
        11931,
        21235,
        10155,
        21355,
        9939,
        20275,
        10003,
        20459,
        10075,
        20611,
        10107,
        20787,
        9595,
        20779,
        9715,
        20963,
        9883,
        21139,
        10099,
        21339,
        9691,
        21491,
        9907,
        21371,
        10075,
        21483,
        10235,
        21387,
        10411,
        21563,
        10547,
        21763,
        10691,
        21995,
        10699,
        21819,
        10787,
        20955,
        10971,
        21139,
        11123,
        21331,
        11243,
        21499,
        11411,
        21667,
        11507,
        20254
    ],
    "pgn": "[Event \"Rated blitz game\"]\n[Site \"https://lichess.org/zNropBM4\"]\n[Date \"2024.06.13\"]\n[White \"vvttpl\"]\n[Black \"issaharw\"]\n[Result \"1-0\"]\n[UTCDate \"2024.06.13\"]\n[UTCTime \"02:31:13\"]\n[WhiteElo \"1402\"]\n[BlackElo \"1369\"]\n[WhiteRatingDiff \"+5\"]\n[BlackRatingDiff \"-5\"]\n[Variant \"Standard\"]\n[TimeControl \"300+3\"]\n[ECO \"C44\"]\n[Termination \"Normal\"]\n\n1. e4 { [%clk 0:05:00] } 1... e5 { [%clk 0:05:00] } 2. Nf3 { [%clk 0:05:02] } 2... Nc6 { [%clk 0:05:02] } 3. d4 { [%clk 0:05:03] } 3... exd4 { [%clk 0:05:03] } 4. c3 { [%clk 0:05:06] } 4... dxc3 { [%clk 0:05:05] } 5. Nxc3 { [%clk 0:05:08] } 5... Nf6 { [%clk 0:05:07] } 6. e5 { [%clk 0:05:08] } 6... Ng8 { [%clk 0:05:05] } 7. Bc4 { [%clk 0:05:10] } 7... d6 { [%clk 0:05:06] } 8. Qb3 { [%clk 0:05:08] } 8... Qe7 { [%clk 0:05:00] } 9. O-O { [%clk 0:05:08] } 9... dxe5 { [%clk 0:05:01] } 10. Re1 { [%clk 0:04:28] } 10... Be6 { [%clk 0:05:01] } 11. Bxe6 { [%clk 0:04:26] } 11... fxe6 { [%clk 0:05:02] } 12. Nxe5 { [%clk 0:04:19] } 12... Nxe5 { [%clk 0:05:03] } 13. Rxe5 { [%clk 0:04:20] } 13... O-O-O { [%clk 0:05:02] } 14. Bg5 { [%clk 0:04:15] } 14... Nf6 { [%clk 0:05:02] } 15. Qxe6+ { [%clk 0:03:34] } 15... Qxe6 { [%clk 0:04:58] } 16. Rxe6 { [%clk 0:03:36] } 16... Bd6 { [%clk 0:04:51] } 17. Nb5 { [%clk 0:03:29] } 17... Rhf8 { [%clk 0:04:48] } 18. Nxa7+ { [%clk 0:03:10] } 18... Kb8 { [%clk 0:04:44] } 19. Nb5 { [%clk 0:03:03] } 19... h6 { [%clk 0:04:40] } 20. Be3 { [%clk 0:02:36] } 20... Nd5 { [%clk 0:04:24] } 21. Nxd6 { [%clk 0:02:23] } 21... Rxd6 { [%clk 0:04:19] } 22. Rxd6 { [%clk 0:02:22] } 22... cxd6 { [%clk 0:04:13] } 23. Bd4 { [%clk 0:02:23] } 23... Rc8 { [%clk 0:03:54] } 24. b3 { [%clk 0:02:14] } 24... Nb4 { [%clk 0:03:55] } 25. Bxg7 { [%clk 0:02:12] } 25... h5 { [%clk 0:03:50] } 26. h4 { [%clk 0:02:12] } 26... d5 { [%clk 0:03:46] } 27. g3 { [%clk 0:02:08] } 27... Nd3 { [%clk 0:03:37] } 28. Rd1 { [%clk 0:02:03] } 28... Nb4 { [%clk 0:03:35] } 29. Be5+ { [%clk 0:02:00] } 29... Ka8 { [%clk 0:03:33] } 30. f4 { [%clk 0:02:01] } 30... Nxa2 { [%clk 0:03:33] } 31. Rxd5 { [%clk 0:01:59] } 31... Nb4 { [%clk 0:03:32] } 32. Rd4 { [%clk 0:01:42] } 32... Nc2 { [%clk 0:03:34] } 33. Rc4 { [%clk 0:01:39] } 33... Rc6 { [%clk 0:03:23] } 34. Rxc6 { [%clk 0:01:40] } 34... bxc6 { [%clk 0:03:25] } 35. f5 { [%clk 0:01:41] } 35... Ne3 { [%clk 0:03:26] } 36. f6 { [%clk 0:01:41] } 36... Ng4 { [%clk 0:03:28] } 37. Bc3 { [%clk 0:01:36] } 37... Nxf6 { [%clk 0:03:28] } 38. Bxf6 { [%clk 0:01:37] } 38... Kb7 { [%clk 0:03:30] } 39. Kf2 { [%clk 0:01:39] } 39... Kb6 { [%clk 0:03:31] } 40. Ke3 { [%clk 0:01:41] } 40... Kb5 { [%clk 0:03:33] } 41. Kd3 { [%clk 0:01:37] } 41... Kb4 { [%clk 0:03:35] } 42. Kc2 { [%clk 0:01:39] } 42... c5 { [%clk 0:03:34] } 43. Be7 { [%clk 0:01:41] } 43... Kb5 { [%clk 0:03:35] } 44. Kc3 { [%clk 0:01:42] } 44... Kc6 { [%clk 0:03:34] } 45. Kc4 { [%clk 0:01:44] } 45... Kd7 { [%clk 0:03:36] } 46. Bxc5 { [%clk 0:01:45] } 46... Ke6 { [%clk 0:03:38] } 47. b4 { [%clk 0:01:47] } 47... Kf5 { [%clk 0:03:40] } 48. b5 { [%clk 0:01:47] } 48... Kg4 { [%clk 0:03:38] } 49. Bd6 { [%clk 0:01:48] } 49... Kh3 { [%clk 0:03:30] } 50. b6 { [%clk 0:01:50] } 50... Kg4 { [%clk 0:03:31] } 51. b7 { [%clk 0:01:51] } 51... Kh3 { [%clk 0:03:33] } 52. b8=Q { [%clk 0:01:52] } 52... Kg4 { [%clk 0:03:35] } 53. Qc8+ { [%clk 0:01:54] } 53... Kf3 { [%clk 0:03:37] } 54. Qf8+ { [%clk 0:01:55] } 1-0\n\n\n",
    "clock": {
        "initial": 300,
        "increment": 3,
        "totalTime": 420
    }
}
""".data(using: .utf8)!

let sampleLichessGame = parseGameJson(json: jsonData)

private func parseGameJson(json: Data) -> LichessGame? {
    let decoder = JSONDecoder()
    do {
        return try decoder.decode(LichessGame.self, from: json)
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
}
