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
    
    func fetchArchives() -> [MonthArchive] {
//        let allArchives = FetchDescriptor<MonthArchive>(sortBy: [SortDescriptor(\MonthArchive.archiveUrl, order: .reverse)])
//        let archives = (try? modelContext.fetch(allArchives)) ?? []
//        return archives
        return []
    }
    
    func saveArchives(archives: [MonthArchive]) {
//        archives.forEach { modelContext.insert($0) }
    }

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
