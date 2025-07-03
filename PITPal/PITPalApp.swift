//
//  PITPalApp.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import Foundation
import SwiftData
import SwiftUI

@main
struct PITPalApp: App {
    @Environment(\.modelContext) var modelContext
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @State private var locationsHandler = LocationsHandler.shared
    @State private var jsonManager      = JSONManager()
    @State private var networkMonitor   = NetworkMonitor()

    @State private var isWaitingForLaunchView = true
    @State private var launchTimer  = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if isWaitingForLaunchView == false {
                    if locationsHandler.isAuthorized {
                        ContentView()
                            .environment(locationsHandler)
                            .environment(jsonManager)
                            .environment(networkMonitor)
                    } else {
                        LocationDeniedView()
                    }
                } else {
                    Text("Loading PIT Pal...")
                    ProgressView()
                }
            }
            // .environment(\.colorScheme, darkMode == true ? .dark : .light)
            // .preferredColorScheme(darkMode == true ? .dark : .light)
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .background(Color("AppBackground"))
            .onReceive(launchTimer) { time in
                isWaitingForLaunchView = false
                launchTimer.upstream.connect().cancel()
            }
            .onAppear {
                print("Autosave disabled: \(modelContext.autosaveEnabled)")
            }
            .task {
                print("App is starting...")
                print(modelContext.sqliteCommand)
                locationsHandler.updatesStarted = true
                // networkManager.checkNetworkConnection()
            }
        }
        .modelContainer(for: [Trip.self, Fish.self, Species.self, Gender.self, SurveySection.self, Watershed.self, TripType.self])
    }
}
