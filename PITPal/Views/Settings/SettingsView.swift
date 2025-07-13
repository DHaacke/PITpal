//
//  SettingsView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    
    @Binding var path: [String]
    
    @Query(sort: \Watershed.name, order: .forward) var watersheds: [Watershed]
    @Query(sort: \SurveySection.name, order: .forward) var surveySections: [SurveySection]
    
    //   A P P E A R A N C E
    @AppStorage("darkMode") private var darkMode: Bool = false
    
    //   T R I P   D E F A U L T S
    @AppStorage("tripTripType") private var tripTripType: String = "M"
    @AppStorage("tripSurveySection") private var tripSurveySection: String = "U"
    @AppStorage("tripWatershed") private var tripWatershed: String = "BHR"
    @AppStorage("tripGar") private var tripGear: String = "Jet Boat, Anodes boom"
    @AppStorage("tripRectifyingunit") private var tripRectifyingunit: String = "SR Model VVP-15B"
    @AppStorage("tripVolts") private var tripVolts: String = "150"
    @AppStorage("tripAmps") private var tripAmps: String = "6"
    @AppStorage("tripShocktime") private var tripShocktime: String = "6"
    @AppStorage("tripAnesthetic") private var tripAnesthetic: String = "222"
    @AppStorage("tripDosage") private var tripDosage: String = ""
    
    //   P E R S O N N E L   A N D   G E A R
    @AppStorage("observers") private var observers: String = "Blythe, Blackburn, Olszewski"
    @AppStorage("volunteers") private var volunteers: String = "Doug Haacke"
  
    //   P I T   T A G S
    @AppStorage("usingPitTags") private var usingPitTags: Bool = true
    @AppStorage("pitManufacturer") private var pitManufacturer: String = "Biomark"
    @AppStorage("pitSize") private var pitSize: String = "8.0"
    @AppStorage("pitFrequency") private var pitFrequency: String = "134.2"
    @AppStorage("pitTagType") private var pitTagType: String = "Passive"
    @AppStorage("pitTagPrefix") private var pitTagPrefix: String = ""
    @AppStorage("pitTagSuffix") private var pitTagSuffix: String = ""
    @AppStorage("pitTagPlacement") private var pitTagPlacement: String = "Dorsal"

    
    @AppStorage("uomFishLength") private var uomFishLength: String = "mm"
    @AppStorage("lengthMin") private var lengthMin: Int = 0
    @AppStorage("lengthMax") private var lengthMax: Int = 2000
    @AppStorage("useBluetoothLength") private var useBluetoothLength: Bool = false

    @AppStorage("uomFishWeight") private var uomFishWeight: String = "gm"
    @AppStorage("weightMin") private var weightMin: Int = 0
    @AppStorage("weightMax") private var weightMax: Int = 1000
    @AppStorage("useBluetoothWeight") private var useBluetoothWeight: Bool = false
    
    @State private var isShowingSpeciesDetail = false
    @State private var isShowingSurveySectionDetail = false
    
    enum FocusedField {
        case int, dec
    }
    @FocusState private var focusedField: FocusedField?
    @State private var lengthMinText: String = "0"
    @State private var lengthMaxText: String = "3000"
    @State private var weightMinText: String = "0"
    @State private var weightMaxText: String = "2000"

    
    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    let angleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
            VStack {
                Form {
                    Section(header: Text("Appearance").font(.title2).foregroundStyle(.white)) {
                        LabeledContent {
                            Toggle("", isOn: $darkMode)
                                .frame(width: 50, height: 40)
                                .tint(Color.green)
                                .shadow(radius: 2)
                        } label: {
                            Text("Use Dark Mode")
                            Text("Enabling Dark Mode may help in bright sunlight.")
                                .font(.footnote)
                        }.frame(width: 500)
                    }
                    .listRowBackground(Color("CardBackground"))
                    
                    Section(header: Text("Trip Defaults \(tripTripType)").font(.title2).foregroundStyle(.white)) {
                        LabeledContent {
                            Picker("", selection: $tripTripType) {
                                Text("Marking").tag("M")
                                Text("Recapture").tag("R")
                            }.tint(Color("TextForegroundWhite"))
                        } label: {
                            Text("Trip Type:")
                        }.frame(width: 600, height: 40)
                        
                        LabeledContent {
                            Picker("", selection: $tripSurveySection) {
                                ForEach(surveySections, id: \.self) { section in
                                    Text(section.name).tag(section.code)
                                }
                            }.tint(Color("TextForegroundWhite"))
                        } label: {
                            Text("Survey Section:")
                        }.frame(width: 600, height: 40)
                        
                        LabeledContent {
                            Picker("", selection: $tripWatershed) {
                                ForEach(watersheds, id: \.self) { watershed in
                                    Text(watershed.name).tag(watershed.code)
                                }
                            }.tint(Color("TextForegroundWhite"))
                        } label: {
                            Text("Watershed:")
                        }.frame(width: 600, height: 40)
                        
                        LabeledContent {
                            TextField("", text: $tripGear)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 400)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("Gear")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            TextField("", text: $tripRectifyingunit)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 400)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("Rectifying Unit/Model")
                        }.frame(width: 600)
                        
                        
                        LabeledContent {
                            TextField("", text: $tripVolts)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("Volts")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            TextField("", text: $tripAmps)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("Amps")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            TextField("", text: $tripShocktime)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("Shock Time")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            TextField("", text: $tripAnesthetic)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("Anesthetic")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            TextField("", text: $tripDosage)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("Dosage")
                        }.frame(width: 600)
                    }
                    .listRowBackground(Color("CardBackground"))
                    
                    
                    Section(header: Text("Personnel").font(.title2).foregroundStyle(.white)) {
                        LabeledContent {
                            TextField("", text: $observers)
                                .foregroundColor(Color("TextForeground"))
                                .border(Color.gray, width: 1)
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 400)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("Observers")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            TextField("", text: $volunteers)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 400)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("Volunteers")
                        }.frame(width: 600)
                        
                        
                    }
                    .listRowBackground(Color("CardBackground"))
                    
                    
                    // P I T   T A G S
                    Section(header: Text("PIT TAGS").font(.title2).foregroundStyle(.white)) {
                        LabeledContent {
                            Toggle("", isOn: $usingPitTags)
                                .frame(width: 50, height: 40)
                                .tint(Color.green)
                                .shadow(radius: 2)
                        } label: {
                            Text("Using PIT tags")
                            Text("Enable this if you are using PIT tags for tagging fish.")
                                .font(.footnote)
                        }.frame(width: 600)
                        
                        LabeledContent {
                            TextField("", text: $pitManufacturer)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 400)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("PIT tag manufacturer")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            Picker("", selection: $pitSize) {
                                Text("8mm").tag("8.0")
                                Text("9mm").tag("9.0")
                                Text("10mm").tag("10.0")
                                Text("12mm").tag("12.0")
                            }.tint(Color("TextForegroundWhite"))
                        } label: {
                            Text("PIT tag size (length)")
                        }.frame(width: 600, height: 40)
                        
                        LabeledContent {
                            TextField("", value: $pitFrequency, formatter: decimalFormatter)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("PIT tag frequency")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            Picker("", selection: $pitTagType) {
                                Text("Passive").tag("Passive")
                                Text("Telemetry").tag("Telemetry")
                                Text("Other").tag("Other")
                            }.tint(Color("TextForegroundWhite"))
                        } label: {
                            Text("PIT tag type")
                        }.frame(width: 600, height: 40)
                        
                        LabeledContent {
                            TextField("", text: $pitTagPrefix)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 120)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("PIT tag prefix")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            TextField("", text: $pitTagSuffix)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .border(Color.gray, width: 1)
                                .frame(width: 120)
                                .multilineTextAlignment(.leading)
                        } label: {
                            Text("PIT tag suffix")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            Picker("", selection: $pitTagPlacement) {
                                Text("Dorsal sinus").tag("Dorsal")
                                Text("Ventral midline").tag("Ventral")
                                Text("Pectoral").tag("Pectoral")
                                Text("Cheek").tag("Cheek")
                            }.tint(Color("TextForegroundWhite"))
                        } label: {
                            Text("Typical PIT tag placement")
                        }.frame(width: 600, height: 40)
                        
                    }
                    .listRowBackground(Color("CardBackground"))
                    
                    
                    Section(header: Text("Length Measurements").font(.title2).foregroundStyle(.white)) {
                        LabeledContent {
                            Picker("", selection: $uomFishLength) {
                                Text("Millimeters").tag("mm")
                                Text("Grams").tag("gm")
                            }.tint(Color("TextForegroundWhite"))
                        } label: {
                            Text("Unit of Measurement for Length")
                        }.frame(width: 600, height: 40)
                        
                        LabeledContent {
                            TextField("", text: $lengthMinText)
                                .focused($focusedField, equals: .int)
                                .numbersOnly($lengthMinText, includeDecimal: false)
                                .disableAutocorrection(true)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                            Text(uomFishLength).frame(width: 40, alignment: .leading)
                        } label: {
                            Text("Min Length")
                        }.frame(width: 600)

                        LabeledContent {
                            TextField("", text: $lengthMaxText)
                                .focused($focusedField, equals: .int)
                                .numbersOnly($lengthMaxText, includeDecimal: false)
                                .disableAutocorrection(true)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                            Text(uomFishLength).frame(width: 40, alignment: .leading)
                        } label: {
                            Text("Max Length")
                        }.frame(width: 600)
                        
                        LabeledContent {
                            Toggle("", isOn: $useBluetoothLength)
                                .frame(width: 50, height: 40)
                                .tint(Color.green)
                                .shadow(radius: 2)
                        } label: {
                            Text("Use Bluetooth Length")
                        }.frame(width: 600)
                    }
                    .listRowBackground(Color("CardBackground"))
                    
                    
                    Section(header: Text("Weight Measurements").font(.title2).foregroundStyle(.white)) {
                        LabeledContent {
                            Picker("", selection: $uomFishWeight) {
                                Text("Grams").tag("gm")
                                Text("Kilograms").tag("kg")
                                Text("Ounces").tag("oz")
                                Text("Pounds").tag("lb")
                            }.tint(Color("TextForegroundWhite"))
                        } label: {
                            Text("Unit of Measurement for Weight")
                        }.frame(width: 600, height: 40)
                        
                        LabeledContent {
                            TextField("", text: $weightMinText)
                                .focused($focusedField, equals: .int)
                                .numbersOnly($weightMinText, includeDecimal: false)
                                .disableAutocorrection(true)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                            Text(uomFishWeight).frame(width: 40, alignment: .leading)
                        } label: {
                            Text("Min Weight")
                        }.frame(width: 600)
                        LabeledContent {
                            TextField("", text: $weightMaxText)
                                .focused($focusedField, equals: .int)
                                .numbersOnly($weightMinText, includeDecimal: false)
                                .disableAutocorrection(true)
                                .foregroundColor(Color("TextForeground"))
                                .textFieldStyle(.roundedBorder)
                                .frame(width: 100)
                                .multilineTextAlignment(.leading)
                            Text(uomFishWeight).frame(width: 40, alignment: .leading)
                        } label: {
                            Text("Max Weight")
                        }.frame(width: 600)
                        LabeledContent {
                            Toggle("", isOn: $useBluetoothWeight)
                                .frame(width: 50, height: 40)
                                .tint(Color.green)
                                .shadow(radius: 2)
                        } label: {
                            Text("Use Bluetooth Weight")
                        }.frame(width: 600)
                    }
                    .listRowBackground(Color("CardBackground"))
                    
                    
                    Section(header:
                            HStack {
                                Text("Species").font(.title2).foregroundStyle(.white)
                                Spacer()
                                Button("+") {
                                    isShowingSpeciesDetail = true
                                }.font(.system(size: 28, weight: .medium))
                            }
                    ) {
                        SpeciesListView(path: $path)
                    }
                    .listRowBackground(Color("CardBackground"))
                    
                    Section(header:
                            HStack {
                                Text("Survey Section").font(.title2).foregroundStyle(.white)
                                Spacer()
                                Button("+") {
                                    isShowingSurveySectionDetail = true
                                }.font(.system(size: 28, weight: .medium))
                            }
                    ) {
                        SurveySectionListView(path: $path)
                    }
                    .listRowBackground(Color("CardBackground"))
                    
                    
                } // end of form
                .onChange(of: lengthMinText) {
                    lengthMin = Int(lengthMinText) ?? 0
                }
                .onChange(of: lengthMaxText) {
                    lengthMax = Int(lengthMaxText) ?? 3000
                }
                .onChange(of: weightMinText) {
                    weightMin = Int(weightMinText) ?? 0
                }
                .onChange(of: weightMaxText) {
                    weightMax = Int(weightMaxText) ?? 2000
                }
                .toolbarBackground(Color("AppBackground"), for: .navigationBar)
                .toolbarBackground(.automatic, for: .navigationBar)
                .scrollContentBackground(.hidden)
                .background(Color("AppBackground"))
                .sheet(isPresented: $isShowingSpeciesDetail) {
                    let species = Species(code: "", fwpCode: "", name: "", imageName: "", color: "", active: "Y")
                    SpeciesDetailView(species: species, isAddingSpecies: true)
                        .onDisappear {
                            isShowingSpeciesDetail = false
                        }
                }
                .sheet(isPresented: $isShowingSurveySectionDetail) {
                    let surveySection = SurveySection(code: "", name: "", active: "Y")
                    SurveySectionDetailView(surveySection: surveySection, isAddingSurveySection: true)
                        .onDisappear {
                            isShowingSurveySectionDetail = false
                        }
                }
                
                Spacer()
                DoneButton(path: $path, nextView: K.MAINMENU)
                
            } // end of VStack
            .background(Color("AppBackground"))
            .frame(minWidth: 0, maxWidth: .infinity)
            
    } // end of View
        
}

#Preview {
    SettingsView(path: .constant([]))
}
