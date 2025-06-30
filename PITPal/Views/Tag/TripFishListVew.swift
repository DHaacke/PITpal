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
    
    @Binding var trip: Trip

    @State private var fishList: [Fish] = []
    
    var body: some View {
        ScrollView {
            Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: 15, verticalSpacing: 10) {
                GridRow {
                    Text("Species").font(.subheadline)
                    Text("FWP").font(.subheadline)
                    Text("Weight").font(.subheadline)
                    Text("Length").font(.subheadline)
                    Text("DOA").font(.subheadline)
                    Text("Scars").font(.subheadline)
                    Text("Comment").font(.subheadline)
                }
                .font(.title2)
                Divider()
                ForEach(fishList) { fish in
                    GridRow {
                        Text(fish.species).font(.system(size: 16, weight: .bold))
                        Text(fish.fwpSpecies).font(.system(size: 16, weight: .bold))
                        Text(fish.weight, format: .number)
                        Text(fish.length, format: .number)
                        Text(fish.doa == "Y" ? "Yes" : "No")
                        Text(fish.hookScar == "Y" ? "Yes" : "No")
                        Text(fish.comment)
                    }
                }
            }
        }
        .onAppear {
            fishList = trip.fish.sorted { $0.length > $1.length }
        }
   }
}

/*
#Preview {
    SpeciesListView(sort: SortDescriptor(\Species.active))
}
*/


    //                TableColumn("Species") { fish in Text(fish.species) }.width(80)
    //                TableColumn("FWP")  { fish in Text(fish.fwpSpecies) }.width(80)
    //                TableColumn("Weight") { fish in Text(fish.weight, format: .number) }.width(80)
    //                TableColumn("Length") { fish in Text(fish.length, format: .number) }.width(80)
    //                TableColumn("DOA") { fish in Text(fish.doa ? "Yes" : "No") }.width(60)
    //                TableColumn("Scars") { fish in Text(fish.hookScar ? "Yes" : "No") }.width(60)
    //                TableColumn("Comment", value: \.comment).width(120)
