//
//  ArchiveView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/22/25.
//

import SwiftUI
import SwiftData

struct ArchiveView: View {
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.modelContext) var modelContext
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(JSONManager.self) var jsonManager

    @Binding var path: [String]
    
    @State private var selectedTripId: Trip.ID? = nil
    @State private var isArchiving: Bool = false
    @State private var isStatusChanged: Bool = false

    @Query(sort: \Trip.date, order: .reverse) var tripList: [Trip]
    @Query(sort: \Watershed.name, order: .forward) var watersheds: [Watershed]
    @Query(sort: \TripType.name, order: .forward) var tripType: [TripType]
    @Query(sort: \SurveySection.name, order: .forward) var surveySections: [SurveySection]
    
    let q = Queries()
        
    var body: some View {
        VStack {
            VStack {
                Table(tripList, selection: $selectedTripId) {
                    TableColumn("Date") { trip in Text(trip.date, style: .date) }
                    TableColumn("Watershed") { trip in Text("\(q.fetchNameFromCode(context: modelContext, model: "Watershed", code: trip.watershed))") }
                    TableColumn("Section") { trip in Text("\(trip.surveySection)") }.width(60)
                    TableColumn("Type") { trip in Text("\(trip.tripType)") }.width(60)
                    TableColumn("Status") { trip in
                        if trip.isClosed == "N" {
                            Button("Open") {
                                selectedTripId = trip.id
                                if let trip = tripList.first(where: { $0.id == selectedTripId }) {
                                    trip.isClosed = "Y"
                                    try! modelContext.save()
                                }
                            }
                            .buttonStyle(.bordered)
                        } else {
                            Text("Closed")
                                .foregroundColor(colorScheme == .dark ? .gray : .black)
                        }
                    }.width(80)
                    TableColumn("Archive") { trip in
                        Button("Archive") {
                            isArchiving.toggle()
                            selectedTripId = trip.id
                            Task {
                                archiveTrip(trip: trip)
                            }
//                            if let trip = tripList.first(where: { $0.id == selectedTripId }) {
//                                trip.isClosed = "N"
//                                try! modelContext.save()
//                            }
                        }
                        .buttonStyle(.bordered)
                    }.width(100)
                }
                .scrollContentBackground(.hidden)
                .foregroundColor(Color("TextForegroundWhite"))
                .background(Color("CardBackground").gradient)
            }
            VStack {
                HStack {
                    VStack {
                        if isArchiving {
                            ProgressView().foregroundStyle(.white)
                            if let tripId = selectedTripId {
                                if let trip = tripList.first(where: { $0.id == tripId }) {
                                    Text("Archiving \(trip.date.formatted(date: .numeric, time: .omitted))-\(trip.watershed)-\(trip.surveySection)-\(trip.tripType)-\(trip.fish.count)")
                                        .foregroundColor(Color("TextForegroundWhite"))
                                }
                            }
                        }
                    }
                }.padding(.vertical, 10)

                Button(action: {
                    path = ["MAINMENU"]
                }) {
                    Text("Done")
                        .shadow(color: Color(.black), radius: 2, x: 2, y: 2)
                        .padding(.horizontal, 10)
                }
                .modifier(ActionButton())
            }
        }
        .background(Color("AppBackground"))
        .frame(minWidth: 0, maxWidth: .infinity)
    } // end of VStack
    
    
    func archiveTrip(trip: Trip) {
        let folderURL = URL.documentsDirectory.appending(path: "ARCHIVE", directoryHint: .isDirectory)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating ARCHIVE directory (or directory already exists): \(error)")
        }
        let filename = "\(trip.date.format(format: "YYYY-MM-dd"))-\(trip.watershed)-\(trip.surveySection)-\(trip.tripType)-\(trip.fish.count)"
        
        let buffer: String = trip.toJSON()
        
        let jsonData = buffer.data(using: .utf8)
        let jsonURL = URL.documentsDirectory.appending(path: "ARCHIVE", directoryHint: .isDirectory).appending(path: "\(filename).json")
        print("JSON URL:  \(jsonURL.path)")
        do {
            try jsonData?.write(to: jsonURL, options: [.atomic, .completeFileProtection])
            print("JSON exported successfully to \(jsonURL.path)")
        } catch {
            print("JSON: \(error.localizedDescription)")
        }
        
        Task(priority: .high) {
            let url = URL(string: "https://data.bighornriver.org/pitpal-trip")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let uploadData = buffer.data(using: .utf8)
            let task = URLSession.shared.uploadTask(with: request, from: uploadData) { (data, response, error) in
                if let error = error {
                    print ("Upload error: \(error.localizedDescription)")
                    return
                }
                guard let response = response as? HTTPURLResponse,
                    (200...299).contains(response.statusCode) else {
                    print ("Server error")
                    print(response.debugDescription)
                    return
                }
            }
            task.resume()
            print("Upload completed")
        }
        isArchiving = false
    }
        
}

#Preview {
    @Previewable @State var path: [String] = []
    ArchiveView(path: $path)
        .environment(NetworkMonitor())
        .environment(JSONManager())
        .environment(\.scenePhase, .active)
        .environment(\.colorScheme, .light)
}

/*
 //        for trip in filteredTrips {
 //            buffer += trip.toJSON() + ",\n"
 //        }
 */
