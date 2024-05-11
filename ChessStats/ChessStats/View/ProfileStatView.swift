//
//  ContentView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 12/05/2024.
//

import SwiftUI

import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var chessData: ChessData

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                GameStatCard(title: "bullet", rating: chessData.profileStat?.bullet.last.rating ?? 0)
                GameStatCard(title: "blitz", rating: chessData.profileStat?.blitz.last.rating ?? 0)
                GameStatCard(title: "rapid", rating: chessData.profileStat?.rapid.last.rating ?? 0)
                GameStatCard(title: "daily", rating: chessData.profileStat?.daily.last.rating ?? 0)
            }
            .padding()
        }
        .background(Color.black.edgesIgnoringSafeArea(.all))
    }
}

struct GameStatCard: View {
    var title: String
    var rating: Int

    var body: some View {
        VStack {
            Text(title.capitalized)
                .font(.title3)
                .foregroundColor(.white)
                .padding(.top)

            Image(title)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.yellow)
                .frame(width: 30, height: 30)
                .padding()

            Text(String(rating))
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.bottom)
        }
        .frame(width: 120, height: 150)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
    }
}

#Preview {
    ContentView()
}
