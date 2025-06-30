//
//  LengthChartView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/29/25.
//

import Foundation
import SwiftUI
import SwiftData


struct LengthChartView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var path: [String]
    
    @State private var startDate: Date = Date()
    @State private var endDate:   Date = Date()
    @State private var selectedWatershed: String = ""
    @State private var selectedTripType: String = ""
    @State private var selectedSurveySection: String = ""
    @State private var selectedSpecies: String = ""
    @State private var selectedMinLength: Int = 0
    @State private var selectedMaxLength: Int = 0
    
    @State private var filteredTrips: [Trip] = []
    @State private var isCharting: Bool = false
    @State private var isShowingChartError: Bool = false
    @State private var chartMessage: String = ""
    
    @AppStorage("tripTripType") private var tripTripType: String = "M"
    @AppStorage("tripSurveySection") private var tripSurveySection: String = "U"
    @AppStorage("tripWatershed") private var tripWatershed: String = "BHR"
    
    @AppStorage("lengthMin") private var lengthMin: Int = 0
    @AppStorage("lengthMax") private var lengthMax: Int = 2000
    @AppStorage("uomFishLength") private var uomFishLength: String = "mm"
    @AppStorage("uomFishWeight") private var uomFishWeight: String = "gm"
    
    @Query(filter: #Predicate<Species> { sp in sp.active == "Y"},  sort: \Species.name) var speciesList: [Species]
    @Query(sort: \TripType.name, order: .forward) var tripTypeList: [TripType]
    @Query(sort: \SurveySection.name, order: .forward) var surveySectionList: [SurveySection]
    @Query(sort: \Watershed.name, order: .forward) var watershedList: [Watershed]
    @Query(sort: \Trip.date, order: .forward) var tripList: [Trip]
    
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
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
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
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
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
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
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
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                    } label: {
                        Text("Species:")
                    }.frame(width: 400, height: 40)
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
                }.padding(.bottom, 50)
                
                HStack(alignment: .center) {
                    Spacer()
                    ChartButton(onChartButtonTapped: {
                        // process chart
                    })
                    Spacer()
                }
                
                if isCharting {
                    HStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                Spacer()
                Text(chartMessage)
                    .foregroundColor(isShowingChartError ? .red : Color("TextForegroundWhite"))
            }
            .padding(.horizontal, 100)
        }
        
        .padding(.horizontal, 20)
        .background(Color("AppBackground"))
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        
        
        .onChange(of: startDate) {
            var dateComponents = DateComponents()
            dateComponents.month = 3 // Add 3 months
            let calendar = Calendar.current
            if let futureDate = calendar.date(byAdding: dateComponents, to: self.startDate) {
                self.endDate = futureDate
            } else {
                print("Error calculating future date.")
            }
        }
        .onAppear {
            print("LengthChartView appeared")
            
            selectedMinLength = lengthMin
            selectedMaxLength = lengthMax
            
            selectedWatershed = tripWatershed
            selectedTripType  = tripTripType
            selectedSurveySection = tripSurveySection
        }
    }

    
    func filterTrips() -> [Trip] {
        // Filter trips based on selected criteria
        var filteredTrips : [Trip] = tripList

        filteredTrips = tripList.filter { trip in (startDate.millisecondsSince1970...endDate.millisecondsSince1970).contains(trip.date.millisecondsSince1970) }

        if !selectedWatershed.isEmpty {
            filteredTrips = filteredTrips.filter { $0.watershed == selectedWatershed }
        }
        
        if !selectedTripType.isEmpty {
            filteredTrips = filteredTrips.filter { $0.tripType == selectedTripType }
        }

        if !selectedSurveySection.isEmpty {
            filteredTrips = filteredTrips.filter { $0.surveySection == selectedSurveySection }
        }

        if !selectedSpecies.isEmpty {
            var filteredFish : [Fish] = []
            for trip in filteredTrips {
                filteredFish = trip.fish.filter { $0.species == selectedSpecies }
                trip.fish = filteredFish
            }
        }

        return filteredTrips
    }
    
    
}

#Preview {
    LengthChartView(path: .constant([]))
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}

