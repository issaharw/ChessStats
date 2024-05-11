//
//  ChessStatsManager.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import Foundation
import SwiftUI
import SwiftData


class ChessStatsManager: ObservableObject {
    
    var chessData: ChessData
//    var persistenceManager: PersistenceManager
    
    init(chessData: ChessData) {
        self.chessData = chessData
//        self.persistenceManager = persistenceManager
    }
    
    func getProfileStat() {
        let start = now()
        sendRequest(urlStr: "https://api.chess.com/pub/player/issaharw/stats") { (data, error) in
            let received = now()
            if let profileStat = data {
                DispatchQueue.main.async {
                    self.chessData.profileStat = parseProfileStat(from: profileStat)!
                }
                print("UI Shown: \(now() - received). Request: \(received - start)")
            }
            else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func getGameArchives() {
        let start = now()
        sendRequest(urlStr: "https://api.chess.com/pub/player/issaharw/games/archives") { (data, error) in
            let received = now()
            if let archives = data?["archives"] as? [String] {
                DispatchQueue.main.async {
                    self.chessData.archives = archives.sorted(by: >).map { url in MonthArchive(url: url) }
                }
                print("UI Shown: \(now() - received). Request: \(received - start)")
            }
            else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func buildDaysStats(monthArchive: MonthArchive) {
        let start = now()
        sendRequest(urlStr: monthArchive.archiveUrl) { (data, error) in
            let received = now()
            if let gamesArray = data?["games"] as? [[String: Any]] {
                let rawGames = parseGames(from: gamesArray)
                let userGames = rawGames.map { game in UserGame.fromChessGame(game: game) }.sorted { $0.endTime < $1.endTime }
                let gamesByDate = self.groupGamesByDay(games: userGames)
                DispatchQueue.main.async {
                    self.chessData.dayStatsByMonth[monthArchive] = self.buildDayStats(gamesByDate: gamesByDate, allGames: userGames).sorted { $0.date > $1.date }
                }
                print("Day UI Shown: \(now() - received). Request: \(received - start)")
            }
            else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func groupGamesByDay(games: [UserGame]) -> [Date: [UserGame]] {
        var groupedGames = [Date: [UserGame]]()

        for game in games {
            if groupedGames[game.datePlayed] != nil {
                groupedGames[game.datePlayed]?.append(game)
            } else {
                groupedGames[game.datePlayed] = [game]
            }
        }

        return groupedGames
    }
    
    func groupGamesByTimeClass(userGames: [UserGame]) -> [String: [UserGame]] {
        var groupedGames = [String: [UserGame]]()

        for game in userGames {
            if groupedGames[game.timeClass] != nil {
                groupedGames[game.timeClass]?.append(game)
            } else {
                groupedGames[game.timeClass] = [game]
            }
        }

        return groupedGames

    }
    
    
    func buildDayGameTypeStats(timeClass: String, date: Date, dateGames: [UserGame], allGames: [UserGame]) -> DayGameTypeStats {
        return DayGameTypeStats(timeClass: timeClass,
                                date: date,
                                startRating: findRatingBeforeGame(allGames: allGames, ofGame: dateGames.first!),
                                endRating: dateGames.last?.rating ?? 0,
                                highestRating: dateGames.max { $0.rating < $1.rating }?.rating ?? 0,
                                games: dateGames)
    }
    
    func buildDayStats(gamesByDate: [Date: [UserGame]], allGames: [UserGame]) -> [DayStats]{
        var dayStats = [DayStats]()
        
        for (date, games) in gamesByDate {
            let gamesByTimeClass = groupGamesByTimeClass(userGames: games)
            var dayGameTypeStats = [DayGameTypeStats]()
            for (timeClass, timeClassGames) in gamesByTimeClass {
                dayGameTypeStats.append(buildDayGameTypeStats(timeClass: timeClass, date: date, dateGames: timeClassGames, allGames: allGames))
            }
            dayStats.append(DayStats(date: date, numberOfGames: games.count, gameTypeStats: dayGameTypeStats))
        }
        return dayStats
    }
    
    func findRatingBeforeGame(allGames: [UserGame], ofGame: UserGame) -> Int {
        let indexOfLastGame = allGames.lastIndex { game in
            game.timeClass == ofGame.timeClass && game.endTime < ofGame.endTime
        }
        if (indexOfLastGame == nil) {
            return ofGame.rating
        }
        else {
            return allGames[indexOfLastGame!].rating
        }
    }
}


