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
    @Environment(NetworkMonitor.self) var networkMonitor
    
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
    }
}

#Preview {
    @Previewable @State var path: [String] = []
    ContentView()
        .environment(LocationsHandler())
        .environment(NetworkMonitor())
}
