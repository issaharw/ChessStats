//
//  ContentView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 12/05/2024.
//

import SwiftUI

import SwiftUI

struct ProfileStatView: View {

    @EnvironmentObject private var chessData: ChessData
    @EnvironmentObject private var statsManager: ChessStatsManager

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                GameStatCard(title: "bullet", rating: chessData.profileStat?.bullet.last.rating ?? 0)
                GameStatCard(title: "blitz", rating: chessData.profileStat?.blitz.last.rating ?? 0)
                GameStatCard(title: "rapid", rating: chessData.profileStat?.rapid.last.rating ?? 0)
                GameStatCard(title: "daily", rating: chessData.profileStat?.daily.last.rating ?? 0)
            }
            .padding()
        }
    }
}

struct GameStatCard: View {
    var title: String
    var rating: Int

    var body: some View {
        VStack {
            Image(title)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.yellow)
                .frame(width: 50, height: 50)
                .padding(.top)

            Text(String(rating))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.white)

            Text(title.capitalized)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.bottom)

        }
        .frame(width: 115, height: 140)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileStatView()
}
