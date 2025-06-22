//
//  TagDailyView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI
import SwiftData

struct TagDailyView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("usingPitTags") private var usingPitTags: Bool = true
    
    @Binding var path: [String]
    @Binding var trip: Trip
    @Binding var surveySection: String
    
    @State private var fetchManager     = FetchManager()
    // @State private var networkMonitor   = NetworkMonitor()
    
    @State private var isLoadingBighornStats: Bool = true
    @State private var bighornStats: [BighornStats] = []
    
    @State private var selectedDate: Date = Date()
    @State private var watershedCode: String = ""
    @State private var surveySectionCode: String = ""
    
    @Query(sort: \Watershed.code) var watersheds: [Watershed]
    @Query(sort: \SurveySection.code) var surveySections: [SurveySection]
    
    //  @Query(sort: [SortDescriptor(\Destination.priority, order: .reverse), SortDescriptor(\Destination.name)]) var destinations: [Destination]

    
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
                                Picker("", selection: $watershedCode) {
                                    Text("<Choose>").tag("")
                                    ForEach(watersheds) { watershed in
                                        Text(watershed.name).tag(watershed.code)
                                    }
                                }
                                .shadow(radius: 3)  // tint removed
                                .pickerStyle(.menu)
                            } label: {
                                Text("Watershed:")
                            }.frame(width: 250, height: 40)
                            Spacer()
                            
                            LabeledContent {
                                Picker("", selection: $surveySectionCode) {
                                    Text("<Choose>").tag("")
                                    ForEach(surveySections) { section in
                                        Text(section.name).tag(section.code)
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
                .onChange(of: watershedCode) {
                    print("Watershed changed to \(self.watershedCode)")
                    self.trip.watershed = self.watershedCode
                }
                .onChange(of: surveySectionCode) {
                    print("surveySection changed to \(self.surveySectionCode)")
                    self.surveySection = self.surveySectionCode
                }
            }
        }
        .frame(height: 100)
    }
}

#Preview {
    @Previewable @State var path: [String] = [K.TAG]
    @Previewable @State var trip: Trip = Trip()
    @Previewable @State var surveySection: String = ""
    TagDailyView(path: $path, trip: $trip, surveySection: $surveySection)
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}

