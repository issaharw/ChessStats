//
//  MonthEndRating.swift
//  ChessStats
//
//  Created by Issahar Weiss on 09/05/2024.
//

import Foundation
import SwiftData

@Model
class MonthEndRating: Identifiable {
    let year: String
    let monnth: Int
    let bulletRating: Int
    let blitzRating: Int
    let rapidRating: Int
    let dailyRating: Int
    
    init(year: String, monnth: Int, bulletRating: Int, blitzRating: Int, rapidRating: Int, dailyRating: Int) {
        self.year = year
        self.monnth = monnth
        self.bulletRating = bulletRating
        self.blitzRating = blitzRating
        self.rapidRating = rapidRating
        self.dailyRating = dailyRating
    }
    
    var id: String {
        "\(year)-\(monnth)"
    }
}
