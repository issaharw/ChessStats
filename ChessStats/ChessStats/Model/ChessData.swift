//
//  ChessData.swift
//  ChessStats
//
//  Created by Issahar Weiss on 07/05/2024.
//

import Foundation

class ChessData: ObservableObject {
    @Published var archives: [MonthArchive] = []
    @Published var gamesByMonth: [MonthArchive: [UserGame]] = [:]
    @Published var dayStatsByMonth: [MonthArchive: [DayStats]] = [:]
}
