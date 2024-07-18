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

    func getSelectedPlatform() -> String {
        return UserDefaults.standard.string(forKey: "ChessPlatform") ?? "Both"
    }
    
    func saveSelectedPlatform(platform: String) {
        UserDefaults.standard.set(platform, forKey: "ChessPlatform")
    }

}
