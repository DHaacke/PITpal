//
//  TagStatusView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI

struct TagStatusView: View {
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    
    @Binding var path: [String]
    @Binding var trip: Trip
    
    @State private var fetchManager     = FetchManager()
    
    @State private var isLoadingBighornStats: Bool = true
    @State private var bighornStats: [BighornStats] = []
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("CardBackground"))
                        .shadow(radius: 6, x: 1, y: 3)
                    if isLoadingBighornStats == false {
                        VStack {
                            HStack {
                                VStack {
                                    HStack {
                                        Image(systemName: networkMonitor.isConnected ? "wifi" : "wifi.exclamation")
                                           .resizable()
                                           .aspectRatio(contentMode: .fit)
                                           .frame(width: 40, height: 40)
                                           .padding(.leading, 2)
                                           .padding(.trailing, 8)
                                           .foregroundStyle(networkMonitor.isConnected ? Color.green : Color.gray)
                                           .shadow(radius: 2, x: 1, y: 1)

                                       BighornStatsValueView(value: self.bighornStats[2].value, suffix: "°", title: "Afterbay").padding(.trailing, 8)
                                       BighornStatsValueView(value: self.bighornStats[3].value, suffix: "°", title: "St. X").padding(.trailing, 8)
                                       BighornStatsValueView(value: self.bighornStats[0].value, suffix: " cfs", title: "River Release")
                                    }
                                    .frame(width: 400)
                                    VStack {
                                        HStack(alignment: .center) {
                                            Text("Rainbows").font(.system(size: 18, weight: .regular, design: .default))
                                            Spacer()
                                            Text("Browns").font(.system(size: 18, weight: .medium, design: .default))
                                        }.frame(width: 360)
                                        .padding(.horizontal, 10)
                                        HStack(alignment: .center) {
                                            Text("155")
                                            Spacer()
                                            Text("305").font(.system(size: 30, weight: .bold, design: .default))
                                            Spacer()
                                            Text("150")
                                        }.frame(width: 360)
                                        .padding(.horizontal, 6)
                                    }
                                    Spacer()
                                }.frame(width: 380, height: 120)
                                
                                VStack {
                                    HStack {
                                        HStack {
                                            BarChartView(species: "RB", title: "Rainbow trout")
                                                .padding(.top, 10).padding(.trailing, 6)
                                            BarChartView(species: "LL", title: "Brown trout")
                                                .padding(.top, 10)
                                        }
                                    }
                                }.frame(width: 400, height: 130)
                            }
                        }
                        .multilineTextAlignment(.center)
                    } else {
                        Text("Loading...")
                        ProgressView()
                    }

                }
                .frame(width: geometry.size.width, height: 140)
            }
        
            .onChange(of: networkMonitor.isConnected) {
                print("Network available changed to: \(networkMonitor.isConnected)")
            }
                
            .onAppear {
                Task {
                    isLoadingBighornStats = true
                    print("Network available: \(networkMonitor.isConnected)")
                    if networkMonitor.isConnected == true {
                        do {
                            self.bighornStats = try await fetchManager.fetchBighornStats()
                        } catch {
                            print("Error fetching Bighorn stats: \(error)")
                        }
                    } else {
                        self.bighornStats = []
                        let count = 0...39
                        for id in count {
                            self.bighornStats.append(BighornStats(id: id, label: "Bighorn \(id)", value: 0, suffix: "", decimals: 0))
                        }
                    }
                    print(self.bighornStats)
                    if self.bighornStats.count > 0 {
                        self.trip.waterTemperature = self.bighornStats[2].value
                        self.trip.waterFlow = self.bighornStats[0].value
                    }
                    isLoadingBighornStats = false
//                    self.trip.initialLat = locationsHandler.lastLocation2D.latitude
//                    self.trip.initialLon = locationsHandler.lastLocation2D.longitude
                    // print(self.trip.toJSON(trip: self.trip))
                }
            }
        }
        .frame(height: 140)
        .padding(.bottom, 10)
        // Spacer()
    }
    
    func ObjToJSON<T>(object: T) -> String {
        let prettyPrintedData = try! JSONSerialization.data(
            withJSONObject: object,
            options: [.prettyPrinted, .sortedKeys]
        )
        let prettyPrintedString = String(data: prettyPrintedData, encoding: .utf8)!
        print(prettyPrintedString)
        return prettyPrintedString
    }
    
    func BighornStatsValueView(value: Double, suffix: String, title: String) -> some View {
        if value <= 0 {
            return VStack {
                HStack {
                    Text("N/A)")
                        .font(.system(size: 40, weight: .bold, design: .default))
                        .foregroundStyle(Color("TextForegroundWhite"))
                        .padding(.bottom, 0)
                    Text("")
                        .font(.system(size: 20, weight: .light, design: .default))
                        .foregroundStyle(Color("TextForegroundWhite"))
                        .padding(.bottom, 0)
                        .offset(x: -10, y: -10)
                }
                Text("Offline")
                    .offset(y: -5)
                    .font(.system(size: 12, weight: .light, design: .default))
           }
        }
        return VStack {
                    HStack {
                        Text("\(value, specifier: "%.0f")")
                            .font(.system(size: value > 9999 ? 20: 40, weight: .bold, design: .default))
                            .foregroundStyle(Color("TextForegroundWhite"))
                            .padding(.bottom, 0)
                        Text(suffix)
                            .font(.system(size: 20, weight: .light, design: .default))
                            .foregroundStyle(Color("TextForegroundWhite"))
                            .padding(.bottom, 0)
                            .offset(x: -10, y: -10)
                    }
                    Text(title)
                        .offset(y: -5)
                        .font(.system(size: 12, weight: .light, design: .default))
             }
    }
}

#Preview {
    @Previewable @State var path: [String] = [K.TAG]
    @Previewable @State var trip: Trip = Trip()
    TagStatusView(path: $path, trip: $trip)
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}


/*

 Text(text)
     .font(.title)
     .foregroundStyle(Color("TextForegroundWhite"))
     .font(.system(size: 24, weight: .bold, design: .default))
 
 return VStack {
     Text("N/A")
         .foregroundStyle(Color.gray)
         .font(.system(size: 40, weight: .regular, design: .default))
         .padding(.bottom, 0)
     Text("Offline")
         .offset(y: -5)
         .font(.system(size: 12, weight: .light, design: .default))
 }
 
 */
