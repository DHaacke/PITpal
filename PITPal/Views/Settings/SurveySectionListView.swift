//
//  SurveySectionListView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/22/25.
//

import SwiftData
import SwiftUI
import Combine

struct SurveySectionListView: View {
    @Environment(\.modelContext) var modelContext
    // @Query(sort: [SortDescriptor(\Species.active)]) var speciesList: [Species]
    // @Query(sort: \Species.active, order: .reverse) var speciesList: [Species]
    @Query(sort: \SurveySection.active, order: .reverse) var surveySections: [SurveySection]
    
    var body: some View {
        VStack {
            Table(surveySections) {
                TableColumn("Code") { ss in Text(ss.code) }.width(60)
                TableColumn("Name", value: \.name).width(160)
                TableColumn("Lat↓") { ss in Text("\(ss.latDown, specifier: "%.4f")") }
                TableColumn("Lon↓") { ss in Text("\(ss.lonDown, specifier: "%.4f")") }
                TableColumn("Lat↑") { ss in Text("\(ss.latUp, specifier: "%.4f")") }
                TableColumn("Lon↑") { ss in Text("\(ss.lonUp, specifier: "%.4f")") }
                TableColumn("Active", value: \.active).width(50)
            }
            .scrollContentBackground(.hidden)
            // .background(Color("AppBackground"))
        }
        .tableStyle(.automatic)
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 160, maxHeight: .infinity  )
        .padding(.top, 8)
    }

    init(sort: SortDescriptor<SurveySection>) {
        _surveySections = Query(sort: [sort])
            
    }
    
    func getRecordCount(modelContext: ModelContext) -> Int {
        let descriptor = FetchDescriptor<SurveySection>(predicate: #Predicate { $0.name != "" })
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }
}

#Preview {
    SurveySectionListView(sort: SortDescriptor(\SurveySection.name))
}



