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
    
    var body: some View {
        ScrollView {
            Grid(alignment: .leadingFirstTextBaseline, horizontalSpacing: -8, verticalSpacing: 2) {
                GridRow {
                    Text("Species").font(.subheadline)
                    Text("Weight").font(.subheadline)
                    Text("Length").font(.subheadline)
                    Text("M/C").font(.subheadline)
                    Text("Comment").font(.subheadline)
                    Text("Tag").font(.subheadline)
                    Text("Mort").font(.subheadline)
                }
                .font(.title2)
                
                Divider()
               
                ForEach(tripData.fish, id: \.self) { fish in
                    GridRow {
                        Text(fish.species).font(.system(size: 16, weight: .bold))
                        Text("\(fish.weight)")
                        Text("\(fish.length)")
                        Text("\(fish.mc)")
                        Text(fish.comment)
                        Text("\(fish.pitTag.isEmpty ? "" : fish.pitTag)")
                        Text("\(fish.mort == "Y" ? "Yes" : "No")")
                    }
                }
            }
        }
        .onAppear {
            
        }
   }
}

/*
#Preview {
    SpeciesListView(sort: SortDescriptor(\Species.active))
}
*/
