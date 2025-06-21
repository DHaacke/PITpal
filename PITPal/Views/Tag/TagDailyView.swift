//
//  TagDailyView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI

struct TagDailyView: View {
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("usingPitTags") private var usingPitTags: Bool = true
    
    @Binding var path: [String]
    @Binding var trip: Trip
    
    @State private var fetchManager     = FetchManager()
    // @State private var networkMonitor   = NetworkMonitor()
    
    @State private var isLoadingBighornStats: Bool = true
    @State private var bighornStats: [BighornStats] = []
    
    @State private var selectedDate: Date = Date()
    @State private var surveySection: Int = -1
    @State private var watershedId: Int = -1

    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("CardBackground"))
                        .shadow(radius: 6, x: 1, y: 3)
                    
                    VStack {
                        HStack {
                            // Text("Date is \(birthDate.formatted(date: .long, time: .omitted))")
                            DatePicker(
                                    "Date:",
                                    selection: $selectedDate,
                                    displayedComponents: [.date]
                                ).datePickerStyle(.compact).frame(width: 180)
                            Spacer()
                            
                            LabeledContent {
                                Picker("", selection: $watershedId) {
                                    Text("<Choose>").tag(-1)
                                    ForEach(jsonManager.config.watershed, id: \.self) { watershed in
                                        Text(watershed.description).tag(watershed.id)
                                    }
                                }
                                .shadow(radius: 3)  // tint removed
                                .pickerStyle(.menu)
                            } label: {
                                Text("Watershed:")
                            }.frame(width: 250, height: 40)
                            Spacer()
                            
                            LabeledContent {
                                Picker("", selection: $surveySection) {
                                    Text("<Choose>").tag(-1)
                                    ForEach(jsonManager.config.surveySection, id: \.self) { section in
                                        Text(section.description).tag(section.description)
                                    }
                                }
                                .shadow(radius: 3)
                                .pickerStyle(.menu)
                            } label: {
                                Text("Survey Section:")
                            }.frame(width: 250, height: 40)
                        }
                        HStack {
                            LabeledContent {
                                Toggle("", isOn: $usingPitTags)
                                    .frame(width: 50, height: 40)
                                    .tint(Color.green)
                                    .shadow(radius: 2)
                            } label: {
                                Text("Using PIT tags")
                                Text("Enable this if you are using PIT tags today.")
                                    .font(.footnote)
                            }.frame(width: 320)
                            Spacer()
                            Text("\(locationsHandler.lastLocation2D.latitude, specifier: "%.4f"), \(locationsHandler.lastLocation2D.longitude, specifier: "%.4f")")
                        }
                    }
                    .frame(height: 50)
                    .padding()
                    .multilineTextAlignment(.center)
                    
                }
                // .frame(width: geometry.size.width, height: 60)
                .onAppear {
                    // print(jsonManager.config)
                }
                .onChange(of: watershedId) {
                    print("Watershed changed to \(self.watershedId)")
                    self.trip.watershed = jsonManager.config.watershed.first(where: { $0.id == self.watershedId })?.code ?? "N/A"
                    print(self.trip.toJSON(trip: self.trip))
                    
                }
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    @Previewable @State var path: [String] = [K.TAG]
    @Previewable @State var trip: Trip = Trip()
    TagDailyView(path: $path, trip: $trip)
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}

