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
    var httpUtil: HttpUtil
    var persistenceManager: PersistenceManager
    
    init(chessData: ChessData, httpUtil: HttpUtil, persistenceManager: PersistenceManager) {
        self.chessData = chessData
        self.httpUtil = httpUtil
        self.persistenceManager = persistenceManager
    }
    
    func getProfileStat() {
        let start = now()
        let profileStat = self.persistenceManager.fetchProfileStat()
        if (profileStat != nil) {
            print("Found profile stat in swfit data. Date fetched: \(profileStat!.dateFetched)")
            chessData.profileStat = profileStat
        }
        
        httpUtil.fetchData(ofType: ProfileStatRecord.self, from: "https://api.chess.com/pub/player/issaharw/stats") { (data, error) in
            let received = now()
            if let profileStat = data {
                DispatchQueue.main.async {
                    self.chessData.profileStat = ProfileStat(from: profileStat)
                    self.persistenceManager.saveProfileStat(stat: self.chessData.profileStat!)
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
        let archivesFromData = self.persistenceManager.fetchArchives()
        if (!archivesFromData.isEmpty && archivesFromData.first!.isCurrentMonth()) {
            self.chessData.archives = archivesFromData
            print("Fetched data from archives. First month is: \(archivesFromData.first!.archiveUrl)")
            return
        }
        
        httpUtil.fetchData(ofType: MonthArchives.self, from: "https://api.chess.com/pub/player/issaharw/games/archives") { (data, error) in
            let received = now()
            if let archivesFromChessCom = data {
                DispatchQueue.main.async {
                    self.chessData.archives = archivesFromChessCom.archives.sorted(by: >).map { url in MonthArchive(url: url) }
                    self.persistenceManager.saveArchives(archives: self.chessData.archives)
                    
                }
                print("UI Shown: \(now() - received). Request: \(received - start)")
            }
            else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    func buildDaysStats(monthArchive: MonthArchive) {
        if (monthArchive.isCurrentMonth()) {
            fetchUserGames(monthArchive: monthArchive, alsoSaveToData: false)
        }
        else { // past month
            let dayStatsByMonth = self.chessData.dayStatsByMonth[monthArchive]
            if (dayStatsByMonth != nil && !dayStatsByMonth!.isEmpty) {
                print("fetched day stats by month. No need to fetch again")
            }
            else {
                fetchUserGames(monthArchive: monthArchive, alsoSaveToData: false)
            }
        }
    }
    
    private func fetchUserGames(monthArchive: MonthArchive, alsoSaveToData: Bool) {
        let start = now()
        let urls = getArchivesToFetch(for: monthArchive)
        httpUtil.fetchMultipleData(ofType: Games.self, from: urls) { (data, error) in
            if (error != nil) {
                print("found an error, fetching again...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // run again after a second. there might be a problem in Chess.com
                    self.fetchUserGames(monthArchive: monthArchive, alsoSaveToData: alsoSaveToData)
                }
            }
            let received = now()
            if let gamesObjects = data {
                print("For Months: \(urls) I got from Chess.com \(gamesObjects.count) Games")
//                let rawGames = parseGames(from: gamesArray)
                let userGames = gamesObjects.flatMap {$0.games}.map { game in UserGame.fromChessGame(game: game) }.sorted { $0.endTime < $1.endTime }
                self.buildDaysStats(monthArchive: monthArchive, games: userGames)
                if (alsoSaveToData) {
                    DispatchQueue.main.async {
                        self.persistenceManager.saveUserGames(games: userGames)
                    }
                }
                print("Fetch User Games - Request: \(received - start). Processing: \(now() - received).")
            }
            else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    private func getArchivesToFetch(for archive: MonthArchive) -> [String] {
        // for current month, get this month and the month before (for start rating of the first day of the month
        if (archive.isCurrentMonth()) {
            if (chessData.archives.count > 1) {
                return [chessData.archives[0].archiveUrl, chessData.archives[1].archiveUrl]
            }
            else {
                return [archive.archiveUrl]
            }
        }
        else {
            // for past month, get the data of the month and the one before (for start rating) and the month after (for the games in the morning of the 1st)
            let index = chessData.archives.firstIndex(of: archive)!
            if (chessData.archives.count > 2 && index != chessData.archives.count - 1 ) {
                return [chessData.archives[index - 1].archiveUrl, chessData.archives[index].archiveUrl, chessData.archives[index + 1].archiveUrl]
            }
            else {
                return [chessData.archives[index - 1].archiveUrl, chessData.archives[index].archiveUrl]
            }
                
        }
    }
    
    private func buildDaysStats(monthArchive: MonthArchive, games: [UserGame]) {
        let gamesByDate = self.groupGamesByDay(games: games)
        let gamesByDateOfMonth = gamesByDate.filter { date, _ in monthArchive.isInMonth(date: date) }
        DispatchQueue.main.async {
            self.chessData.dayStatsByMonth[monthArchive] = self.buildDayStats(gamesByDate: gamesByDateOfMonth, allGames: games).sorted { $0.date > $1.date }
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


