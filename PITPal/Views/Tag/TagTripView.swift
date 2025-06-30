//
//  TagDailyView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI
import SwiftData

struct TagTripView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("usingPitTags") private var usingPitTags: Bool = true
    
    @Binding var path: [String]
    @Binding var trip: Trip
    @Binding var isAddingTrip: Bool
    
    @State private var fetchManager     = FetchManager()
    // @State private var networkMonitor   = NetworkMonitor()
    
    @State private var isLoadingBighornStats: Bool = true
    @State private var bighornStats: [BighornStats] = []
    
    @State private var selectedStartTime: Date = Date()
    @State private var selectedEndTime: Date = Date()

    @State private var tripLatDown: String = "0.0"
    @State private var tripLonDown: String = "0.0"
    @State private var tripLatUp: String = "0.0"
    @State private var tripLonUp: String = "0.0"
    
    @State private var isValidWatershed: Bool = false
    @State private var isValidTripType: Bool = false
    @State private var isValidSurveySection: Bool = false
    @State private var isValidStartTime: Bool = true
    @State private var isValidEndTime: Bool = true
    
    
    @Query(sort: \Watershed.code) var watersheds: [Watershed]
    @Query(sort: \SurveySection.code) var surveySections: [SurveySection]
    @Query(sort: \TripType.code) var tripTypes: [TripType]
    
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
                                    selection: $trip.date,
                                    displayedComponents: [.date]
                            )
                                .datePickerStyle(.compact)
                                .frame(width: 180)
                                .disabled(trip.isClosed == "Y" ? true : false)
                            Spacer()

                            if trip.isClosed == "N" {
                                LabeledContent {
                                    Picker("", selection: $trip.watershed) {
                                        Text("<Choose>").tag("")
                                        ForEach(watersheds) { watershed in
                                            Text(watershed.name).tag(watershed.code)
                                        }
                                    }
                                    .tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                                    .pickerStyle(.menu)
                                    .disabled(trip.isClosed == "Y" ? true : false)
                                    
                                } label: {
                                    Text("Watershed:")
                                }.frame(width: 250, height: 30)
                            } else {
                                let watershed = watersheds.first(where: { $0.code == trip.watershed }) ?? watersheds.first!
                                Text("\(watershed.name)")
                            }

                            Spacer()
                            
                            if trip.isClosed == "N" {
                                LabeledContent {
                                    Picker("", selection: $trip.surveySection) {
                                        Text("<Choose>").tag("")
                                        ForEach(surveySections) { section in
                                            Text(section.name).tag(section.code)
                                        }
                                    }
                                    .tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                                    .shadow(radius: 3)
                                    .pickerStyle(.menu)
                                    .disabled(trip.isClosed == "Y" ? true : false)
                                } label: {
                                    Text("Survey Section:")
                                }.frame(width: 250, height: 30)
                            } else {
                                let section = surveySections.first(where: { $0.code == trip.surveySection }) ?? surveySections.first!
                                Text("\(section.name)")
                            }
                        }
                        .frame(height : 30)
                        .padding(.top, 6)
                        .padding(.horizontal, 10)
                        
                        HStack {
                            if trip.isClosed == "N" {
                                LabeledContent {
                                    Picker("", selection: $trip.tripType) {
                                        Text("<Choose>").tag("")
                                        ForEach(tripTypes) { type in
                                            Text(type.name).tag(type.code)
                                        }
                                    }
                                    .tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                                    .shadow(radius: 3)
                                    .pickerStyle(.menu)
                                    .disabled(trip.isClosed == "Y" ? true : false)
                                } label: {
                                    Text("Trip Type:")
                                }.frame(width: 220, height: 30)
                            } else {
                                let type = tripTypes.first(where: { $0.code == trip.tripType }) ?? tripTypes.first!
                                Text("\(type.name)")
                            }
                            
                            LabeledContent {
                                Toggle("", isOn: $usingPitTags)
                                    .frame(width: 50, height: 30)
                                    .tint(Color.green)
                                    .shadow(radius: 2)
                            } label: {
                                Text("Using PIT tags")
                            }
                                .padding(.leading, 15)
                                .frame(width: 180)
                                .disabled(trip.isClosed == "Y" ? true : false)
                            
                            Spacer()
                            
                            DatePicker(
                                    "Start:",
                                    selection: $selectedStartTime,
                                    displayedComponents: [.hourAndMinute]
                                ).datePickerStyle(.compact).frame(width: 160).disabled(isAddingTrip ? true : false)
                            
                            DatePicker(
                                    "End:",
                                    selection: $selectedEndTime,
                                    displayedComponents: [.hourAndMinute]
                                ).datePickerStyle(.compact).frame(width: 140).disabled(isAddingTrip ? true : false)
                            

                        }
                        .padding(.horizontal, 10)
                        .frame(height : 30)

                        HStack {

                            LabeledContent {
                                TextField("", text: $tripLatDown)
                                    .foregroundColor(Color("TextForeground"))
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 100)
                                    .multilineTextAlignment(.trailing)
                            } label: {
                                Text("Lat↓:")
                                    .onTapGesture {
                                        Task {
                                            await MainActor.run {
                                                self.tripLatDown = "\(locationsHandler.lastLocation2D.latitude)"
                                            }
                                        }
                                    }
                            }.frame(width: 160, height: 30).padding(.trailing, 20)
                           
                            LabeledContent {
                                TextField("", text: $tripLonDown )
                                  .foregroundColor(Color("TextForeground"))
                                  .textFieldStyle(.roundedBorder)
                                  .frame(width: 120)
                                  .multilineTextAlignment(.trailing)
                            } label: {
                                Text("Lon↓:")
                                    .onTapGesture {
                                        Task {
                                            await MainActor.run {
                                                tripLonDown = "\(locationsHandler.lastLocation2D.longitude)"
                                            }
                                        }
                                    }
                            }.frame(width: 180, height: 30).padding(.trailing, 20)
                            
                            LabeledContent {
                                TextField("", text: $tripLatUp )
                                  .foregroundColor(Color("TextForeground"))
                                  .textFieldStyle(.roundedBorder)
                                  .frame(width: 100)
                                  .multilineTextAlignment(.trailing)
                            } label: {
                                Text("Lat↑:")
                                   .onTapGesture {
                                       tripLatUp = "\(locationsHandler.lastLocation2D.latitude)"
                                   }
                            }.frame(width: 160, height: 30).padding(.trailing, 20)
                            
                            LabeledContent {
                                TextField("", text: $tripLonUp)
                                  .foregroundColor(Color("TextForeground"))
                                  .textFieldStyle(.roundedBorder)
                                  .frame(width: 120)
                                  .multilineTextAlignment(.trailing)
                            } label: {
                                Text("Lon↑:")
                                .onTapGesture {
                                    tripLonUp = "\(locationsHandler.lastLocation2D.longitude)"
                                }
                            }.frame(width: 180, height: 30).padding(.trailing, 10)
                        }
                        .padding(.top, 10)
                        .frame(height : 30)
                        
                        HStack {
                            Spacer()
                            if trip.isClosed == "Y" {
                                Text("Trip is CLOSED")
                            } else {
                                Text("Trip is OPEN")
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .frame(height : 30)
                    }
                    .multilineTextAlignment(.center)
                    
                }  // ZStack
                .onAppear {
                    // print("width: \(geometry.size.width)")
                }
                .onChange(of: trip.watershed) {
                    if trip.watershed.isEmpty {
                        isValidWatershed = false
                    } else {
                        isValidWatershed = true
                    }
                }
                .onChange(of: trip.surveySection) {
                    if trip.surveySection.isEmpty {
                        isValidSurveySection = false
                    } else {
                        isValidSurveySection = true
                    }
                }
                .onChange(of: trip.tripType) {
                    if trip.tripType.isEmpty {
                        isValidTripType = false
                    } else {
                        isValidTripType = true
                    }
                }
            }
        } // VStack
        .frame(height: 130)
    }
}

/*
#Preview {
    @Previewable @State var path: [String] = [K.TAG]
    @Previewable @State var trip: Trip = Trip()
    @Previewable @State var fish: Fish = Fish()
    TagTripView(path: $path, trip: $trip)
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}
*/
