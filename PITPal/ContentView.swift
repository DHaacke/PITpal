//
//  ContentView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(LocationsHandler.self) var locationsHandler
    
    @State private var path: [String] = []
    
    var body: some View {
        
//        MapView()
//            .environment(locationsHandler)
        NavigationStack(path: $path) {
            VStack {
                MainMenuView(path: $path)
                    .environment(locationsHandler)
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                    .navigationTitle("Menu")
                    .navigationBarTitleDisplayMode(.inline)                    
            }
            .navigationDestination(for: String.self) { navigation in
                if navigation == K.MAINMENU {
                    MainMenuView(path: $path)
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(true)
                        .navigationTitle("Map")
                        .navigationBarTitleDisplayMode(.inline)
                }
                else if navigation == K.SETTINGS {
                    MainMenuView(path: $path)  // change this
                        .navigationBarBackButtonHidden(true)
                        .navigationBarHidden(false)
                        .navigationTitle("Settings")
                        .navigationBarTitleDisplayMode(.inline)
                    }
                }
        }
    }
}

#Preview {
    @Previewable @State var path: [String] = []
    ContentView()
        .environment(LocationsHandler())
}
