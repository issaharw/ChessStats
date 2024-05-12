//
//  GameArchives.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI

struct MainScreen: View {
    @EnvironmentObject private var chessData: ChessData
    @EnvironmentObject private var statsManager: ChessStatsManager
    
    var body: some View {
        NavigationStack {
            Section(header: Label("Profile Stats", systemImage: "person")) {
                ProfileStatView()
            }
            Section(header: Label("Daily Stats", systemImage: "calendar")) {
                List(chessData.archives) { archive in
                    NavigationLink(destination: MonthView(monthArchive: archive)){
                        MonthCardView(monthArchive: archive)
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    MainScreen()
}
