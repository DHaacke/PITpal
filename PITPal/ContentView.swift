//
//  ContentView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    
    @AppStorage("darkMode") private var darkMode: Bool = false
    
    @State private var path = [String]()
    
    // TODO, these are here to help populate the database
    @Query(sort: \Trip.date) var tripList: [Trip]
    @Query(sort: \Species.code) var speciesList: [Species]
    @Query(sort: \SurveySection.code) var surveySections: [SurveySection]
    @Query(sort: \Fish.pitTag) var fishList: [Fish]
    
    var body: some View {
        
//        MapView()
//            .environment(locationsHandler)
        NavigationStack(path: $path) {
            VStack {
                MainMenuView(path: $path)
                    .environment(locationsHandler)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                    .navigationTitle("Main Menu")
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationDestination(for: String.self) { navigation in
                if navigation == K.MAINMENU {
                    MainMenuView(path: $path)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationTitle("Main Menu")
                        .navigationBarTitleDisplayMode(.inline)
                }
                else if navigation == K.SETTINGS {
                    SettingsView(path: $path)
                        .tint(Color("AccentColor"))
                        .navigationBarBackButtonHidden(false)
                        .navigationBarHidden(false)
                        .navigationTitle("Settings").foregroundStyle(Color("TextForegroundWhite"))
                        .navigationBarTitleDisplayMode(.inline)
                }
                else if navigation == K.TAG {
                    TagView(path: $path)
                        .tint(Color("AccentColor"))
                        .navigationBarBackButtonHidden(false)
                        .navigationBarHidden(false)
                        .navigationTitle("Tag / Recap").foregroundStyle(Color("TextForegroundWhite"))
                        .navigationBarTitleDisplayMode(.inline)
                }
                else if navigation == K.EXPORT {
                    ExportView(path: $path)
                        .tint(Color("AccentColor"))
                        .navigationBarBackButtonHidden(false)
                        .navigationBarHidden(false)
                        .navigationTitle("Export Data").foregroundStyle(Color("TextForegroundWhite"))
                        .navigationBarTitleDisplayMode(.inline)
                }
                else if navigation == K.LENGTH_CHART {
                    LengthChartView(path: $path)
                        .tint(Color("AccentColor"))
                        .navigationBarBackButtonHidden(false)
                        .navigationBarHidden(false)
                        .navigationTitle("Length Chart").foregroundStyle(Color("TextForegroundWhite"))
                        .navigationBarTitleDisplayMode(.inline)
                }
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("CardBackground"))
        .preferredColorScheme(darkMode == true ? .dark : .light)
        .onChange(of: path) { oldPath, newPath in
            print("Path changed: \(newPath)")
        }
        .task {
            if jsonManager.isConfigLoaded {
                await MainActor.run {
                    try! modelContext.transaction {
                        
                        for species in speciesList {
                            print("Deleting \(species.name)")
                            modelContext.delete(species)
                        }
                        for species in jsonManager.config.species {
                            print("Adding \(species.name)")
                            modelContext.insert(Species(
                                code: species.code,
                                name: species.name,
                                imageName: species.imageName,
                                color: species.color,
                                active: species.active
                            ))
                        }

                        for surveySection in surveySections {
                            print("Deleting \(surveySection.name)")
                            modelContext.delete(surveySection)
                        }
                        for surveySection in jsonManager.config.surveySection {
                            print("Adding \(surveySection.name)")
                            let surveySection = SurveySection(
                                code: surveySection.code,
                                name: surveySection.name,
                                color: surveySection.color,
                                latDown: surveySection.latDown,
                                lonDown: surveySection.lonDown,
                                latUp: surveySection.latUp,
                                lonUp: surveySection.lonUp,
                                radius: surveySection.radius
                            )
                            modelContext.insert(surveySection)
                        }
                        
                        for gender in jsonManager.config.gender {
                            print("Adding \(gender.name)")
                            let gender = Gender(
                                code: gender.code,
                                name: gender.name,
                                color: gender.color
                            )
                            modelContext.insert(gender)
                        }
                        
                        for watershed in jsonManager.config.watershed {
                            print("Adding \(watershed.name)")
                            let watershed = Watershed(
                                code: watershed.code,
                                name: watershed.name,
                                geofence: [],
                                poly: []
                            )
                            modelContext.insert(watershed)
                        }
                        
                        for tripType in jsonManager.config.tripType {
                            print("Adding \(tripType.name)")
                            modelContext.insert(TripType(
                                code: tripType.code,
                                name: tripType.name,
                                active: tripType.active
                            ))
                        }
                        
                        
                        for trip in tripList {
                            print("Deleting \(trip.date.formatted(date: .numeric, time: .omitted))")
                            modelContext.delete(trip)
                        }
                        for fish in fishList {
                            print("Deleting \(fish.species)")
                            modelContext.delete(fish)
                        }
                        try modelContext.save()
                        
                        
                        print("Inserting \(jsonManager.config.trip.count) Trips")
                        for trip in jsonManager.config.trip {
                            print("Inserting \(trip.date), \(trip.tripType), \(trip.surveySection), \(trip.watershed) with \(trip.fish.count) fish")
                            let newTrip : Trip = Trip(
                                date: trip.date,
                                tripType: trip.tripType,
                                surveySection: trip.surveySection,
                                watershed: trip.watershed,
                                equipment: trip.equipment,
                                latDown: 0,
                                lonDown: 0,
                                latUp: 0,
                                lonUp: 0,
                                sectionLength: trip.sectionLength,
                                startTime: trip.startTime,
                                endTime: trip.endTime,
                                waterTemperature: trip.waterTemperature,
                                waterFlow: trip.waterFlow,
                                isClosed: trip.isClosed,
                                fish: []
                            )
                            // print("Here are the fish for this trip:")
                            for fish in trip.fish {
                                let item = Fish(
                                    date: fish.date,
                                    pitTag: fish.pitTag,
                                    lat: fish.lat,
                                    lon: fish.lon,
                                    species: fish.species,
                                    fwpSpecies: fish.fwpSpecies,
                                    weight: fish.weight,
                                    length: fish.length,
                                    gender: fish.gender,
                                    doa: fish.doa,
                                    hookScar: fish.hookScar,
                                    comment: fish.comment
                                )
                                newTrip.fish.append(item)
                            }
                            // print("Insert")
                            modelContext.insert(newTrip)
                        }
                            
                        do {
                            try modelContext.save()
                            print("Total Trips: \(getTripCount(modelContext: modelContext))")
                            print("Total Fish:  \(getFishCount(modelContext: modelContext))")
                        } catch {
                            print("An error occurred!")
                        }
                    }
                }
                
                
            }
            try! modelContext.save()
        }
    }
    
    func getTripCount(modelContext: ModelContext) -> Int {
        let descriptor = FetchDescriptor<Trip>(predicate: #Predicate { $0.tripType != "" })
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }
    
    func getFishCount(modelContext: ModelContext) -> Int {
        let descriptor = FetchDescriptor<Fish>(predicate: #Predicate { $0.species != "" })
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }
}


#Preview {
    @Previewable @State var path: [String] = []
    ContentView()
        .environment(LocationsHandler())
        .environment(NetworkMonitor())
}

