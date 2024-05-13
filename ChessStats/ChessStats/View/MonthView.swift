//
//  MonthView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI

struct MonthView: View {
    @EnvironmentObject private var chessData: ChessData
    @EnvironmentObject private var statsManager: ChessStatsManager
    let monthArchive: MonthArchive

    var body: some View {
        VStack{
            let dayStatByMonth = chessData.dayStatsByMonth[monthArchive] ?? []
            if (dayStatByMonth.isEmpty) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(2)
            }
            else {
                NavigationStack {
                    List(dayStatByMonth) { dayStat in
                        NavigationLink(destination: DayView(dayStats: dayStat)){
                            DayCardView(dayStats: dayStat)
                        }
                    }
                    .navigationTitle("\(monthArchive.month), \(String(monthArchive.year))")
                    .toolbar {
                        Button(action: {}) {
                            Image(systemName: "plus")
                        }
                        .accessibilityLabel("New")
                    }
                }
            }
        }
        .onAppear {
            statsManager.buildDaysStats(monthArchive: monthArchive)
        }
    }
}

#Preview {
    MonthView(monthArchive: MonthArchive(url: "https://api.chess.com/pub/player/issaharw/games/2024/05"))
}
