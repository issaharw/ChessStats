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
        Text("\(games.count) Games")
            .font(.headline)
    }
}

#Preview {
    GamesView(games: [])
}
