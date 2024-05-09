//
//  GameArchives.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI

struct GameArchives: View {
    @EnvironmentObject private var chessData: ChessData
    @EnvironmentObject private var statsManager: ChessStatsManager
    
    
    var body: some View {
        NavigationStack {
            List(chessData.archives) { archive in
                NavigationLink(destination: MonthView(monthArchive: archive)){
                    MonthCardView(monthArchive: archive)
                }
            }
            .onAppear {
                statsManager.getGameArchives()
                chessData.$archives.sink { newArchives in
                    print("Got sink: \(newArchives.count)")
                    if (!newArchives.isEmpty) {
                        statsManager.buildDaysStats(monthArchive: newArchives.first!)
                    }
                }
            }
            .navigationTitle("Months Played")
            .toolbar {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
                .accessibilityLabel("New")
            }
        }

    }
}

#Preview {
    GameArchives()
}
