//
//  TripFishListVew.swift
//  PITPal
//
//  Created by Doug Haacke on 6/29/25.
//

import SwiftData
import SwiftUI
import Combine

struct TripFishListView: View {
    @Environment(\.modelContext) var modelContext
    //@Query(sort: \Fish.date, order: .forward) var fishList: [Fish]
    
    @Binding var tripData: TripData

    @State private var fishList: [FishData] = []
    
    var body: some View {
        ScrollView {
            Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 15, verticalSpacing: 10) {
                GridRow {
                    Text("Species").font(.subheadline)
                    Text("FWP").font(.subheadline)
                    Text("Weight").font(.subheadline)
                    Text("Length").font(.subheadline)
                    Text("Mort").font(.subheadline)
                    Text("Comment").font(.subheadline)
                }
                .font(.title2)
                Divider()
                ForEach(fishList, id: \.id) { fish in
                    GridRow {
                        Text(fish.species).font(.system(size: 16, weight: .bold))
                        Text(fish.fwpSpecies).font(.system(size: 16, weight: .bold))
                        Text(fish.weight, format: .number)
                        Text(fish.length, format: .number)
                        Text(fish.mort == "Y" ? "Yes" : "No")
                        Text(fish.comment)
                    }
                }
            }
        }
        .onAppear {
            fishList = tripData.fish.sorted { $0.length > $1.length }
        }
   }
}

/*
#Preview {
    SpeciesListView(sort: SortDescriptor(\Species.active))
}
*/
