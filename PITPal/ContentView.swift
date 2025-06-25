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
    
    // TODO
    @Query(sort: \Species.code) var speciesList: [Species]
    @Query(sort: \SurveySection.code) var surveySections: [SurveySection]
    
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
                        
                        do {
                            try modelContext.save()
                            print("Total Fish: \(getRecordCount(modelContext: modelContext))")
                        } catch {
                            print("An error occurred!")
                        }
                    }
                }
            }
            try! modelContext.save()
        }
    }
    
    func getRecordCount(modelContext: ModelContext) -> Int {
        let descriptor = FetchDescriptor<Species>(predicate: #Predicate { $0.name != "" })
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }
}

#Preview {
    @Previewable @State var path: [String] = []
    ContentView()
        .environment(LocationsHandler())
        .environment(NetworkMonitor())
}
