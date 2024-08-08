//
//  Globals.swift
//  ChessStats
//
//  Created by Issahar Weiss on 19/05/2024.
//

import Foundation

struct Globals {
    
    static var shared = Globals()
        
    var refetchGamesNeeded = false
    var timeClassSorting = ["bullet", "blitz", "rapid", "libullet", "liblitz", "daily"]
//    var timeClassSorting = ["bullet", "blitz", "rapid", "libullet", "liblitz", "lirapid", "daily"]

    func getSelectedPlatform() -> String {
        return UserDefaults.standard.string(forKey: "ChessPlatform") ?? "Both"
    }
    
    func saveSelectedPlatform(platform: String) {
        UserDefaults.standard.set(platform, forKey: "ChessPlatform")
    }

    func loadTimeClassSorting() {
        if let savedOrder = UserDefaults.standard.array(forKey: "timeClassSorting") as? [String] {
            Globals.shared.timeClassSorting = savedOrder
        }
    }
    
    func saveOrder(timeClasses: [String]) {
        UserDefaults.standard.set(timeClasses, forKey: "timeClassSorting")
    }
}

let timeContorlToPlatform = ["bullet": "Chess.com", "blitz": "Chess.com", "rapid": "Chess.com", "libullet": "Lichess", "liblitz": "Lichess", "lirapid": "Lichess", "daily": "Chess.com"]
