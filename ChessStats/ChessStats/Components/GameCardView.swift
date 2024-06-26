//
//  GameCardView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 13/05/2024.
//

import SwiftUI

struct GameCardView: View {
    let game: UserGame
    
    var body: some View {
        HStack {
            if (game.score == 1) {
                Image(systemName: "plus.square.fill")
                    .foregroundColor(Color.green)
            }
            else if (game.score == 0.5) {
                Image(systemName: "equal.square.fill")
                    .foregroundColor(Color.gray)
            }
            else {
                Image(systemName: "minus.square.fill")
                    .foregroundColor(Color.red)
            }
            VStack(alignment: .leading) {
                Text(game.endTime.timeFormatted())
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .font(.headline)
                if (game.score == 1) {
                    Text("Won by \(game.wonBy)")
                        .font(.caption)
                }
                else if (game.score == 0.5) {
                    Text("By \(game.result)")
                        .font(.caption)
                }
                else {
                    Text("Lost by \(game.result)")
                        .font(.caption)
                }
                
            }
            Spacer()
            Text(String(game.rating))
                .font(.headline)
                .padding(.trailing)
            Text(game.accuracy != nil ? "(\(String(game.accuracy!)))" : "(-)")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .font(.caption2)
                .padding(.trailing)
                .frame(width: 60)
            Link("Open", destination: URL(string: game.url)!)
                .font(.system(size: 10)) // Smaller font size for a more refined look
                .padding(.horizontal, 14) // Further reduced horizontal padding
                .padding(.vertical, 6) // Further reduced vertical padding
                .foregroundColor(.white)
                .cornerRadius(3) // Subtly rounded corners
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.white, lineWidth: 0.5) // Lighter border for a finer touch
                )
        }
    }
}

#Preview {
    GameCardView(game: sampleUserGame)
}
