//
//  PITPalApp.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI

@main
struct PITPalApp: App {
    
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    
    @State private var locationsHandler = LocationsHandler.shared
    //    @State private var jsonManager      = JSONManager()
    //    @State private var networkManager   = NetworkManager()


    @State private var isWaitingForLaunchView = true
    @State private var launchTimer  = Timer.publish(every: 1.5, on: .main, in: .common).autoconnect()
    
    var body: some Scene {
        WindowGroup {
            VStack {
                if locationsHandler.isAuthorized {
                    if isWaitingForLaunchView == false {
                        ContentView()
                            .environment(locationsHandler)
    //                        .environment(jsonManager)
    //                        .environment(networkManager)
                    } else {
                        ProgressView()
                    }
                    
                } else {
                    LocationDeniedView()
                }
            }
//            .environment(\.colorScheme, .dark)
//            .preferredColorScheme(.dark)
//            .background(.black)
            .onReceive(launchTimer) { time in
                isWaitingForLaunchView = false
            }
            .onAppear {
                locationsHandler.updatesStarted = true
                // networkManager.checkNetworkConnection()
            }
        }
    }
}

