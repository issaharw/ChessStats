//
//  ContentView.swift
//  ChessStats
//
//  Created by Issahar Weiss on 12/05/2024.
//

import UniformTypeIdentifiers
import SwiftUI

struct ProfileStatView: View {

    @EnvironmentObject private var chessData: ChessData
    @EnvironmentObject private var statsManager: ChessStatsManager
    @State private var timeClasses: [String] = Globals.shared.timeClassSorting
    @State private var draggedItem: String? = nil
    

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(timeClasses, id: \.self) { timeClass in
                    let rating = chessData.profileStat?.getStat(for: timeClass)?.current ?? 0
                    let highest = chessData.profileStat?.getStat(for: timeClass)?.best ?? 0
                    GameStatCard(title: timeClass, rating: rating, highest: highest)
                        .onDrag {
                            self.draggedItem = timeClass
                            return NSItemProvider(object: timeClass as NSString)
                        }
                        .onDrop(of: [UTType.text], delegate: DropViewDelegate(item: timeClass, items: $timeClasses, draggedItem: $draggedItem))

                }
                TimeCard(title: chessData.profileStat?.dateFetched.timeFormatted() ?? "00:00")
            }
            .padding()
        }
    }
}

class DropViewDelegate: DropDelegate {
    let item: String
    @Binding var items: [String]
    @Binding var draggedItem: String?
    var destIndex: Int? = nil
    
    init(item: String, items: Binding<[String]>, draggedItem: Binding<String?>) {
        self.item = item
        self._items = items
        self._draggedItem = draggedItem
    }
    
    func performDrop(info: DropInfo) -> Bool {
        print("Mic drop - Item: \(item). Dest: \(destIndex ?? -1). Dragged: \(draggedItem ?? "")")
        guard let srcIndex = items.firstIndex(of: draggedItem!) else { return false }
        withAnimation {
            items.move(fromOffsets: IndexSet(integer: srcIndex), toOffset: destIndex! > srcIndex ? destIndex! + 1 : destIndex!)
        }
        Globals.shared.saveOrder(timeClasses: items)
        draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let destinationIndex = items.firstIndex(of: item) else { return }
        destIndex = destinationIndex
        print("Item: \(item). Dest: \(destinationIndex). Dragged: \(draggedItem ?? "")")
    }
}

struct GameStatCard: View {
    var title: String
    var rating: Int
    var highest: Int

    var body: some View {
        VStack {
            Text(String(rating))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)

            Image(title)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 40, height: 40)


            HStack {
                Image(systemName: "star.fill")
                Text(String(highest))
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .padding()
        }
        .frame(width: 115, height: 140)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
    }
}

struct TimeCard: View {
    var title: String

    var body: some View {
        VStack {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top)
            
            Image(systemName: "clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.white)
                .frame(width: 40, height: 40)
            
            
            Text("last fetched")
                .font(.title3)
                .foregroundColor(.white)
                .padding(.vertical)
        }
        .frame(width: 115, height: 140)
        .background(Color.gray.opacity(0.5))
        .cornerRadius(10)
    }
}

#Preview {
    ProfileStatView()
}
