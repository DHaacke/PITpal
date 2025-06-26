//
//  SpeciesListView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/22/25.
//

import SwiftData
import SwiftUI
import Combine

struct SpeciesListView: View {
    @Environment(\.modelContext) var modelContext
    // @Query(sort: [SortDescriptor(\Species.active)]) var speciesList: [Species]
    // @Query(sort: \Species.active, order: .reverse) var speciesList: [Species]
    @Query(sort: \Species.name, order: .forward) var speciesList: [Species]
    
    // @State private var sortOrder = SortDescriptor(\Species.active)
    
    var body: some View {
//        ScrollView {
            VStack {
                Table(speciesList) {
                    TableColumn("Code") { sp in Text(sp.code) }.width(60)
                    TableColumn("Name", value: \.name)
                    TableColumn("Image Name", value: \.imageName)
                    TableColumn("Color", value: \.color)
                    TableColumn("Active", value: \.active)
                }
                .scrollContentBackground(.hidden)
                // .background(Color("AppBackground"))
            }
            .tableStyle(.automatic)
            .frame(minWidth: 600, maxWidth: .infinity, minHeight: 240, maxHeight: .infinity  )
            .padding(.top, 8)
            .padding(.horizontal, 12)
        }
//    }

    init(sort: SortDescriptor<Species>) {
        _speciesList = Query(sort: [sort])
            
    }

    func deleteSpecies(_ indexSet: IndexSet) {
        for index in indexSet {
            let species = speciesList[index]
            modelContext.delete(species)
        }
    }
    
    func getRecordCount(modelContext: ModelContext) -> Int {
        let descriptor = FetchDescriptor<Species>(predicate: #Predicate { $0.name != "" })
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }
}

/*
#Preview {
    SpeciesListView(sort: SortDescriptor(\Species.active))
}
*/
