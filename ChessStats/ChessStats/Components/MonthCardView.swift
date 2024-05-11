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
        VStack(alignment: .leading) {
            Text("\(monthArchive.month)")
                .font(.headline)
                .accessibilityAddTraits(/*@START_MENU_TOKEN@*/.isHeader/*@END_MENU_TOKEN@*/)
            Spacer()
            HStack {
                Label("\(monthArchive.year)", systemImage: "calendar")
                    .accessibilityLabel("\(monthArchive.year) attendees")
                Spacer()
            }
            .font(.caption)
        }
        .padding()
    }
}

#Preview {
    MonthCardView(monthArchive: MonthArchive(url: "https://api.chess.com/pub/player/issaharw/games/2024/05"))
}
