//
//  PopulationEstimateView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/11/25.
//

import SwiftUI
import SwiftData
import MapKit

struct PopulationEstimateView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var startDate: Date = "2024-04-01".toDate(format: "yyyy-MM-dd") // Date()
    @State private var endDate:   Date = "2024-04-30".toDate(format: "yyyy-MM-dd") // Date()
    @State private var selectedSurveySection: String = "U"
    
    @State private var populationEstimate: Double = 0.0
    @State private var totalMarkingRun: Int = 0
    @State private var totalRecapRun: Int = 0
    @State private var totalRecaptured: Int = 0

    // upper 45.362514,-107.830852
    // lower 45.34681,-107.87468

    @State private var camera: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.362514, longitude: -107.830852), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)))
    
    @Query(filter: #Predicate<Fish> { f in f.species == "RB" || f.species == "LL"},  sort: \Fish.species) var fishList: [Fish]
    @Query(sort: \SurveySection.name, order: .forward) var surveySectionList: [SurveySection]
    
    @Namespace var mapScope
    
    let q = Queries()
    
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
                .padding(.top, 8)
                .padding(.horizontal, 100)
            
            HStack {
                LabeledContent {
                    Picker("", selection: $selectedSurveySection) {
                        ForEach(surveySectionList, id: \.code) { section in
                            Text(section.name)
                                .frame(width: 400)
                        }
                    }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                } label: {
                    Text("Survey Section:")
                }.frame(width: 400, height: 40)
            }.padding(.leading, 100)
            
            
            HStack {
                Button(action: {
                    self.totalMarkingRun = fishList.filter { ($0.trip?.surveySection == selectedSurveySection && $0.trip?.tripType == "M" && $0.species == "RB" || $0.species == "LL") && ($0.date >= startDate && $0.date <= endDate) }.count
                    self.totalRecapRun   = fishList.filter { ($0.trip?.surveySection == selectedSurveySection && $0.trip?.tripType == "R" && $0.species == "RB" || $0.species == "LL") && ($0.date >= startDate && $0.date <= endDate) }.count
                    self.totalRecaptured = fishList.filter { ($0.trip?.surveySection == selectedSurveySection && $0.species == "RB" || $0.species == "LL") && ($0.date >= startDate && $0.date <= endDate) && $0.mc != 0 }.count
                    if totalRecaptured > 0 {
                        self.populationEstimate = (((Double(totalMarkingRun) * Double(totalRecapRun)) / Double(totalRecaptured)) * 3) / 13.0 // (18,800 * 3) / 13
                        // print("Estimated Population: \(populationEstimate) fish per mile for \(q.fetchNameFromCode(context: modelContext, model: SurveySection, code: selectedSurveySection))")
                    }
                }, label: {
                    Text("Estimate")
                        .font(.system(size: 24, weight: .medium))
                        .frame(width: 120, height: 38)
                        .foregroundColor(.white)
                        .background(Color("ButtonBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                })
                    .padding(.bottom, 30)
            }
            if self.populationEstimate > 0 {
                HStack {
                    Spacer()
                    Text("Estimated Population: \(Int(populationEstimate)) fish per mile for \(q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: selectedSurveySection)) section")
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                }
            
                VStack {
                    MapReader { mapProxy in
                        Map(position: $camera, bounds: .none, interactionModes: .all, selection: .constant(nil)) {
//                            ForEach(fishList, id: \.self.id) { fish in
//                                Annotation(coordinate: CLLocationCoordinate2D(latitude: fish.lat, longitude: fish.lon), anchor: .center) {
//                                    if fish.species == "RB" {
//                                        Image("fish.fill")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 6, height: 6)
//                                            .tint(Color("Green"))
//                                    } else {
//                                        Image("fish.fill")
//                                            .resizable()
//                                            .scaledToFit()
//                                            .frame(width: 6, height: 6)
//                                            .tint(Color("Yellow"))
//                                    }
//                                }
//                            }
                        }
                        .mapScope(mapScope)
                        .edgesIgnoringSafeArea(.all)
                        .mapStyle(.standard(elevation: .automatic)) // .hybrid(elevation: .automatic)
                    }
                    Spacer()
                }
            } else {
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

#Preview {
    PopulationEstimateView()
}
