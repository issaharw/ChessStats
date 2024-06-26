//
//  DayView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 03/05/2024.
//

import SwiftUI


struct DayView: View {
    let dayStats: DayStats
    var body: some View {
        List {
            ForEach(dayStats.gameTypeStats) { stat in
                Section(header:
                    Label {
                    Text(stat.timeClass.capitalized)
                    } icon: {
                        Image("\(stat.timeClass)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                    }
                ) {
                    VStack {
                        DayRatingCardView(stat: stat)
                        Spacer()
                        RatingChart(userGames: stat.games, startRating: stat.startRating)
                        Spacer()
                        GamesBarView(userGames: stat.games)
                        Spacer()
                        NavigationLink(destination: GamesView(stat: stat)) {
                            Label {
                            Text("Show Games")
                                .font(.headline)
                            } icon: {
                                Image("\(stat.timeClass)")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(dayStats.date.formattedDate())
    }
}

#Preview {
    DayView(dayStats: sampleDayStats)
}





























//import Charts

//struct DayView: View {
//    let dayStats: DayStats
//    private let minRating: Int
//    private let maxRating: Int
//    
//    init(dayStats: DayStats) {
//        self.dayStats = dayStats
//        minRating = dayStats.gameTypeStats.first!.games.min {$0.rating < $1.rating}?.rating  - 20 ?? dayStats.gameTypeStats.first!.startRating - 20
//        maxRating = dayStats.gameTypeStats.first!.games.max {$0.rating < $1.rating}?.rating + 20 ?? dayStats.gameTypeStats.first!.endRating + 20
//    }
//    
//    var body: some View {
//        VStack {
//            
//        }
//        Text("Shalom")
//        Chart(dayStats.gameTypeStats.first!.games) {
//            LineMark(
//                x: .value("Date", Date(timeIntervalSince1970: TimeInterval($0.endTime))),
//                y: .value("Rating", $0.rating)
//            )
//        }
//        .chartXAxis {
//            AxisMarks(position: .bottom, values: .stride(by: .minute))
//        }
//        .chartYAxis {
//            AxisMarks(position: .leading, values: .stride(by: 10))
//        }
//        .chartYScale(domain: minRating..maxRating)
//    }
//}

