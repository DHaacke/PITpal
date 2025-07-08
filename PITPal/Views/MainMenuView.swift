//
//  MainMenuView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import SwiftUI

struct MainMenuView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]

    var body: some View {
        ScrollView {
            Section {
                Image("FWPLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200)
                    .shadow(radius: 16)
                    .padding(.top, 20)
                    .padding(.bottom, 20)
                
                Text("Data Collection")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                HStack {
                    MenuCardView(path: $path, text: "Start", subText: "", newPath: "TAG")
                        .padding(.horizontal, 120)
                }
                    .padding(.bottom, 20)
                
                HStack {
                    MenuCardView(path: $path, text: "Export Trip/Fish Data", subText: "", newPath: "EXPORT")
                        .padding(.horizontal, 120)
                }
                    .padding(.bottom, 20)
                
//                HStack {
//                    MenuCardView(path: $path, text: "View / Edit History of\n Tagging Run", newPath: "")
//                    Spacer()
//                    MenuCardView(path: $path, text: "View / Edit History of\n Recapture Run", newPath: "")
//                }
//                    .padding(.horizontal, 30)
//                    .padding(.bottom, 20)
                
                HStack {
                    MenuCardView(path: $path, text: "Settings", subText: "", newPath: "SETTINGS")
                }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 40)
                
                Text("Data Export and Visualization")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                HStack {
                    MenuCardView(path: $path, text: "Size Chart", subText: "Single bar chart style", newPath: K.SINGLE_SPECIES_SIZE_CHART)
                    Spacer()
                    MenuCardView(path: $path, text: "Size Chart", subText: "Multiple bar chart style", newPath: K.DUAL_SPECIES_SIZE_CHART)
                }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                HStack {
                    MenuCardView(path: $path, text: "Section Analysis", subText: "", newPath: "")
                    Spacer()
                    MenuCardView(path: $path, text: "Species Analysis", subText: "", newPath: "")
                }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                HStack {
                    Spacer()
                    MenuCardView(path: $path, text: "Lincoln-Petersen Estimator", subText: "", newPath: "")
                    Spacer()
                }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
        }
        .frame(minWidth: 800, maxWidth: .infinity, minHeight: 900, maxHeight: 1200)
        .background(Color("AppBackground"))
    }
}

#Preview {
    MainMenuView(path: .constant([]))
        .environment(\.scenePhase, .active)
        .environment(LocationsHandler())
        
}


// .environment(\.colorScheme, .light)
