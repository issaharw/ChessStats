//
//  GamesView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 10/05/2024.
//

import SwiftUI

struct GamesView: View {
    
    let games: [UserGame]
    
    var body: some View {
        List {
            ForEach(games) { game in
                GameCardView(game: game)
            }
        }
    }
}

#Preview {
    GamesView(games: [])
}
