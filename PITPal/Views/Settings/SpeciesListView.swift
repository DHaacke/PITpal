//
//  SpeciesListView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/22/25.
//

import Foundation
import SwiftData
import SwiftUI
import Combine

struct SpeciesListView: View {
    @Environment(\.modelContext) var modelContext

    @Query(sort: \Species.name, order: .forward) var speciesList: [Species]
    
    @Binding var path: [String]
    
    @State private var selectedSpeciesId: Species.ID?
    @State private var species: Species = Species()
    @State private var isShowingSpeciesDetail = false

    var body: some View {

        VStack {
            Table(speciesList, selection: $selectedSpeciesId) {
                TableColumn("Code") { sp in Text(sp.code) }.width(60)
                TableColumn("FWP Code", value: \.fwpCode)
                TableColumn("Name", value: \.name)
                TableColumn("Image Name", value: \.imageName)
                TableColumn("Color", value: \.color)
                TableColumn("Active", value: \.active)
            }
            .scrollContentBackground(.hidden)
            .background(Color("CardBackground").gradient)
            .onChange(of: selectedSpeciesId) {
                if selectedSpeciesId != nil {
                    isShowingSpeciesDetail = true
                }
            }
            .sheet(isPresented: $isShowingSpeciesDetail) {
                if let speciesId = selectedSpeciesId, let species = speciesList.first(where: { $0.id == speciesId }) {
                    SpeciesDetailView(species: species, isAddingSpecies: false)
                        .environment(\.modelContext, modelContext)
                        .onDisappear {
                            isShowingSpeciesDetail = false
                            // selectedSpeciesId = nil
                        }
                }
            }
        }
        .tableStyle(.automatic)
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 240, maxHeight: .infinity  )
        .padding(.top, 8)
        .padding(.horizontal, 12)
        .onChange(of: selectedSpeciesId) {
            print("Selected Species ID changed: \(selectedSpeciesId ?? "nil")")
        }
            
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
