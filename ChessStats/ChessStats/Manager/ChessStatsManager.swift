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
    
    func getProfileStat(completion: ((Error?) -> Void)? = nil) {
        let profileStat = self.persistenceManager.fetchProfileStat()
        if (profileStat != nil) {
            debug("Found profile stat in swfit data. Date fetched: \(profileStat!.dateFetched)")
            chessData.profileStat = profileStat
        }
        
        httpUtil.fetchData(ofType: ProfileStatRecord.self, from: "https://api.chess.com/pub/player/issaharw/stats") { (data, error) in
            if let profileStat = data {
                DispatchQueue.main.async {
                    self.chessData.profileStat = ProfileStat(from: profileStat)
                    self.persistenceManager.saveProfileStat(stat: self.chessData.profileStat!)
                    completion?(nil)
                }
            }
            else if let error = error {
                debug("Error getting Profile Stat: \(error.localizedDescription)")
                completion?(error)
            }
        }
    }
    
    func getGameArchives(completion: ((Error?) -> Void)? = nil) {
        let archivesFromData = self.persistenceManager.fetchArchives()
        if (!archivesFromData.isEmpty && archivesFromData.first!.isCurrentMonth()) {
            self.chessData.archives = archivesFromData
            completion?(nil)
            return
        }
        
        httpUtil.fetchData(ofType: MonthArchives.self, from: "https://api.chess.com/pub/player/issaharw/games/archives") { (data, error) in
            if let archivesFromChessCom = data {
                DispatchQueue.main.async {
                    self.chessData.archives = archivesFromChessCom.archives.sorted(by: >).map { url in MonthArchive(url: url) }
                    self.persistenceManager.saveArchives(archives: self.chessData.archives)
                    completion?(nil)
                }
            }
            else if let error = error {
                debug("Error getting archives from Chess.com: \(error.localizedDescription)")
                completion?(error)
            }
        }
    }
    
    func prefetchCurrentMonth(completion: ((Error?) -> Void)? = nil) {
        if (!self.chessData.archives.isEmpty) {
            debug("Prefetching first month...")
            buildDaysStats(monthArchive: self.chessData.archives.first!, completion: completion)
        }
        else {
            completion?(nil)
        }
    }
    
    
    func buildDaysStats(monthArchive: MonthArchive, completion: ((Error?) -> Void)? = nil) {
        let dayStatsByMonth = self.chessData.dayStatsByMonth[monthArchive]
        if (dayStatsByMonth != nil && !dayStatsByMonth!.isEmpty) { // if there is data in the model (already fetched)
            if (!monthArchive.isCurrentMonth()) { // if not current month, the data won't be new, so no point in fetching again.
                debug("Fetched day stats by month for past month. No need to fetch again")
                completion?(nil)
                return
            }
            else { // current month, check if the app returned from background
                if (Globals.shared.returnedFromBackground) {
                    Globals.shared.returnedFromBackground = false
                    // will fetch
                }
                else {
                    debug("Current month, but the app was always open - no new games. No need to fetch again")
                    completion?(nil)
                    return
                }
            }
        }
        
        fetchUserGames(monthArchive: monthArchive) { (chessComGames, error) in
            if let games = chessComGames {
                self.fetchLichessGames(monthArchive: monthArchive) { (lichessGames, error) in
                    if let liGames = lichessGames {
                        print("ChessCom: \(games.count), Lichess: \(liGames.count)")
                        self.buildDaysStats(monthArchive: monthArchive, games: games + liGames)
                        completion?(nil)
                    }
                    else {
                        completion?(error)
                    }
                }
            }
            else {
                completion?(error)
            }
        }
    }
    
    private func fetchUserGames(monthArchive: MonthArchive, completion: @escaping (([UserGame]?, Error?) -> Void)) {
        let urls = getArchivesToFetch(for: monthArchive)
        httpUtil.fetchMultipleData(ofType: ChessComGames.self, from: urls) { (data, error) in
            if (error != nil) {
                debug("found an error, fetching again...")
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    // run again after a second. there might be a problem in Chess.com
                    self.fetchUserGames(monthArchive: monthArchive, completion: completion)
                }
            }
            if let gamesObjects = data {
                debug("For Months: \(urls) I got from Chess.com \(gamesObjects.count) jsons")
//                let rawGames = parseGames(from: gamesArray)
                let userGames = gamesObjects.flatMap {$0.games}.map { game in UserGame.fromChessComGame(game: game) }.sorted { $0.endTime < $1.endTime }
                completion(userGames, nil)
            }
            else if let error = error {
                debug("Error fetching multiple sites: \(error.localizedDescription)")
                completion(nil, error)
            }
        }
    }
    
    func fetchLichessGames(monthArchive: MonthArchive, completion: @escaping (([UserGame]?, Error?) -> Void)) {
        let (since, until) = getDatesToFetchFromLichess(for: monthArchive)
        let url = "https://lichess.org/api/games/user/issaharw?pgnInJson=true&clocks=true&accuracy=true&rated=true&since=\(since)&until=\(until)"
        httpUtil.fetchLichessData(ofType: LichessGame.self, from: url) { (data, error) in
            if let games = data {
                let userGames = games.map { game in UserGame.fromLichessGame(game: game) }.sorted { $0.endTime < $1.endTime }
                print("Found \(userGames.count) games on lichess")
                completion(userGames, nil)
            }
            else {
                completion(nil, error)
            }
        }
    }

    private func getArchivesToFetch(for archive: MonthArchive) -> [String] {
        let index = chessData.archives.firstIndex(of: archive)!
        if (index == 0) {
            if (chessData.archives.count > 1) {
                return [chessData.archives[0].archiveUrl, chessData.archives[1].archiveUrl]
            }
            else {
                return [archive.archiveUrl]
            }
        }
        else {
            if (chessData.archives.count > 2 && index != chessData.archives.count - 1 ) {
                return [chessData.archives[index - 1].archiveUrl, chessData.archives[index].archiveUrl, chessData.archives[index + 1].archiveUrl]
            }
            else {
                return [chessData.archives[index - 1].archiveUrl, chessData.archives[index].archiveUrl]
            }
        }
    }

    private func getDatesToFetchFromLichess(for archive: MonthArchive) -> (since: Int64, until: Int64) {
        let index = chessData.archives.firstIndex(of: archive)!
        if (index == 0) {
            if (chessData.archives.count > 1) {
                return (chessData.archives[1].getStartAndEndOfMonthInMS().startOfMonth, chessData.archives[0].getStartAndEndOfMonthInMS().endOfMonth)
            }
            else {
                let (s, u) = archive.getStartAndEndOfMonthInMS()
                return (since: s, until: u)
            }
        }
        else {
            if (chessData.archives.count > 2 && index != chessData.archives.count - 1 ) {
                return (chessData.archives[index + 1].getStartAndEndOfMonthInMS().startOfMonth, chessData.archives[index - 1].getStartAndEndOfMonthInMS().endOfMonth)
            }
            else {
                return (chessData.archives[index].getStartAndEndOfMonthInMS().startOfMonth, chessData.archives[index - 1].getStartAndEndOfMonthInMS().endOfMonth)
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


