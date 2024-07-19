//
//  DayRatingCardView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 11/05/2024.
//

import SwiftUI

struct DayRatingCardView: View {
    let stat: DayGameTypeStats
    let arrowIcon: String
    
    init(stat: DayGameTypeStats) {
        self.stat = stat
        self.arrowIcon = (stat.startRating <= stat.endRating) ? "arrow.up" : "arrow.down"
    }
    var body: some View {
        VStack {
            HStack {
                StatView(icon: "rectangle.checkered", label: "Games", value: "\(stat.games.count)")
                Divider()
                StatView(icon: "chart.bar", label: "Start", value: "\(stat.startRating)")
                Divider()
                StatView(icon: "chart.bar.fill", label: "End", value: "\(stat.endRating)")
                Divider()
                StatView(icon: "star.fill", label: "Max", value: "\(stat.highestRating)")
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

struct StatView: View {
    var icon: String
    var label: String
    var value: String

    var body: some View {
        VStack {
            Image(systemName: icon)
                .foregroundColor(.accentColor)
                .imageScale(.large)
            Text(value)
                .font(.headline)
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    DayRatingCardView(stat: DayGameTypeStats(platform: "Chess.com", timeClass: "bullet", date: Date(), startRating: 900, endRating: 930, highestRating: 930, games: []))
}
