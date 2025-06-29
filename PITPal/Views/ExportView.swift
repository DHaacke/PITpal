//
//  ExportView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/28/25.
//

import Foundation
import SwiftUI
import SwiftData

struct ExportView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var path: [String]
    
    @State private var startDate: Date = Date()
    @State private var endDate:   Date = Date()
    @State private var selectedFormat: String = K.EXPORT_JSON
    @State private var selectedWatershed: String = ""
    @State private var selectedTripType: String = ""
    @State private var selectedSurveySection: String = ""
    @State private var selectedSpecies: String = ""
    @State private var selectedMinWeight: Int = 0
    @State private var selectedMaxWeight: Int = 0
    @State private var selectedMinLength: Int = 0
    @State private var selectedMaxLength: Int = 0
    
    @State private var exportedTrips: [Trip] = []
    @State private var exportFilename: String = ""
    @State private var isExporting: Bool = false
    @State private var isShowingExportError: Bool = false
    @State private var exportingMessage: String = ""
    
    @AppStorage("tripTripType") private var tripTripType: String = "M"
    @AppStorage("tripSurveySection") private var tripSurveySection: String = "U"
    @AppStorage("tripWatershed") private var tripWatershed: String = "BHR"
    
    @AppStorage("lengthMin") private var lengthMin: Int = 0
    @AppStorage("lengthMax") private var lengthMax: Int = 2000
    @AppStorage("weightMin") private var weightMin: Int = 0
    @AppStorage("weightMax") private var weightMax: Int = 1000
    @AppStorage("uomFishLength") private var uomFishLength: String = "mm"
    @AppStorage("uomFishWeight") private var uomFishWeight: String = "gm"
    
    @Query(filter: #Predicate<Species> { sp in sp.active == "Y"},  sort: \Species.name) var speciesList: [Species]
    @Query(sort: \TripType.name, order: .forward) var tripTypeList: [TripType]
    @Query(sort: \SurveySection.name, order: .forward) var surveySectionList: [SurveySection]
    @Query(sort: \Watershed.name, order: .forward) var watershedList: [Watershed]
    @Query(sort: \Trip.date, order: .forward) var tripList: [Trip]
    
    var body: some View {
        VStack {
            HStack {
                DatePicker(
                    "Start Date:",
                    selection: $startDate,
                    displayedComponents: [.date]
                ).datePickerStyle(.compact).frame(width: 250)
                Spacer()
                DatePicker(
                    "End Date:",
                    selection: $endDate,
                    displayedComponents: [.date]
                ).datePickerStyle(.compact).frame(width: 250)
            }
            .padding(.top, 40)
            .padding(.horizontal, 100)
            .padding(.bottom, 40)
            
            VStack(alignment: .leading) {
                
                HStack() {
                    LabeledContent {
                        Picker("", selection: $selectedFormat) {
                            Text(K.EXPORT_CSV).tag("CSV")
                                .frame(width: 400)
                            Text(K.EXPORT_JSON).tag("JSON")
                                .frame(width: 400)
                        }
                        .tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                        // .tint(Color("TextForegroundWhite"))
                    } label: {
                        Text("File format:")
                    }.frame(width: 400, height: 40)
                    Spacer()
                }
                
                HStack() {
                    LabeledContent {
                        Picker("", selection: $selectedWatershed) {
                            Text("All Waters").tag("")
                            ForEach(watershedList, id: \.code) { water in
                                Text(water.name)
                                    .frame(width: 400)
                            }
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                    } label: {
                        Text("Watershed:")
                    }.frame(width: 400, height: 40)
                    Spacer()
                }
                
                HStack {
                    LabeledContent {
                        Picker("", selection: $selectedTripType) {
                            Text("All Trip Types").tag("")
                            ForEach(tripTypeList, id: \.code) { type in
                                Text(type.name)
                                    .frame(width: 400)
                            }
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                    } label: {
                        Text("Trip Type:")
                    }.frame(width: 400, height: 40)
                }
                
                HStack {
                    LabeledContent {
                        Picker("", selection: $selectedSurveySection) {
                            Text("All Survey Sections").tag("")
                            ForEach(surveySectionList, id: \.code) { section in
                                Text(section.name)
                                    .frame(width: 400)
                            }
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                    } label: {
                        Text("Survey Section:")
                    }.frame(width: 400, height: 40)
                }
                
                HStack {
                    LabeledContent {
                        Picker("", selection: $selectedSpecies) {
                            Text("All Species").tag("")
                            ForEach(speciesList, id: \.code) { species in
                                Text(species.name)
                                    .frame(width: 400)
                            }
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color.black)
                    } label: {
                        Text("Species:")
                    }.frame(width: 400, height: 40)
                }
                
                HStack {
                    LabeledContent {
                        TextField("", value: $selectedMinWeight, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishWeight).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Min Weight")
                    }.frame(width: 250).padding(.trailing, 60)
                    
                    LabeledContent {
                        TextField("", value: $selectedMaxWeight, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishWeight).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Max Weight")
                    }.frame(width: 250)
                }
                
                HStack {
                    LabeledContent {
                        TextField("", value: $selectedMinLength, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Min Length")
                    }.frame(width: 250).padding(.trailing, 60)
                    
                    LabeledContent {
                        TextField("", value: $selectedMaxLength, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Max Length")
                    }.frame(width: 250)
                }.padding(.bottom, 50)
                
                HStack {
                    LabeledContent {
                        TextField("", text: $exportFilename)
                          .foregroundColor(Color("TextForeground"))
                          .border(Color.gray, width: 1)
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 400)
                          .multilineTextAlignment(.leading)
                    } label: {
                        Text("Exported Filename:")
                    }.frame(width: 600).padding(.bottom, 60)
                }
                
                HStack(alignment: .center) {
                    Spacer()
                    ExportButton(onExportButtonTapped: {
                        print("Export Button Tapped")
                        if selectedFormat == K.EXPORT_JSON {
                            exportJSON()
                        } else if selectedFormat == K.EXPORT_CSV {
                            exportCSV()
                        }
                    })
                        .frame(width: 140, height: 45)
                    Spacer()
                }
                
                            
                if isExporting {
                    HStack(alignment: .center) {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                }
                Spacer()
                Text(exportingMessage)
                    .foregroundColor(isShowingExportError ? .red : Color("TextForegroundWhite"))
            }
            .padding(.horizontal, 100)
        }
        
        .padding(.horizontal, 20)
        .frame(minWidth: 600, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("AppBackground"))
        .onChange(of: startDate) {
            var dateComponents = DateComponents()
            dateComponents.month = 3 // Add 3 months
            let calendar = Calendar.current
            if let futureDate = calendar.date(byAdding: dateComponents, to: self.startDate) {
                self.endDate = futureDate
            } else {
                print("Error calculating future date.")
            }
        }
        .onAppear {
            selectedMinWeight = weightMin
            selectedMaxWeight = weightMax
            selectedMinLength = lengthMin
            selectedMaxLength = lengthMax
            
            selectedWatershed = tripWatershed
            selectedTripType  = tripTripType
            selectedSurveySection = tripSurveySection
            
            updateFilename()
        }
        .onChange(of: startDate) {
            updateFilename()
        }
        .onChange(of: endDate) {
            updateFilename()
        }
        .onChange(of: selectedWatershed) {
            updateFilename()
        }
        .onChange(of: selectedTripType) {
            updateFilename()
        }
        .onChange(of: selectedSurveySection) {
            updateFilename()
        }
        .onChange(of: selectedSpecies) {
            updateFilename()
        }
        
            
            
    }
    
    func updateFilename() {
        self.exportFilename = ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let startDateString = dateFormatter.string(from: self.startDate)
        let endDateString   = dateFormatter.string(from: self.endDate)
        self.exportFilename = "\(startDateString)-\(endDateString)_"
        if !self.selectedWatershed.isEmpty {
            self.exportFilename += "\(self.selectedWatershed)_"
        }
        if !self.selectedTripType.isEmpty {
            self.exportFilename += "\(self.selectedTripType)_"
        }
        if !self.selectedSurveySection.isEmpty {
            self.exportFilename += "\(self.selectedSurveySection)_"
        }
        if !self.selectedSpecies.isEmpty {
            self.exportFilename += "\(self.selectedSpecies)"
        }
        // self.exportFilename += "\(tripList.count)_trips"
    }
    
    func filterTrips() -> [Trip] {
        // Filter trips based on selected criteria
        var filteredTrips : [Trip] = tripList

        filteredTrips = tripList.filter { trip in (startDate.millisecondsSince1970...endDate.millisecondsSince1970).contains(trip.date.millisecondsSince1970) }

        if !selectedWatershed.isEmpty {
            filteredTrips = filteredTrips.filter { $0.watershed == selectedWatershed }
        }
        
        if !selectedTripType.isEmpty {
            filteredTrips = filteredTrips.filter { $0.tripType == selectedTripType }
        }

        if !selectedSurveySection.isEmpty {
            filteredTrips = filteredTrips.filter { $0.surveySection == selectedSurveySection }
        }

        if !selectedSpecies.isEmpty {
            var filteredFish : [Fish] = []
            for trip in filteredTrips {
                filteredFish = trip.fish.filter { $0.species == selectedSpecies }
                trip.fish = filteredFish
            }
        }

        return filteredTrips
    }
    
    func exportJSON() {
        // Implement JSON export logic here
        self.exportedTrips.removeAll()
        
        // Filter trips based on selected criteria
        let filteredTrips = filterTrips()
        print("Exporting JSON... \(filteredTrips.count)")
        
        self.isExporting = true
        
        // Create the json folder if it doesn't exist
        let folderURL = URL.documentsDirectory.appending(path: "JSON", directoryHint: .isDirectory)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating JSON directory (or directory already exists): \(error)")
        }
        
        var buffer = ""

        for trip in filteredTrips {
            buffer += trip.toJSON() + ",\n"
        }
        let jsonData = buffer.data(using: .utf8)
        let jsonURL = URL.documentsDirectory.appending(path: "JSON", directoryHint: .isDirectory).appending(path: "\(self.exportFilename).json")
        do {
            try jsonData?.write(to: jsonURL, options: [.atomic, .completeFileProtection])
            self.exportingMessage = "JSON exported successfully to \(jsonURL.path)"
            self.isShowingExportError = false
        } catch {
            print("JSON: \(error.localizedDescription)")
            self.exportingMessage = "Error exporting JSON: \(error.localizedDescription)"
            self.isShowingExportError = true
        }
        self.isExporting = false
    }
    
    func exportCSV() {
        self.exportedTrips.removeAll()
        let filteredTrips = filterTrips()
        var buffer = ""
        
        print("Exporting CSV... \(filteredTrips.count)")
        
        self.isExporting = true
        
        buffer += "date,type,section,watershed,equipment,lat_down,lon_down,lat_up,long_up,length,start,end,temp,cfs,date,pitTag,lat,lon,species,fwpSpecies,weight,length,gender,doa,hookScar,comment\n"
        for trip in filteredTrips {
            print("Exporting \(trip.fish.count) fish for trip \(trip.id)")
            for fish in trip.fish {
                buffer += trip.toCSV() + fish.toCSV() + "\n"
            }
        }
        
        // Create the csv folder if it doesn't exist
        let folderURL = URL.documentsDirectory.appending(path: "CSV", directoryHint: .isDirectory)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating CSV directory (or directory already exists): \(error)")
        }
        
        let csvData = buffer.data(using: .utf8)
        let csvURL = URL.documentsDirectory.appending(path: "CSV", directoryHint: .isDirectory).appending(path: "\(self.exportFilename).csv")
        do {
            try csvData?.write(to: csvURL, options: [.atomic, .completeFileProtection])
            self.exportingMessage = "CSV exported successfully to \(csvURL.path)"
            self.isShowingExportError = false
        } catch {
            print("CSV: \(error.localizedDescription)")
            self.exportingMessage = "Error exporting CSV: \(error.localizedDescription)"
            self.isShowingExportError = true
        }
        self.isExporting = false
    }
}

#Preview {
    ExportView(path: .constant([]))
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}
