//
//  MonthView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI

struct MonthCardView: View {
    let monthArchive: MonthArchive
    
    var body: some View {
        Label("\(monthArchive.month), \(monthArchive.year)", systemImage: "calendar")
            .font(.headline)
    }
}

#Preview {
    MonthCardView(monthArchive: MonthArchive(url: "https://api.chess.com/pub/player/issaharw/games/2024/05"))
}
