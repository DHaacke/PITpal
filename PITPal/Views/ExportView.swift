//
//  ExportView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/28/25.
//

import Foundation
import SwiftUI
import SwiftData

struct ExportView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]
    
    @State private var startDate: Date = Date()
    @State private var endDate:   Date = Date()
    @State private var selectedWatershed: String = ""
    @State private var selectedTripType: String = ""
    @State private var selectedSurveySection: String = ""
    @State private var selectedSpecies: String = ""
    @State private var selectedMinWeight: Int = 0
    @State private var selectedMaxWeight: Int = 0
    @State private var selectedMinLength: Int = 0
    @State private var selectedMaxLength: Int = 0
    
    @AppStorage("tripTripType") private var tripTripType: String = "M"
    @AppStorage("tripSurveySection") private var tripSurveySection: String = "U"
    @AppStorage("tripWatershed") private var tripWatershed: String = "BHR"
    
    @AppStorage("lengthMin") private var lengthMin: Int = 0
    @AppStorage("lengthMax") private var lengthMax: Int = 2000
    @AppStorage("weightMin") private var weightMin: Int = 0
    @AppStorage("weightMax") private var weightMax: Int = 1000
    @AppStorage("uomFishLength") private var uomFishLength: String = "mm"
    @AppStorage("uomFishWeight") private var uomFishWeight: String = "gm"
    
    @Query(filter: #Predicate<Species> { sp in sp.active == "Y"},  sort: \Species.name) var speciesList: [Species]
    // @Query(sort: \Species.name, order: .forward) var speciesList: [Species]
    @Query(sort: \TripType.name, order: .forward) var tripTypeList: [TripType]
    @Query(sort: \SurveySection.name, order: .forward) var surveySectionList: [SurveySection]
    @Query(sort: \Watershed.name, order: .forward) var watershedList: [Watershed]
    
    var body: some View {
        VStack {
            HStack {
                DatePicker(
                    "Start Date:",
                    selection: $startDate,
                    displayedComponents: [.date]
                ).datePickerStyle(.compact).frame(width: 250)
                Spacer()
                DatePicker(
                    "End Date:",
                    selection: $endDate,
                    displayedComponents: [.date]
                ).datePickerStyle(.compact).frame(width: 250)
            }
            .padding(.top, 40)
            .padding(.horizontal, 100)
            .padding(.bottom, 40)
            
            VStack(alignment: .leading) {
                
                HStack() {
                    LabeledContent {
                        Picker("", selection: $selectedWatershed) {
                            Text("All Waters").tag("")
                            ForEach(watershedList, id: \.code) { water in
                                Text(water.name)
                                    .frame(width: 400)
                            }
                        }.tint(Color("TextForegroundWhite"))
                    } label: {
                        Text("Watershed:")
                    }.frame(width: 400, height: 40)
                    Spacer()
                }
                
                HStack {
                    LabeledContent {
                        Picker("", selection: $selectedTripType) {
                            Text("All Trip Types").tag("")
                            ForEach(tripTypeList, id: \.code) { type in
                                Text(type.name)
                                    .frame(width: 400)
                            }
                        }.tint(Color("TextForegroundWhite"))
                    } label: {
                        Text("Trip Type:")
                    }.frame(width: 400, height: 40)
                }
                
                HStack {
                    LabeledContent {
                        Picker("", selection: $selectedSurveySection) {
                            Text("All Survey Sections").tag("")
                            ForEach(surveySectionList, id: \.code) { section in
                                Text(section.name)
                                    .frame(width: 400)
                            }
                        }.tint(Color("TextForegroundWhite"))
                    } label: {
                        Text("Survey Section:")
                    }.frame(width: 400, height: 40)
                }
                
                HStack {
                    LabeledContent {
                        Picker("", selection: $selectedSpecies) {
                            Text("All Species").tag("")
                            ForEach(speciesList, id: \.code) { species in
                                Text(species.name)
                                    .frame(width: 400)
                            }
                        }.tint(Color("TextForegroundWhite"))
                    } label: {
                        Text("Species:")
                    }.frame(width: 400, height: 40)
                }
                
                HStack {
                    LabeledContent {
                        TextField("", value: $selectedMinWeight, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishWeight).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Min Weight")
                    }.frame(width: 250).padding(.trailing, 60)
                    
                    LabeledContent {
                        TextField("", value: $selectedMaxWeight, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishWeight).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Max Weight")
                    }.frame(width: 250)
                }
                
                HStack {
                    LabeledContent {
                        TextField("", value: $selectedMinLength, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Min Length")
                    }.frame(width: 250).padding(.trailing, 60)
                    
                    LabeledContent {
                        TextField("", value: $selectedMaxLength, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Max Length")
                    }.frame(width: 250)
                }.padding(.bottom, 180)
                
                HStack(alignment: .center) {
                    Spacer()
                    ExportButton(onExportButtonTapped: {
                        print("Export Button Tapped")
                    })
                    Spacer()
                }
                Spacer()
            }
            .padding(.horizontal, 100)
        }
        .padding(.horizontal, 20)
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("AppBackground"))
        .onChange(of: startDate) {
            var dateComponents = DateComponents()
            dateComponents.month = 3 // Add 3 months
            let calendar = Calendar.current
            if let futureDate = calendar.date(byAdding: dateComponents, to: self.startDate) {
                print("endDate after adding 3 months: \(endDate)")
                self.endDate = futureDate
            } else {
                print("Error calculating future date.")
            }
        }
        .onAppear {
            selectedMinWeight = weightMin
            selectedMaxWeight = weightMax
            selectedMinLength = lengthMin
            selectedMaxLength = lengthMax
            
            selectedWatershed = tripWatershed
            selectedTripType  = tripTripType
            selectedSurveySection = tripSurveySection
          
        }
    }
}

#Preview {
    ExportView(path: .constant([]))
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}
