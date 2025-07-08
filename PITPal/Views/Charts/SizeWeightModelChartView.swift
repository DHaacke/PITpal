//
//  SizeWeightModelChartView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/8/25.
//

import Foundation
import SwiftUI
import SwiftData
import Charts



struct SizeWeightModelChartView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var path: [String]
    
    @State private var selectedWatershed: String = ""
    @State private var selectedTripType: String = ""
    @State private var selectedSurveySection: String = ""
    
    @State private var fishList: [FishData] = []
    @State private var isChartReady: Bool = false
    
    @Query(sort: \TripType.name, order: .forward) var tripTypeList: [TripType]
    @Query(sort: \Watershed.name, order: .forward) var watershedList: [Watershed]
    @Query(sort: \SurveySection.name, order: .forward) var surveySectionList: [SurveySection]
    
    let q = Queries()

    var body: some View {
        VStack {
            HStack() {
                LabeledContent {
                    Picker("", selection: $selectedWatershed) {
                        Text("All Waters").tag("")
                        ForEach(watershedList, id: \.code) { water in
                            Text(water.name)
                                .frame(width: 400)
                        }
                    }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                } label: {
                    Text("Watershed:")
                }.frame(width: 400, height: 40)
            }.padding(.leading, 100)
            
            HStack {
                LabeledContent {
                    Picker("", selection: $selectedTripType) {
                        Text("All Trip Types").tag("")
                        ForEach(tripTypeList, id: \.code) { type in
                            Text(type.name)
                                .frame(width: 400)
                        }
                    }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                } label: {
                    Text("Trip Type:")
                }.frame(width: 400, height: 40)
            }.padding(.leading, 100)
            
            HStack {
                LabeledContent {
                    Picker("", selection: $selectedSurveySection) {
                        Text("All Survey Sections").tag("")
                        ForEach(surveySectionList, id: \.code) { section in
                            Text(section.name)
                                .frame(width: 400)
                        }
                    }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                } label: {
                    Text("Survey Section:")
                }.frame(width: 400, height: 40)

            }.padding(.leading, 100)
            
            ChartButton(onChartButtonTapped: {
                // fishList = q.fetchFishWithLengthAndWeight(context: modelContext)
                fishList = q.fetchFishWithLengthAndWeight(context: modelContext, tripType: selectedTripType, watershed: selectedWatershed, surveySection: selectedSurveySection )
                print("fishList count: \(fishList.count)")
                isChartReady = true
            })
            .padding(.bottom, 20)

            if isChartReady {
                GroupBox {
                    Text("Size / Weight Model")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.bottom, 4)
                    Chart(fishList) { fish in
                        PointMark(
                            x: .value("Length", fish.length),
                            y: .value("Weight", fish.weight)
                        )
                        .position(by: .value("Species", fish.species))
                        .foregroundStyle(fish.species == "LL" ? .orange : .green)
                        .symbolSize(CGSize(width: 3, height: 3)) // Adjust point size
                    }
                    .chartXAxisLabel("Fish Length (mm)")
                    .chartXAxis {
                        AxisMarks(values: .automatic) { value in
                            AxisValueLabel()
                                .font(.headline)
                                .foregroundStyle(.black)
                                .offset(x: -8)
                        }
                    }
                    .chartYAxisLabel("Fish Weight (g)")
                    .chartYAxis {
                        AxisMarks(values: .automatic) { value in
                            AxisGridLine()
                            AxisValueLabel()
                                .font(.headline)
                                .foregroundStyle(.black)
                                .offset(x: 10)
                        }
                    }
                    .frame(height: 350)
                    
                    Text("Total fish:  \(fishList.count)")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 40)
                .background(Color("AppBackground"))
                .frame(minWidth: 700, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}
