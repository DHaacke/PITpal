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
                    MenuCardView(text: "Start a new Tagging Run")
                    Spacer()
                    MenuCardView(text: "Start a new Recapture Run")
                }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                
                HStack {
                    MenuCardView(text: "View/Edit History of\n Tagging Run")
                    Spacer()
                    MenuCardView(text: "View/Edit History of\n Recapture Run")
                }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 30)
                
                HStack {
                    MenuCardView(text: "Settings")

                }
                    .padding(.horizontal, 30)
                    .padding(.bottom, 50)
                
                Text("Data Export and Visualization")
                    .font(.system(size: 32, weight: .bold, design: .default))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)
                
                HStack {
                    MenuCardView(text: "Export Data to MySQL")
                    Spacer()
                    MenuCardView(text: "Export Data to Excel")
                }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                HStack {
                    MenuCardView(text: "Export Data to R")
                    Spacer()
                    MenuCardView(text: "Export Data to CSV")
                }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
                HStack {
                    MenuCardView(text: "Instant Analysis")
                    Spacer()
                    MenuCardView(text: "View / Print / Export Graphs")
                }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        // .environment(\.colorScheme, .light)
        .background(Color("AppBackground"))
    }
}

#Preview {
    MainMenuView(path: .constant([]))
        .environment(\.scenePhase, .active)
        .environment(LocationsHandler())
        
}

    

            //    Text("View Width: \(geometry.size.width)")
