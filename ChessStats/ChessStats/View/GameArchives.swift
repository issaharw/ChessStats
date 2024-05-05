//
//  GameArchives.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI

struct GameArchives: View {
    @State private var gameArchives: [MonthArchive] = []

    var body: some View {
        NavigationStack {
            List(gameArchives) { archive in
                NavigationLink(destination: MonthView(monthArchive: archive)){
                    MonthCardView(monthArchive: archive)
                }
                .listRowBackground(Color("sky"))
            }
            .onAppear {
                ChessStatsManager.shared.getGameArchives(archivesBinding: $gameArchives)
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
