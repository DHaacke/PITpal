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
    
    @State private var fetchManager     = FetchManager()
    // @State private var networkMonitor   = NetworkMonitor()
    
    @State private var isLoadingBighornStats: Bool = true
    @State private var bighornStats: [BighornStats] = []
    
    @State private var selectedDate: Date = Date()
    @State private var watershed: String = ""
    @State private var surveySection: String = ""
    @State private var selectedStartTime: Date = Date()
    @State private var selectedEndTime: Date = Date()
    @State private var tripType: String = ""
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
                                    selection: $selectedDate,
                                    displayedComponents: [.date]
                                ).datePickerStyle(.compact).frame(width: 180)
                            Spacer()
                            
                            LabeledContent {
                                Picker("", selection: $watershed) {
                                    Text("<Choose>").tag("")
                                    ForEach(watersheds) { watershed in
                                        Text(watershed.name).tag(watershed.code)
                                    }
                                }
                                .shadow(radius: 3)  // tint removed
                                .pickerStyle(.menu)
                            } label: {
                                Text("Watershed:")
                            }.frame(width: 250, height: 30)
                            Spacer()
                            
                            LabeledContent {
                                Picker("", selection: $surveySection) {
                                    Text("<Choose>").tag("")
                                    ForEach(surveySections) { section in
                                        Text(section.name).tag(section.code)
                                    }
                                }
                                .shadow(radius: 3)
                                .pickerStyle(.menu)
                            } label: {
                                Text("Survey Section:")
                            }.frame(width: 250, height: 30)
                        }
                        .padding(.horizontal, 10)
                        
                        HStack {
                            LabeledContent {
                                Picker("", selection: $tripType) {
                                    Text("<Choose>").tag("")
                                    ForEach(tripTypes) { type in
                                        Text(type.name).tag(type.code)
                                    }
                                }
                                .shadow(radius: 3)
                                .pickerStyle(.menu)
                            } label: {
                                Text("Trip Type:")
                            }.frame(width: 220, height: 30)
                            Spacer()
                            
                            DatePicker(
                                    "Start:",
                                    selection: $selectedStartTime,
                                    displayedComponents: [.hourAndMinute]
                                ).datePickerStyle(.compact).frame(width: 160)
                            
                            DatePicker(
                                    "End:",
                                    selection: $selectedEndTime,
                                    displayedComponents: [.hourAndMinute]
                                ).datePickerStyle(.compact).frame(width: 140)
                            

                        }.padding(.horizontal, 10)

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
                        
                        HStack {
                            LabeledContent {
                                Toggle("", isOn: $usingPitTags)
                                    .frame(width: 50, height: 30)
                                    .tint(Color.green)
                                    .shadow(radius: 2)
                            } label: {
                                Text("Using PIT tags")
                            }.frame(width: 250)
                            
                            SaveButton(onSaveButtonTapped: {
                                print("Save button tapped: \(geometry.size.width / 3)")
                            })
                                .frame(width: geometry.size.width / 3)
                                .padding(.vertical, 10)
                                .opacity( isValidWatershed && isValidTripType && isValidSurveySection && isValidStartTime && isValidEndTime ? 1 : 0.2)
                                .disabled(isValidWatershed || isValidTripType || isValidSurveySection || isValidStartTime || isValidEndTime)

                            Spacer()
                            // Text("\(locationsHandler.lastLocation2D.latitude, specifier: "%.4f"), \(locationsHandler.lastLocation2D.longitude, specifier: "%.4f")")

                        }
                        .padding(.horizontal, 10)
                    }
                    .multilineTextAlignment(.center)
                    
                }  // ZStack
                .onAppear {
                    print("width: \(geometry.size.width)")
                }
                .onChange(of: watershed) {
                    print("Watershed changed to [\(self.watershed)]")
                    if self.watershed.isEmpty {
                        print("Invalid Watershed")
                        isValidWatershed = false
                    } else {
                        print("Valid Watershed")
                        isValidWatershed = true
                    }
                }
                .onChange(of: surveySection) {
                    print("surveySection changed to \(self.surveySection)")
                    if self.surveySection.isEmpty {
                        isValidSurveySection = false
                    } else {
                        isValidSurveySection = true
                    }
                }
                .onChange(of: tripType) {
                    print("tripType changed to \(self.tripType)")
                    if self.tripType.isEmpty {
                        isValidTripType = false
                    } else {
                        isValidTripType = true
                    }
                }
            }
        } // VStack
        .frame(height: 180)
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
