//
//  MonthView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI

struct MonthView: View {
    let monthArchive: MonthArchive
    @State var daysStats: [DayStats] = []

    var body: some View {
        NavigationStack {
            List(daysStats) { dayStat in
                NavigationLink(destination: DayView(dayStats: dayStat)){
                    DayCardView(dayStats: dayStat)
                }
                .listRowBackground(Color("sky"))
            }
            .onAppear {
                ChessStatsManager.shared.buildDaysStats(monthArchiveUrl: monthArchive.archiveUrl, games: $daysStats)
            }
            .navigationTitle("Day Statistics")
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
    MonthView(monthArchive: MonthArchive(url: "https://api.chess.com/pub/player/issaharw/games/2024/05"))
}
