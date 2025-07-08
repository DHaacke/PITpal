//
//  TagDailyView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI
import SwiftData

struct TripHeaderView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.colorScheme) var colorScheme
    
    @AppStorage("usingPitTags") private var usingPitTags: Bool = true
    
    @Binding var path: [String]
    @Binding var tripData: TripData
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
    @State private var tripGear: String = ""
    @State private var tripRectifyingunit: String = ""
    @State private var tripVolts: String = ""
    @State private var tripAmps: String = ""
    @State private var tripShocktime: String = ""
    @State private var tripAnesthetic: String = ""
    @State private var tripDosage: String = ""
    
    @State private var isValidWatershed: Bool = false
    @State private var isValidTripType: Bool = false
    @State private var isValidSurveySection: Bool = false
    @State private var isValidStartTime: Bool = true
    @State private var isValidEndTime: Bool = true
    
    @State private var isShowingTripExtras: Bool = false
    
    
    @Query(sort: \Watershed.code) var watersheds: [Watershed]
    @Query(sort: \SurveySection.code) var surveySections: [SurveySection]
    @Query(sort: \TripType.code) var tripTypes: [TripType]
    
    //  @Query(sort: [SortDescriptor(\Destination.priority, order: .reverse), SortDescriptor(\Destination.name)]) var destinations: [Destination]
    
    enum FocusedField {
        case int, dec
    }
    @FocusState private var focusedField: FocusedField?
    @State private var latDownText = ""
    @State private var lonDownText = ""
    @State private var latUpText = ""
    @State private var lonUpText = ""
    @State private var radiusText = ""
    
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
                                    selection: $tripData.date,
                                    displayedComponents: [.date]
                            )
                                .datePickerStyle(.compact)
                                .frame(width: 180)
                                .disabled(tripData.isClosed == "Y" ? true : false)
                            Spacer()

                            if tripData.isClosed == "N" {
                                LabeledContent {
                                    Picker("", selection: $tripData.watershed) {
                                        Text("<Choose>").tag("")
                                        ForEach(watersheds) { watershed in
                                            Text(watershed.name).tag(watershed.code)
                                        }
                                    }
                                    .tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                                    .pickerStyle(.menu)
                                    .disabled(tripData.isClosed == "Y" ? true : false)
                                    
                                } label: {
                                    Text("Watershed:")
                                }.frame(width: 250, height: 30)
                            } else {
                                let watershed = watersheds.first(where: { $0.code == tripData.watershed }) ?? watersheds.first!
                                Text("\(watershed.name)")
                            }

                            Spacer()
                            
                            if tripData.isClosed == "N" {
                                LabeledContent {
                                    Picker("", selection: $tripData.surveySection) {
                                        Text("<Choose>").tag("")
                                        ForEach(surveySections) { section in
                                            Text(section.name).tag(section.code)
                                        }
                                    }
                                    .tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                                    .shadow(radius: 3)
                                    .pickerStyle(.menu)
                                    .disabled(tripData.isClosed == "Y" ? true : false)
                                } label: {
                                    Text("Survey Section:")
                                }.frame(width: 250, height: 30)
                            } else {
                                let section = surveySections.first(where: { $0.code == tripData.surveySection }) ?? surveySections.first!
                                Text("\(section.name)")
                            }
                        }
                        .frame(height : 30)
                        .padding(.top, 6)
                        .padding(.horizontal, 10)
                        
                        HStack {
                            if tripData.isClosed == "N" {
                                LabeledContent {
                                    Picker("", selection: $tripData.tripType) {
                                        Text("<Choose>").tag("")
                                        ForEach(tripTypes) { type in
                                            Text(type.name).tag(type.code)
                                        }
                                    }
                                    .tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                                    .shadow(radius: 3)
                                    .pickerStyle(.menu)
                                    .disabled(tripData.isClosed == "Y" ? true : false)
                                } label: {
                                    Text("Trip Type:")
                                }.frame(width: 220, height: 30)
                            } else {
                                let type = tripTypes.first(where: { $0.code == tripData.tripType }) ?? tripTypes.first!
                                Text("\(type.name)")
                            }
                            Spacer()
                            
                           
                            DatePicker(
                                    "Start:",
                                    selection: $selectedStartTime,
                                    displayedComponents: [.hourAndMinute]
                                ).datePickerStyle(.compact).frame(width: 160).disabled(isAddingTrip ? true : false)
                            Spacer()
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
                                TextField("", text: $latDownText)
                                    .focused($focusedField, equals: .dec)
                                    .numbersOnly($latDownText, includeDecimal: true)
                                    .disableAutocorrection(true)
                                    .foregroundColor(Color("TextForeground"))
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 100)
                            } label: {
                                Text("Lat↓:")
                                    .onTapGesture {
                                        latDownText = "\(locationsHandler.lastLocation2D.latitude.formatted(.number.precision(.fractionLength(8))))"
                                    }
                            }.frame(width: 160, height: 30).padding(.trailing, 20)
                           
                            LabeledContent {
                                TextField("", text: $lonDownText)
                                    .focused($focusedField, equals: .dec)
                                    .numbersOnly($lonDownText, includeDecimal: true)
                                    .disableAutocorrection(true)
                                  .foregroundColor(Color("TextForeground"))
                                  .textFieldStyle(.roundedBorder)
                                  .frame(width: 120)
                            } label: {
                                Text("Lon↓:")
                                    .onTapGesture {
                                        lonDownText = "\(locationsHandler.lastLocation2D.longitude.formatted(.number.precision(.fractionLength(8))))"
                                    };
                            }.frame(width: 180, height: 30).padding(.trailing, 20)
                            
                            LabeledContent {
                                TextField("", text: $latUpText)
                                    .focused($focusedField, equals: .dec)
                                    .numbersOnly($latUpText, includeDecimal: true)
                                    .disableAutocorrection(true)
                                  .foregroundColor(Color("TextForeground"))
                                  .textFieldStyle(.roundedBorder)
                                  .frame(width: 100)
                            } label: {
                                Text("Lat↑:")
                                   .onTapGesture {
                                       latUpText = "\(locationsHandler.lastLocation2D.latitude.formatted(.number.precision(.fractionLength(8))))"
                                   }
                            }.frame(width: 160, height: 30).padding(.trailing, 20)
                            
                            LabeledContent {
                                TextField("", text: $lonUpText)
                                    .focused($focusedField, equals: .dec)
                                    .numbersOnly($lonUpText, includeDecimal: true)
                                    .disableAutocorrection(true)
                                  .foregroundColor(Color("TextForeground"))
                                  .textFieldStyle(.roundedBorder)
                                  .frame(width: 120)
                            } label: {
                                Text("Lon↑:")
                                    .onTapGesture {
                                        lonUpText = "\(locationsHandler.lastLocation2D.longitude.formatted(.number.precision(.fractionLength(8))))"
                                    }
                            }.frame(width: 180, height: 30).padding(.trailing, 10)
                        }
                        .padding(.top, 10)
                        .frame(height : 30)
                        
                        HStack {
                            Spacer()
                            Image(systemName: "ellipsis.rectangle.fill")
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .frame(height : 30)
                        .onTapGesture {
                            isShowingTripExtras.toggle()
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 8)
                        .frame(height : 24)
                        
                        if isShowingTripExtras {

                            // Text("Trip is \(tripData.isClosed == "Y" ? "CLOSED" : "OPEN")")
                            HStack {
                                LabeledContent {
                                    TextField("", text: $tripData.gear)
                                      .foregroundColor(Color("TextForeground"))
                                      .textFieldStyle(.roundedBorder)
                                      .border(Color.gray, width: 1)
                                      .frame(width: 400)
                                      .multilineTextAlignment(.leading)
                                } label: {
                                    Text("Gear")
                                }
                                .frame(width: 600)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)

                            HStack {
                                LabeledContent {
                                    TextField("", text: $tripData.rectifyingunit)
                                      .foregroundColor(Color("TextForeground"))
                                      .textFieldStyle(.roundedBorder)
                                      .border(Color.gray, width: 1)
                                      .frame(width: 400)
                                      .multilineTextAlignment(.leading)
                                } label: {
                                    Text("Rectifying Unit/Model")
                                }.frame(width: 600)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            HStack {
                                LabeledContent {
                                    TextField("", text: $tripData.volts)
                                      .foregroundColor(Color("TextForeground"))
                                      .textFieldStyle(.roundedBorder)
                                      .border(Color.gray, width: 1)
                                      .frame(width: 100)
                                      .multilineTextAlignment(.leading)
                                } label: {
                                    Text("Volts")
                                }.frame(width: 300).padding(.trailing, 30)
                                LabeledContent {
                                    TextField("", text: $tripData.amps)
                                      .foregroundColor(Color("TextForeground"))
                                      .textFieldStyle(.roundedBorder)
                                      .border(Color.gray, width: 1)
                                      .frame(width: 100)
                                      .multilineTextAlignment(.leading)
                                } label: {
                                    Text("Amps")
                                }.frame(width: 260)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            HStack {
                                LabeledContent {
                                    TextField("", text: $tripData.shocktime)
                                      .foregroundColor(Color("TextForeground"))
                                      .textFieldStyle(.roundedBorder)
                                      .border(Color.gray, width: 1)
                                      .frame(width: 100)
                                      .multilineTextAlignment(.leading)
                                } label: {
                                    Text("Shock Time")
                                }.frame(width: 300)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            
                            HStack {
                                LabeledContent {
                                    TextField("", text: $tripData.anesthetic)
                                      .foregroundColor(Color("TextForeground"))
                                      .textFieldStyle(.roundedBorder)
                                      .border(Color.gray, width: 1)
                                      .frame(width: 100)
                                      .multilineTextAlignment(.leading)
                                } label: {
                                    Text("Anesthetic")
                                }.frame(width: 300).padding(.trailing, 30)

                                LabeledContent {
                                    TextField("", text: $tripData.dosage)
                                      .foregroundColor(Color("TextForeground"))
                                      .textFieldStyle(.roundedBorder)
                                      .border(Color.gray, width: 1)
                                      .frame(width: 100)
                                      .multilineTextAlignment(.leading)
                                } label: {
                                    Text("Dosage")
                                }.frame(width: 260)
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        }

                    }
                    .multilineTextAlignment(.center)
                    
                }  // ZStack
                .onAppear {
                    // print("width: \(geometry.size.width)")
                    latDownText = tripData.latDown.formatted(.number.precision(.fractionLength(8)))
                    lonDownText = tripData.lonDown.formatted(.number.precision(.fractionLength(8)))
                    latUpText   = tripData.latUp.formatted(.number.precision(.fractionLength(8)))
                    lonUpText   = tripData.lonUp.formatted(.number.precision(.fractionLength(8)))
                }
                onChange(of: latDownText) {
                    tripData.latDown = Double(latDownText) ?? 0.0
                }
                .onChange(of: lonDownText) {
                    tripData.lonDown = Double(lonDownText) ?? 0.0
                }
                .onChange(of: latUpText) {
                    tripData.latUp = Double(latUpText) ?? 0.0
                }
                .onChange(of: lonUpText) {
                    tripData.lonUp = Double(lonUpText) ?? 0.0
                }
                    
                .onChange(of: selectedStartTime) {
                    tripData.startTime = selectedStartTime.formatted(date: .omitted, time: .shortened)
                }
                .onChange(of: selectedEndTime) {
                    tripData.endTime = selectedEndTime.formatted(date: .omitted, time: .shortened)
                }
                    
                .onChange(of: tripData.watershed) {
                    if tripData.watershed.isEmpty {
                        isValidWatershed = false
                    } else {
                        isValidWatershed = true
                    }
                }
                .onChange(of: tripData.surveySection) {
                    if tripData.surveySection.isEmpty {
                        isValidSurveySection = false
                    } else {
                        isValidSurveySection = true
                    }
                }
                .onChange(of: tripData.tripType) {
                    if tripData.tripType.isEmpty {
                        isValidTripType = false
                    } else {
                        isValidTripType = true
                    }
                }
            }
        } // VStack
        .frame(height: isShowingTripExtras ? 410 : 160)  // 160
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
