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
    var chessStatManager: ChessStatsManager
    var persistenceManager: PersistenceManager
    var httpUtil: HttpUtil

    var modelContainer: ModelContainer = {
        let schema = Schema([
            ProfileStat.self,
            MonthArchive.self,
            UserGame.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    init() {
        self.chessData = ChessData()
        self.httpUtil = HttpUtil()
        self.persistenceManager = PersistenceManager(modelContext: modelContainer.mainContext)
        self.chessStatManager = ChessStatsManager(chessData: chessData, httpUtil: httpUtil, persistenceManager: persistenceManager)
        
        self.chessStatManager.getProfileStat()
        self.chessStatManager.getGameArchives()

    }
        
    var body: some Scene {
        WindowGroup {
            MainScreen()
                .environment(\.colorScheme, .dark)
                .environmentObject(chessData)
                .environmentObject(chessStatManager)
        }
    }
}
