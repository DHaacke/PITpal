//
//  PopulationEstimateView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/11/25.
//

import SwiftUI
import SwiftData
import MapKit
import CoreLocation

struct PopulationEstimateView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var startDate: Date = "2024-04-01".toDate(format: "yyyy-MM-dd") // Date()
    @State private var endDate:   Date = "2024-04-30".toDate(format: "yyyy-MM-dd") // Date()
    @State private var selectedSurveySection: String = "U"
    @State private var selectedMethod: String = "SC" // "LS" for Lincolm-Petersen, "SC" for Schnabel
    
    @State private var populationEstimate: Double = 0.0
    @State private var totalMarkingRun: Int = 0
    @State private var totalRecapRun: Int = 0
    @State private var totalRecaptured: Int = 0
    @State private var filteredFish: [FishData] = []
    @State private var coordFish: [FishData] = []
    
    @State private var midPoint: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 45.39395000, longitude: -107.80418000)
    @State private var radius: Double = 3800 // meters
    @State private var mapSpan: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.8, longitudeDelta: 0.8)
    // upper 45.362514,-107.830852
    // lower 45.34681,-107.87468
    
    @State private var camera: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 45.362514, longitude: -107.830852), span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.05)))
    
    @Query(filter: #Predicate<Fish> { f in f.species == "RB" || f.species == "LL"},  sort: \Fish.species) var fishList: [Fish]
    @Query(sort: \SurveySection.name, order: .forward) var surveySectionList: [SurveySection]
    @Query(sort: \Trip.date, order: .forward) var tripList: [Trip]
    
    let q = Queries()
    
    @Namespace var mapScope
    
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
                LabeledContent {
                    Picker("", selection: $selectedMethod) {
                        Text("Lincoln-Petersen").tag("LP")
                        Text("Schnabel").tag("SC")
                    }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                } label: {
                    Text("Method:")
                }.frame(width: 400, height: 40)
            }.padding(.leading, 100)
            
            
            HStack {
                Button( action: {
                    
                    if selectedMethod == "LP" {
                        self.totalMarkingRun = fishList.filter { $0.trip?.surveySection == selectedSurveySection && $0.trip?.tripType == "M" && ($0.species == "RB" || $0.species == "LL") && ($0.date >= startDate && $0.date <= endDate) }.count
                        self.totalRecapRun   = fishList.filter { $0.trip?.surveySection == selectedSurveySection && $0.trip?.tripType == "R" && ($0.species == "RB" || $0.species == "LL") && ($0.date >= startDate && $0.date <= endDate) }.count
                        self.totalRecaptured = fishList.filter { $0.trip?.surveySection == selectedSurveySection && ($0.species == "RB" || $0.species == "LL") && ($0.date >= startDate && $0.date <= endDate) && $0.mc != 0 }.count
                        if totalRecaptured > 0 {
                            self.populationEstimate = (((Double(totalMarkingRun) * Double(totalRecapRun)) / Double(totalRecaptured)) * 3) / 13.0 // (18,800 * 3) / 13
                        } else {
                            self.populationEstimate = 0
                        }
                    } else if selectedMethod == "SC" {
                        let filteredTrips = filterTripsByDateAndSection()
                        if filteredTrips.count > 0 {
                            var capturedArray:   [Int] = []
                            var markedArray:     [Int] = []
                            var recapturedArray: [Int] = []
                            var captured    = 0
                            var marked      = 0
                            var recaptured  = 0
                            var index       = 0
                            for t in filteredTrips {
                                print("Trip: \(t.date.description)")
                                for f in t.fish {
                                    if f.species == "RB" || f.species == "LL" {
                                        if t.tripType == "M" && f.mc == 0 {
                                            captured += 1
                                            if index > 0 {
                                                marked += 1
                                            }
                                        }
                                        if t.tripType == "R" && f.mc != 0 {
                                            recaptured += 1
                                        }
                                    }
                                }
                                index += 1
                                capturedArray.append(captured)
                                markedArray.append(marked)
                                recapturedArray.append(recaptured)
                            }
                            captured   = capturedArray.reduce(0, +)
                            marked     = markedArray.reduce(0, +)
                            recaptured = capturedArray.reduce(0, +)
                            
                            self.populationEstimate = (Double(marked) * Double(captured)) / Double(recaptured)
                        }
                    }
                    self.camera = .region(MKCoordinateRegion(center: self.midPoint, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.05)))
                }) {
                    Text("Estimate")
                        .font(.system(size: 24, weight: .bold))
                        .frame(maxWidth: 160, minHeight: 36)
                        .foregroundColor(Color("TextForegroundWhite"))
                        .shadow(color: Color(.black), radius: 2, x: 1, y: 2)
                        .cornerRadius(10)
                }
                .padding(.bottom, 10)
                .buttonStyle(.borderedProminent)
            }
            if self.populationEstimate > 0 {
                HStack {
                    Spacer()
                    if populationEstimate > 0 {
                        Text("Estimated Population: \(Int(populationEstimate)) fish per mile for \(q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: selectedSurveySection)) section")
                            .font(.system(size: 20, weight: .medium))
                    } else {
                        Text("Population could not be determined.")
                    }
                    Spacer()
                }
                
                VStack {
                    MapReader { mapProxy in
                        Map(position: $camera, bounds: .none, interactionModes: .all, selection: .constant(nil)) {
                            MapCircle(center: midPoint, radius: self.radius)
                                .stroke(.blue.opacity(0.8), style: StrokeStyle(lineWidth: 1))
                                .mapOverlayLevel(level: .aboveRoads)
                                .foregroundStyle(.blue.opacity(0.1))
                            ForEach(coordFish, id: \.self) { fish in
                                Annotation("", coordinate: CLLocationCoordinate2D(latitude: fish.lat, longitude: fish.lon)) {
                                    Image(systemName: "fish.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 10, height: 10)
                                        .foregroundColor(
                                            fish.species == "RB" ? Color("TroutGreen") : Color("TroutYellow")
                                        )
                                }
                            }
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
        
        .onChange(of: selectedSurveySection) {
            coordFish.removeAll()
            setMidPoint()
            updateCameraPosition()
        }
        
        .onAppear {
            var list : [FishData] = []
            for fish in fishList {
                list.append(fish.deepCopy())
            }
            filteredFish = list
            setMidPoint()
        }
    }
    
    func filterTripsByDateAndSection() -> [TripData] {
        let trips: [Trip] = tripList.filter { $0.date >= startDate && $0.date <= endDate && $0.surveySection == selectedSurveySection }
        var filteredTrips : [TripData] = []
        for t in trips {
            filteredTrips.append(t.deepCopy())
        }
        return filteredTrips
    }
    
    func filterFishByCoordinate() -> [FishData] {
        var list: [FishData] = []
        let filtered: [FishData] = filteredFish.filter { ($0.trip?.surveySection == selectedSurveySection && $0.species == "RB" || $0.species == "LL") && ($0.date >= startDate && $0.date <= endDate) }
        var coords: [CLLocationCoordinate2D] = []
        for fish in filtered {
            let coord = CLLocationCoordinate2D(latitude: fish.lat, longitude: fish.lon)
            if coord.latitude != 0.0 && coord.longitude != 0.0 {
                if !coords.contains(coord) {
                    coords.append(coord)
                    list.append(fish)
                }
            }
        }
        print("Filtered fish count for section \(selectedSurveySection): \(list.count)")
        return list
    }
    
    func setMidPoint() {
        coordFish = filterFishByCoordinate()
        let ss = q.fetchSurveySectionFromCode(context: modelContext, code: selectedSurveySection)
        let upperTop = CLLocationCoordinate2D(latitude: ss.latUp, longitude: ss.lonUp)
        let upperBottom: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: ss.latDown, longitude: ss.lonDown)
        //                    let upperTop:    CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 45.39395000, longitude: -107.80418000)
        //                    let upperBottom: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 45.34681000, longitude: -107.87468000)
        self.midPoint = upperTop.midLocation(to: upperBottom)
        self.radius   = ss.radius
        print("Section \(ss.name),  Midpoint: \(midPoint.latitude), \(midPoint.longitude) with radius: \(radius) meters")
    }
    
    func updateCameraPosition() {
        let userRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: midPoint.latitude,
                longitude: midPoint.longitude),
            span: mapSpan
        )
        withAnimation {
            camera = .region(userRegion)
        }
    }
    
}

#Preview {
    PopulationEstimateView()
}

/*
 -- upper  45.39395000,-107.80418000,45.34681000,-107.874680
 -- lower  45.52620000,-107.72570000,45.47820000,-107.736600
*/

