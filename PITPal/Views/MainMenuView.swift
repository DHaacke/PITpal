//
//  MainMenuView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import SwiftUI
import JiggleKit

struct MainMenuView: View {
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]
    
    @State private var isAnimatingBackground: Bool = false
    
    private let startColor: Color = Color("AppBackground")
    private let midColor: Color = .yellow // Color("CardBackground")
    private let endColor: Color = Color("TroutGreen")

    @State private var isJiggling: Bool = false
    @State private var jiggleTimer  = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State private var jiggleElapsed: Int = 0
    @State private var intensity: JiggleIntensity = .subtle

    var body: some View {
        VStack {
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
                Spacer()
                MenuCardView(path: $path, text: "Start", subText: "", newPath: "TAG")
                    .jiggling(isJiggling: self.isJiggling, intensity: self.intensity)
                    .frame(width: 400)
                Spacer()
            }
                .padding(.bottom, 30)
            HStack {
                Spacer()
                MenuCardView(path: $path, text: "Settings and Defaults", subText: "", newPath: "SETTINGS")
                    .frame(width: 400)
                Spacer()
            }
                .padding(.bottom, 30)
          
            Text("Data Export and Visualization")
                .font(.system(size: 32, weight: .bold, design: .default))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
            HStack {
                Spacer()
                MenuCardView(path: $path, text: "Export Trip/Fish Data", subText: "", newPath: "EXPORT")
                    .frame(width: 400)
                Spacer()
            }
                .padding(.bottom, 20)
            HStack {
                Spacer()
                MenuCardView(path: $path, text: "Size Chart", subText: "Single species bar chart style", newPath: K.SINGLE_SPECIES_SIZE_CHART)
                Spacer()
                MenuCardView(path: $path, text: "Size Chart", subText: "Multiple species bar chart style", newPath: K.DUAL_SPECIES_SIZE_CHART)
                Spacer()
            }
                .padding(.bottom, 20)
            HStack {
                Spacer()
                MenuCardView(path: $path, text: "Size/Weight Model", subText: "Scatter plot style", newPath: K.SIZE_WEIGHT_MODEL_CHART)
                Spacer()
                MenuCardView(path: $path, text: "Survey Summary", subText: "Filtered by date range", newPath: K.SURVEY_SUMMARY)
                Spacer()
            }
                .padding(.bottom, 20)
            HStack {
                Spacer()
                MenuCardView(path: $path, text: "Population Estimator", subText: "", newPath: "POPULATION_ESTIMATE")
                    .frame(width: 500)
                Spacer()
            }
                .padding(.bottom, 20)
            HStack {
                Spacer()
                MenuCardView(path: $path, text: "Archive", subText: "", newPath: "ARCHIVE")
                    .frame(width: 400)
                Spacer()
            }
                .padding(.bottom, 20)
            HStack {
                Text("Version \(getAppVersion()) (Build \(getBuildNumber()))")
            }

            Spacer()
            
        }
        .frame(minWidth: 800, maxWidth: .infinity)
        .scrollContentBackground(.hidden)
        .edgesIgnoringSafeArea(.all)
        // .frame(minWidth: 800, maxWidth: .infinity, minHeight: 800, maxHeight: .infinity)
        .padding(.horizontal, 20)
        .background {
                LinearGradient(
                    gradient: Gradient(
                        colors: [startColor, endColor]
                    ),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .edgesIgnoringSafeArea(.all)
                .hueRotation(.degrees(isAnimatingBackground ? 75 : 0))
                .animation(isAnimatingBackground ? .linear(duration: 10).repeatForever(autoreverses: true) : .default, value: isAnimatingBackground)
        }
        .onAppear {
            isAnimatingBackground = true
        }
        .onDisappear {
            isAnimatingBackground = false
        }
        .onReceive(jiggleTimer) { _ in
            self.jiggleElapsed += 1
            switch(self.jiggleElapsed) {
                case 0...5:
                    self.isJiggling = false
                case 6...20:
                    self.isJiggling = true
                    self.intensity = .subtle
                case 21...30:
                    self.isJiggling = true
                    self.intensity = .moderate
                case 31...40:
                    self.isJiggling = true
                    self.intensity = .subtle
                case 41:
                    self.jiggleElapsed = 0
                    self.isJiggling = false
                default:
                    break;
            }
        }
    }
    
    func getAppVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "N/A"
    }

    func getBuildNumber() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "N/A"
    }
}

#Preview {
    MainMenuView(path: .constant([]))
        .environment(\.scenePhase, .active)
        .environment(LocationsHandler())
        
}


// .environment(\.colorScheme, .light)
