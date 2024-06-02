//
//  MonthsView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 02/06/2024.
//

import SwiftUI

struct MonthsView: View {
    @EnvironmentObject private var chessData: ChessData

    var body: some View {
        List(chessData.archives) { archive in
            NavigationLink(destination: MonthView(monthArchive: archive)){
                MonthCardView(monthArchive: archive)
            }
            .navigationTitle("Older games")
            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        }
        .listStyle(.plain)
    }
}

#Preview {
    MonthsView()
}
