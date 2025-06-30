//
//  LengthChartView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/29/25.
//

import Foundation
import SwiftUI
import SwiftData
import Charts



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
    @State private var title: String = "Fish Size Distribution"
    
    @State private var filteredTrips: [Trip] = []
    @State private var filteredFish: [Fish] = []
    @State private var isChartReady: Bool = false
    
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
                            Text("<Choose>").tag("")
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
                        filteredFish = filterFish()
                        print("Filtered Fish Found: \(filteredFish.count)")
                        self.isChartReady = filteredFish.count > 0 ? true : false
                    })
                    Spacer()
                }
                if isChartReady {
                    VStack {
                        LengthBarChartView(filteredFish: $filteredFish, title: $title, species: $selectedSpecies)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                    }
                }
                Spacer()
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

    
    func filterFish() -> [Fish] {
        // Filter fish based on selected criteria
        var filteredTrips : [Trip] = tripList
        var filteredFish : [Fish] = []

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
            for trip in filteredTrips {
                filteredFish = trip.fish.filter { $0.species == selectedSpecies && $0.length >= Double(selectedMinLength) && Double($0.length) <= Double(selectedMaxLength) }
                trip.fish = filteredFish
            }
        }
        return filteredFish
    }
}

#Preview {
    LengthChartView(path: .constant([]))
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}

struct LengthBarChartView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var filteredFish: [Fish]
    @Binding var title: String
    @Binding var species: String
    
    @State private var fishData: [FishData] = []
    
    var body: some View {
        VStack {
            Chart(fishData, id: \.id) { data in
                BarMark(
                    x: .value("Size", data.sizeGroup),
                    y: .value("Count", data.count),
                    width: 30                )
                .foregroundStyle(.green)
                .annotation(position: .overlay) {
                    Rectangle()
                        .stroke(Color.white, lineWidth: 0.75)
                        .padding(-4)
                }
                .cornerRadius(4)
            }
            .padding(.horizontal, 20)
            .chartXScale(domain: [6, 24])
            // .chartYScale(domain: [minStockPrice ?? 0, maxStockPrice ?? 0])
            .chartXAxis {
                AxisMarks(values: [6, 8, 10, 12, 14, 16, 18, 20]) { value in
                    AxisValueLabel()
                        .foregroundStyle(.white)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel()
                        .foregroundStyle(.white)
                        .offset(x: 4)
                }
            }
            Text(title)
                .font(.system(size: 12, weight: .light, design: .default))
        }
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 200, maxHeight: 350)

        .padding(.trailing, 12)
        .background(Color.black)
        .onAppear {
            fishData = buildMatrix(species: species)
        }
    }
    
    func buildMatrix(species: String) -> [FishData] {
        DispatchQueue.main.async {
            fishData.removeAll()
            fishData.append(FishData(id:  1,  sizeGroup:  6,  count: filteredFish.filter { $0.length <= 125}.count, species: species))
            fishData.append(FishData(id:  2,  sizeGroup:  8,  count: filteredFish.filter { $0.length >  125 && $0.length <= 203 }.count ,species: species))
            fishData.append(FishData(id:  3,  sizeGroup: 10,  count: filteredFish.filter { $0.length >  203 && $0.length <= 253 }.count ,species: species))
            fishData.append(FishData(id:  4,  sizeGroup: 12,  count: filteredFish.filter { $0.length >  253 && $0.length <= 305 }.count ,species: species))
            fishData.append(FishData(id:  5,  sizeGroup: 14,  count: filteredFish.filter { $0.length >  305 && $0.length <= 355 }.count ,species: species))
            fishData.append(FishData(id:  6,  sizeGroup: 16,  count: filteredFish.filter { $0.length >  355 && $0.length <= 406 }.count ,species: species))
            fishData.append(FishData(id:  7,  sizeGroup: 18,  count: filteredFish.filter { $0.length >  406 && $0.length <= 458 }.count ,species: species))
            fishData.append(FishData(id:  8,  sizeGroup: 20,  count: filteredFish.filter { $0.length >  458 }.count, species: species))
        }
        return fishData
    }
}
    
    /*
     struct FishData: Identifiable {
     var id: Int
     var sizeGroup: Int
     var count: Int
     var species: String
     }
    */
