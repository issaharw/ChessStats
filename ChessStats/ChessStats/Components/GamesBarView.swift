//
//  GamesBarView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 09/05/2024.
//

import SwiftUI

struct GamesBarView: View {
    let userGames: [UserGame]
    private var totalGames: Int
    private var gamesWon: Int
    private var gamesDrawn: Int
    private var gamesLost: Int
    
    init(userGames: [UserGame]) {
        self.userGames = userGames
        self.totalGames = userGames.count
        self.gamesWon = userGames.filter { $0.score == 1 }.count
        self.gamesDrawn = userGames.filter { $0.score == 0.5 }.count
        self.gamesLost = userGames.filter {$0.score == 0 }.count
    }

    var body: some View {
        VStack {
            // Percentages above the bar
            HStack {
                Text("\(Int(Double(gamesWon) / Double(totalGames) * 100))%")
                    .foregroundColor(.green)
//                        .padding(.leading)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("\(Int(Double(gamesDrawn) / Double(totalGames) * 100))%")
                    .foregroundColor(.gray)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Text("\(Int(Double(gamesLost) / Double(totalGames) * 100))%")
                    .foregroundColor(.red)
//                        .padding(.trailing)
                    .font(.title)
                    .fontWeight(.bold)
            }
            .font(.caption)

            // Progress bar
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    Rectangle()
                        .frame(width: geometry.size.width * CGFloat(gamesWon) / CGFloat(totalGames), height: 15)
                        .foregroundColor(.green)
                    Rectangle()
                        .frame(width: geometry.size.width * CGFloat(gamesDrawn) / CGFloat(totalGames), height: 15)
                        .foregroundColor(.gray)
                    Rectangle()
                        .frame(width: geometry.size.width * CGFloat(gamesLost) / CGFloat(totalGames), height: 15)
                        .foregroundColor(.red)
                }
            }
            .frame(height: 20)

            // Numbers below the bar
            HStack {
                Text("\(gamesWon) Won")
                    .foregroundColor(.green)
                    .fontWeight(.bold)
                Spacer()
                Text("\(gamesDrawn) Drawn")
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                Spacer()
                Text("\(gamesLost) Lost")
                    .foregroundColor(.red)
                    .fontWeight(.bold)
            }
            .font(.caption)
        }
    }
}

#Preview {
    GamesBarView(userGames: [])
}
