//
//  PopulationEstimateView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/11/25.
//

import Foundation
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
//    @State private var eventList: [EventSample] = []
    
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
                        Text("Lincoln-Petersen (Closed System)").tag("LP")
                        Text("Schnabel (Open system)").tag("SC")
                        Text("Jolly-Seber (Open system)").tag("JS")
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
                        // Note: The estimate is for a 4.4 mile section, so we multiply by 2.75 to get ~ 13 miles, then divide by 13 to get the estimate per mile.
                    } else if selectedMethod == "SC" {
                        let filteredTrips = filterTripsByDateAndSection()
                        if filteredTrips.count > 0 {
                            var capturedArray:   [Int] = []
                            var markedArray:     [Int] = []
                            var recapturedArray: [Int] = []
                            var captured    = 0
                            var marked      = 0
                            var markedMinus = 0
                            var recaptured  = 0
                            var index       = 0
                            for t in filteredTrips {
                                print("Trip: \(t.date.description) - \(t.tripType) - \(t.surveySection)")
                                for f in t.fish {
                                    if f.species == "RB" || f.species == "LL" {
                                        if t.tripType == "M" && f.mc == 0 {
                                            captured += 1
                                            marked   += 1
                                            if index == 0 {
                                              markedMinus += 1
                                            }
                                        } else if t.tripType == "R" && f.mc > 0 {
                                            recaptured += 1
                                        }
                                    }
                                }
                                index += 1
                                capturedArray.append(captured)
                                markedArray.append(marked)
                                recapturedArray.append(recaptured)
                                
                                captured    = 0
                                marked      = 0
                                recaptured  = 0
                            }
                          
                            captured   = capturedArray.reduce(0, +)
                            marked     = markedArray.reduce(0, +)
                            recaptured = recapturedArray.reduce(0, +)
                            
                            self.populationEstimate = (((Double(captured) * Double(marked - markedMinus)) / Double(recaptured)) * 2.75) / 13  // (23,231.1 * 2.75) / 13
                            // Note: The estimate is for a 4.4 mile section, so we multiply by 2.75 to get ~ 13 miles, then divide by 13 to get the estimate per mile.
                        }
                    } else if selectedMethod == "JS" {
//                        struct SamplingEvent {
//                            var time: Int     // Sampling event number (e.g., 1, 2, 3)
//                            var n: Double     // Number of individuals captured at time t
//                            var m: Double     // Number of marked individuals recaptured at time t
//                            var R: Double     // Number of individuals released at time t
//                            var z: Double     // Number of individuals captured before and after t, but not at t
//                            var r: Double     // Number of individuals released at t and recaptured later
//                        }
                        var eventList: [EventSample] = []
                        var capturedTotals: [Double] = []
                        
                        let filteredTrips = filterTripsByDateAndSection()
                        for t in filteredTrips {
                            var count = 0.0
                            for f in t.fish {
                                if f.species == "RB" || f.species == "LL" {
                                    count += 1
                                }
                            }
                            capturedTotals.append(count)
                        }
                        let totaln : Double = capturedTotals.reduce(0, +)
                        
                        var index = 0
                        for t in filteredTrips {
                            print("Trip: \(t.date.description) - \(t.tripType) - \(t.surveySection) - Fish: \(t.fish.count)")
                            var n = 0.0
                            var m = 0.0
                            var R = 0.0
                            var r = 0.0
                            var z = 0.0
                            for f in t.fish {
                                if f.species == "RB" || f.species == "LL" {
                                    n += 1.0
                                    m += f.mc > 0 ? 1.0 : 0.0
                                    R += 1.0
                                    r += f.mc > 0 ? 1.0 : 0.0
                                }
                            }
                            z = totaln - n
                            let event = EventSample(time: index + 1, n: n, m: m, R: R, z: z, r: r)
                            print("\(event)")
                            eventList.append(event)
                            index += 1
                        }
                        
                        
                        
                        runJollySeberMultipleEvents(events: eventList)
                        
                    }
                    self.camera = .region(MKCoordinateRegion(center: self.midPoint, span: MKCoordinateSpan(latitudeDelta: 0.09, longitudeDelta: 0.05)))
                }) {
                    Text("Estimate")
                }
                .modifier(ActionButton())
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
            setStartEndDates()
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
    
    func setStartEndDates() {
        let ss = q.fetchSurveySectionFromCode(context: modelContext, code: selectedSurveySection)
        startDate = ss.startDate
        endDate   = ss.endDate
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
    
    func runJollySeberMultipleEvents(events: [EventSample]) {
        // Initialize Jolly-Seber model
        let js = JollySeber()
        
        // Process events to compute Jolly-Seber estimates
        let results = js.processEvents(events)
        
        // Print results in a formatted way
        print("Jolly-Seber Estimates for Fish Population:")
        for result in results {
            print("\nTime \(result.time):")
            if let M = result.M {
                print("  Marked individuals (M_\(result.time)): \(String(format: "%.2f", M))")
            }
            if let N = result.N {
                print("  Population size (N_\(result.time)): \(String(format: "%.2f", N))")
            }
            if let p = result.p {
                print("  Capture probability (p_\(result.time)): \(String(format: "%.3f", p))")
            }
            if let phi = result.phi {
                print("  Survival probability (phi_\(result.time)): \(String(format: "%.3f", phi))")
            }
            if let B = result.B {
                print("  Recruitment (B_\(result.time)): \(String(format: "%.2f", B))")
            }
        }
    }
}



// Structure to store Jolly-Seber results for a single time point
struct JollySeberResult {
    var time: Int      // Sampling event number
    var M: Double?     // Estimated number of marked individuals in population
    var N: Double?     // Estimated population size
    var p: Double?     // Capture probability
    var phi: Double?   // Survival probability to next time point
    var B: Double?     // Recruitment (new individuals) to next time point
}

