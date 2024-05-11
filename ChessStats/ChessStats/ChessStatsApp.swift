//
//  ChessStatsApp.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI
import SwiftData

@main
struct ChessStatsApp: App {
    
    var chessData: ChessData
    var chessDataManager: ChessStatsManager
//    var persistenceManager: PersistenceManager
//
//    var modelContainer: ModelContainer = {
//        let schema = Schema([
//            MonthEndRating.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()

    init() {
        self.chessData = ChessData()
//        self.persistenceManager = PersistenceManager(modelContext: modelContainer.mainContext)
        self.chessDataManager = ChessStatsManager(chessData: chessData)
    }
        
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environmentObject(chessData)
                .environmentObject(chessDataManager)
        }
    }
}
