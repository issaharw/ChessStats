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
                GameStatCard(title: "bullet", rating: chessData.profileStat?.bullet.last.rating ?? 0, highest: chessData.profileStat?.bullet.best.rating ?? 0)
                GameStatCard(title: "blitz", rating: chessData.profileStat?.blitz.last.rating ?? 0, highest: chessData.profileStat?.blitz.best.rating ?? 0)
                GameStatCard(title: "rapid", rating: chessData.profileStat?.rapid.last.rating ?? 0, highest: chessData.profileStat?.rapid.best.rating ?? 0)
                GameStatCard(title: "daily", rating: chessData.profileStat?.daily.last.rating ?? 0, highest: chessData.profileStat?.daily.best.rating ?? 0)
                TimeCard(title: chessData.profileStat?.dateFetched.timeFormatted() ?? "00:00")
            }
            .padding()
        }
    }
}

struct GameStatCard: View {
    var title: String
    var rating: Int
    var highest: Int

    var body: some View {
        VStack {
            Text(String(rating))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)

            Image(title)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)


            HStack {
                Image(systemName: "star.fill")
                Text(String(highest))
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(width: 115, height: 140)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
    }
}

struct TimeCard: View {
    var title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            
            Image(systemName: "clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
            
            
            Text("last fetched")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.vertical)
        }
        .frame(width: 115, height: 140)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileStatView()
}