struct EventSample {
    var time: Int  // Sampling event number (e.g., 1, 2, 3)
    var n: Double  // Number of individuals captured at time t
    var m: Double  // Number of marked individuals recaptured at time t
    var R: Double  // Number of individuals released at time t
    var z: Double  // Number of individuals captured before and after t, but not at t
    var r: Double  // Number of individuals released at t and recaptured later
    
    init(time: Int = 0, n: Double = 0, m: Double = 0, R: Double = 0, z: Double = 0, r: Double = 0) {
        self.time = time
        self.n = n
        self.m = m
        self.R = R
        self.z = z
        self.r = r
    }
}


struct JollySeber {
    // MARK: Calculate Marked Population (M_t)
    func calculateMarkedPopulation(event: EventSample) throws -> Double {
        // Check for division by zero to avoid invalid calculations
        guard event.r + 1 != 0 else {
            throw NSError(domain: "JollySeberError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Division by zero: r + 1 cannot be zero at time \(event.time)."])
        }
        // Calculate M_t using the Jolly-Seber formula
        let M_t = (event.z * (event.R + 1)) / (event.r + 1) + event.m
        return Double(M_t)
    }
    
    // MARK: Calculate Population Size (N_t)
    func calculatePopulationSize(M: Double, n: Double, m: Double, time: Int) throws -> Double {
        // Ensure m_t is not zero to avoid division by zero
        guard m != 0 else {
            throw NSError(domain: "JollySeberError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Division by zero: m cannot be zero at time \(time)."])
        }
        // Compute population size
        return (M * n) / m
    }
    
    // MARK: Calculate Capture Probability (p_t)
    func calculateCaptureProbability(m: Double, M: Double, time: Int) throws -> Double {
        // Ensure M_t is not zero
        guard M != 0 else {
            throw NSError(domain: "JollySeberError", code: 3, userInfo: [NSLocalizedDescriptionKey: "Division by zero: M cannot be zero at time \(time)."])
        }
        // Compute capture probability
        return m / M
    }
    
    func calculateSurvivalProbability(M_tPlus1: Double, M_t: Double, m_t: Double, R_t: Double, time: Int) throws -> Double {
        // Ensure denominator is not zero
        guard M_t - m_t + R_t != 0 else {
            throw NSError(domain: "JollySeberError", code: 4, userInfo: [NSLocalizedDescriptionKey: "Division by zero: denominator cannot be zero at time \(time)."])
        }
        // Compute survival probability
        return M_tPlus1 / (M_t - m_t + R_t)
    }
    
    // MARK: Calculate Recruitment (B_t)
    func calculateRecruitment(N_tPlus1: Double, phi_t: Double, N_t: Double, n_t: Double, R_t: Double, time: Int) throws -> Double {
        // Compute recruitment
        return N_tPlus1 - phi_t * (N_t - n_t + R_t)
    }
    
    // MARK: Process Multiple Sampling Events
    // Iterates through events to compute M_t, N_t, p_t, phi_t, and B_t
    func processEvents(_ events: [EventSample]) -> [JollySeberResult] {
        var results: [JollySeberResult] = []
        // Loop through each sampling event
        for i in 0..<events.count {
            let event = events[i]
            var result = JollySeberResult(time: event.time, M: nil, N: nil, p: nil, phi: nil, B: nil)
            
            do {
                // Step 1: Calculate M_t (marked individuals)
                let M_t: Double
                if i == 0 {
                    // First event has no marked individuals yet
                    M_t = 0
                    result.M = M_t
                } else {
                    // Compute M_t for subsequent events
                    M_t = try calculateMarkedPopulation(event: event)
                    result.M = M_t
                    
                    // Step 2: Calculate N_t (population size)
                    let N_t = try calculatePopulationSize(M: M_t, n: event.n, m: event.m, time: event.time)
                    result.N = N_t
                    
                    // Step 3: Calculate p_t (capture probability)
                    let p_t = try calculateCaptureProbability(m: event.m, M: M_t, time: event.time)
                    result.p = p_t
                }
                
                // Step 4: Calculate phi_t (survival probability) for all but last event
                if i < events.count - 1 {
                    let nextEvent = events[i + 1]
                    let M_tPlus1 = try calculateMarkedPopulation(event: nextEvent)
                    let phi_t = try calculateSurvivalProbability(
                        M_tPlus1: M_tPlus1,
                        M_t: M_t,
                        m_t: event.m,
                        R_t: event.R,
                        time: event.time
                    )
                    result.phi = phi_t
                }
                
                // Step 5: Calculate B_t (recruitment) for all but last event
                if i < events.count - 1 && result.N != nil && result.phi != nil {
                    let nextEvent = events[i + 1]
                    let M_tPlus1 = try calculateMarkedPopulation(event: nextEvent)
                    let N_tPlus1 = try calculatePopulationSize(M: M_tPlus1, n: nextEvent.n, m: nextEvent.m, time: nextEvent.time)
                    let B_t = try calculateRecruitment(
                        N_tPlus1: N_tPlus1,
                        phi_t: result.phi!,
                        N_t: result.N!,
                        n_t: event.n,
                        R_t: event.R,
                        time: event.time
                    )
                    result.B = B_t
                }
                
            } catch {
                // Log errors but continue processing other events
                print("Error at time \(event.time): \(error.localizedDescription)")
            }
            // Store results for this time point
            results.append(result)
        }
        return results
    }
}


#Preview {
    PopulationEstimateView()
}

/*
 -- upper  45.39395000,-107.80418000,45.34681000,-107.874680
 -- lower  45.52620000,-107.72570000,45.47820000,-107.736600
*/

