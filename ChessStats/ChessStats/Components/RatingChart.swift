//
//  RatingChart.swift
//  ChessStats
//
//  Created by Issahar Weiss on 09/05/2024.
//

import SwiftUI
import Charts

struct RatingChart: View {
    
    private var ratingData: [RatingData]
    private var lowerY: Int
    private var upperY: Int
    @State private var selectedRating: RatingData?
        
    
    init(userGames: [UserGame], startRating: Int) {
        lowerY = (userGames.min { $0.rating < $1.rating }?.rating ?? 500) - 20
        upperY = (userGames.max { $0.rating < $1.rating }?.rating ?? 2000) + 20
        let firstTime = userGames.first?.endTime ?? 0
        self.ratingData = userGames.enumerated().map { index, game in RatingData(rating: game.rating, id: index + 1) }
        self.ratingData.insert(RatingData(rating: startRating, id: 0), at: 0)
    }
    
    var body: some View {
        if let selectedRating = selectedRating {
            Text("Rating: \(selectedRating.rating)")
                .padding()
        }
        Chart(ratingData) { game in
            LineMark(
                x: .value("Date", game.id),
                y: .value("Rating", game.rating)
            )
            .interpolationMethod(.catmullRom)
//            PointMark(
//                x: .value("Date", game.id),
//                y: .value("Rating", game.rating)
//            )
//            .foregroundStyle(by: .value("Rating", game.rating))
//            .symbol(by: .value("Rating", game.rating))
//            .symbolSize(CGSize(width: 8, height: 8))
//            .accessibilityLabel("Rating \(game.rating)")
//            .chartOverlay { proxy in
//                GeometryReader { geometry in
//                    Rectangle().fill(Color.clear).contentShape(Rectangle())
//                        .gesture(
//                            DragGesture(minimumDistance: 0)
//                                .onEnded({ value in
//                                    let location = value.location
//                                    let x = proxy.xAxis[0].convert(location.x, from: geometry)
//                                    let y = proxy.yAxis[0].convert(location.y, from: geometry)
//                                    
//                                    if let closest = game.min(by: { abs($0.id.timeIntervalSince1970 - x) + abs(Double($0.rating) - y) < abs($1.id.timeIntervalSince1970 - x) + abs(Double($1.rating) - y) }) {
//                                        selectedRating = closest
//                                    }
//                                })
//                        )
//                }
//            }
        }
        .chartXAxis {
            AxisMarks(preset: .aligned, position: .bottom)
        }
        .chartYAxis {
            AxisMarks(preset: .aligned, position: .leading)
        }
        .chartYScale(domain: [lowerY, upperY])
        
    }
}

struct RatingData: Identifiable {
    let rating: Int
    let id: Int
}

#Preview {
    RatingChart(userGames: [], startRating: 600)
}
