//
//  ChessStatsApp.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI

@main
struct ChessStatsApp: App {
    
    var chessData: ChessData
    var chessDataManager: ChessStatsManager

    init() {
        self.chessData = ChessData()
        self.chessDataManager = ChessStatsManager(chessData: chessData)
    }
        
    var body: some Scene {
        WindowGroup {
            GameArchives()
                .environmentObject(chessData)
                .environmentObject(chessDataManager)
        }
    }
}
