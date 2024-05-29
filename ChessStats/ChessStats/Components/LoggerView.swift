//
//  LoggerView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 28/05/2024.
//

import SwiftUI

struct LoggerView: View {
    @State private var logs = "Loading logs..."
    var body: some View {
        ScrollView {
            Text(logs)
        }
        .padding()
        .onAppear(perform: loadLogs)
    }
    
    private func loadLogs() {
        if let logContent = FileLogger.shared.readLogs() {
            logs = logContent
        } else {
            logs = "No logs available."
        }
    }
}

#Preview {
    LoggerView()
}
