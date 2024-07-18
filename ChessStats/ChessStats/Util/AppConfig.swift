//
//  AppConfig.swift
//  ChessStats
//
//  Created by Issahar Weiss on 18/07/2024.
//

import Foundation

func getSelectedPlatform() -> String {
    return UserDefaults.standard.string(forKey: "ChessPlatform") ?? "Both"
}

func saveSelectedPlatform(platform: String) {
    UserDefaults.standard.set(platform, forKey: "ChessPlatform")
}

