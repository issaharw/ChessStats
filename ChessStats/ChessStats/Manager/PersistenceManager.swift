//
//  PersistantManager.swift
//  ChessStats
//
//  Created by Issahar Weiss on 09/05/2024.
//

import Foundation
import SwiftData

struct PersistenceManager {

    let modelContext: ModelContext
    
    func fetchProfileStat() -> ProfileStat? {
        let descriptor = FetchDescriptor<ProfileStat>()
        let stat = try? modelContext.fetch(descriptor)
        return stat?.first
    }
    
    func saveProfileStat(stat: ProfileStat) {
        try? modelContext.delete(model: ProfileStat.self)
        modelContext.insert(stat)
//        modelContext.save()
    }
    
    func fetchArchives() -> [MonthArchive] {
        let allArchivesDesc = FetchDescriptor<MonthArchive>(sortBy: [SortDescriptor(\MonthArchive.archiveUrl, order: .reverse)])
        let archives = (try? modelContext.fetch(allArchivesDesc)) ?? []
        return archives
    }
    
    func saveArchives(archives: [MonthArchive]) {
        let fetchedArchives = fetchArchives()
        archives.forEach { newArchive in
            if (!fetchedArchives.contains(newArchive)) {
                modelContext.insert(newArchive)
            }
        }
    }

//    func fetchUserGames(forMonth: MonthArchive) -> [UserGame] {
//        let year = forMonth.year
//        let month = forMonth.monthIndex
//        let gamesPerMonthDesc = FetchDescriptor<UserGame>(predicate: #Predicate<UserGame>{ game in
//            game.year == year && game.month == month
//        },
//            sortBy: [SortDescriptor(\UserGame.endTime)])
//        let gamesPerMonth = (try? modelContext.fetch(gamesPerMonthDesc)) ?? []
//        return gamesPerMonth
//    }
//    
//    private func fetchAllGames() -> [UserGame] {
//        return (try? modelContext.fetch(FetchDescriptor<UserGame>())) ?? []
//    }
//    
//    func saveUserGames(games: [UserGame]) {
//        let start = now()
//        let allGames = fetchAllGames()
//        games.forEach { newGame in
//            if (!allGames.contains(newGame)) {
//                modelContext.insert(newGame)
//            }
//        }
//        try? modelContext.save()
//        print("Save User Games: \(now() - start). ")
//    }
    
    func fetchDayStats(forMonth: MonthArchive) -> [DayStats] {
//        let allDayStatsPerMonth = FetchDescriptor<DayStats>(
////            predicate: #Predicate { dayStat in forMonth.isInMonth(date: dayStat.date) },
//            sortBy: [SortDescriptor(\DayStats.date, order: .reverse)])
//        let dayStats = (try? modelContext.fetch(allDayStatsPerMonth)) ?? []
//        return dayStats

        return []
    }
    
    func saveDayStats(archives: [DayStats]) {
//        archives.forEach { modelContext.insert($0) }
    }
}
