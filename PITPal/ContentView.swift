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
    
    @AppStorage("darkMode") private var darkMode: Bool = false
    
    @State private var path = [String]()
    
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
            }
        }
        .background(Color("CardBackground"))
        .preferredColorScheme(darkMode == true ? .dark : .light)
        .onChange(of: path) { oldPath, newPath in
            print("Path changed: \(newPath)")
        }
    }
}

#Preview {
    @Previewable @State var path: [String] = []
    ContentView()
        .environment(LocationsHandler())
}
