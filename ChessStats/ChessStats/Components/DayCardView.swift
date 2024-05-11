//
//  GameCardView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI

struct DayCardView: View {
    let dayStats: DayStats
    var body: some View {
        VStack(alignment: .leading) {
            Text(dayStats.date.formattedDate())
                .font(.headline)
                .accessibilityAddTraits(/*@START_MENU_TOKEN@*/.isHeader/*@END_MENU_TOKEN@*/)
            Spacer()
            VStack(alignment: .leading) {
                Label("Total: \(dayStats.numberOfGames) Games", systemImage: "rectangle.checkered")
                ForEach(dayStats.gameTypeStats) { stat in
                    Label {
                        Text("\(stat.startRating) - \(stat.endRating)  (Max: \(stat.highestRating))")
                    } icon: {
                        Image("\(stat.timeClass)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
                
            }
            .font(.caption)
            
        }
    }
}

#Preview {
    DayCardView(dayStats: sampleDayStats)
}
