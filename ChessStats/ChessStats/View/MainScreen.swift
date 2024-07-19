//
//  GameArchives.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI

struct MainScreen: View {
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject private var chessData: ChessData
    @EnvironmentObject private var statsManager: ChessStatsManager
    @State private var isPresentingLogView = false
    @State private var chessPlatform = Globals.shared.getSelectedPlatform()
    
    
    var body: some View {
        NavigationStack{
            VStack {
                ProfileStatView()
                Spacer()
                let archives = chessData.archives
                if (archives.isEmpty) {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .scaleEffect(2)
                    Spacer()
                }
                else {
                    let monthArchive = archives.first!
                    let dayStatByMonth = chessData.dayStatsByMonth[monthArchive] ?? []
                    if (dayStatByMonth.isEmpty) {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(2)
                        Spacer()
                    }
                    else {
                        List(dayStatByMonth) { dayStat in
                            NavigationLink(destination: DayView(dayStats: dayStat)){
                                DayCardView(dayStats: dayStat)
                            }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Logs", systemImage: "gearshape") {
                        isPresentingLogView = true
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    NavigationLink(destination: MonthsView()){
                        Image(systemName: "calendar")
                    }
                }
                ToolbarItem(placement: .automatic) {
                    Menu {
                        Button(action: {
                            chessPlatform = "Chess.com"
                            Globals.shared.saveSelectedPlatform(platform: chessPlatform)
                            Globals.shared.refetchGamesNeeded = true
                            self.statsManager.prefetchCurrentMonth()
                        }) {
                            Text("Chess.com")
                        }
                        Button(action: {
                            chessPlatform = "Lichess"
                            Globals.shared.saveSelectedPlatform(platform: chessPlatform)
                            Globals.shared.refetchGamesNeeded = true
                            self.statsManager.prefetchCurrentMonth()
                        }) {
                            Text("Lichess")
                        }
                        Button(action: {
                            chessPlatform = "Both"
                            Globals.shared.saveSelectedPlatform(platform: chessPlatform)
                            Globals.shared.refetchGamesNeeded = true
                            self.statsManager.prefetchCurrentMonth()
                        }) {
                            Text("Both")
                        }
                    } label: {
                        HStack {
                            Text("Platform: \(chessPlatform)")
                            Image(systemName: "ellipsis.circle")
                        }
                    }
                }

            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if (newPhase == .active) {
                debug("Scene new phase is ACTIVE")
                Globals.shared.refetchGamesNeeded = true
                self.statsManager.getGameArchives() { error in
                    debug("Finished fetching game archives")
                    self.statsManager.getProfileStat() { error in
                        debug("Finished fetching profile stat")
                        self.statsManager.prefetchCurrentMonth()
                    }
                }
            }
        }
        .sheet(isPresented: $isPresentingLogView) {
            NavigationStack {
                LoggerView()
                    .navigationTitle("Logs")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") {
                                isPresentingLogView = false
                            }
                        }
                    }
            }
        }
    }
}

#Preview {
    MainScreen()
}
