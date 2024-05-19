//
//  GamesView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 10/05/2024.
//

import SwiftUI

struct GamesView: View {
    
    let stat: DayGameTypeStats
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                HStack {
                    Image("\(stat.timeClass)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text(stat.timeClass.capitalized)
                }
                .frame(maxHeight: 30)
                DayRatingCardView(stat: stat)
                RatingChart(userGames: stat.games, startRating: stat.startRating)
                    .frame(minHeight: 100)
                GamesBarView(userGames: stat.games)
            }
            .padding()
            .frame(maxHeight: 320)
            List {
                ForEach(stat.games) { game in
                    GameCardView(game: game)
                }
            }
        }
    }
}

#Preview {
    GamesView(stat: sampleDayStats.gameTypeStats.first!)
}
