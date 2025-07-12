//
//  SurveySummaryView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/10/25.
//

import UIKit
import SwiftUI
import SwiftData

struct SurveySummaryView: View {

    @State private var startDate: Date = "2024-04-01".toDate(format: "yyyy-MM-dd") // Date()
    @State private var endDate:   Date = "2024-04-30".toDate(format: "yyyy-MM-dd") // Date()
    
    @State var pdfURL = URL(string: "https://bighornriver.org")!
    
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
                .padding(.top, 8)
                .padding(.horizontal, 100)
            Spacer()
            SurveySummaryReport(startDate: $startDate, endDate: $endDate, pdfURL: $pdfURL)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
            Spacer()
            if pdfURL.absoluteString != "https://bighornriver.org" {
                ShareLink("Export PDF", item: URL(string: pdfURL.absoluteString)!)
                    .padding(.bottom, 8)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

#Preview {
    SurveySummaryView()
}



struct SurveySummaryReport: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var pdfURL: URL
    
    @State private var tripList: [TripData] = []
    @State private var fishList: [FishData] = []
    @State private var isShowingPDFAlert: Bool = false
    
    @State private var isValidPDF: Bool = false
    
    let q = Queries()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                VStack {
                    Text("Survey Summary Report")
                        .font(.title)
                        .foregroundColor(.black)
                        .padding(.top, 8)
                    Text("\(startDate, format: .dateTime.day().month().year()) to \(endDate, format: .dateTime.day().month().year())")
                        .font(.headline)
                        .foregroundColor(.black)
                }
                .padding(.bottom, 15)

                VStack {
                    HStack {
                        Text("Watershed(s): ")
                            .frame(width: 200, alignment: .leading)
                            .bold()
                        Text(getWatershedNames())
                            .frame(width: 500, alignment: .leading)
                        Spacer()
                    }
                    HStack {
                        Text("Trip Types(s): ")
                            .frame(width: 200, alignment: .leading)
                            .bold()
                        Text(getTripTypeNames())
                            .frame(width: 500, alignment: .leading)
                        Spacer()
                    }
                    HStack {
                        Text("Survey Sections(s): ")
                            .frame(width: 200, alignment: .leading)
                            .bold()
                        Text(getSurveySectionNames())
                            .frame(width: 500, alignment: .leading)
                        Spacer()
                    }
                    HStack {
                        Text("Species: ")
                            .bold()
                            .frame(width: 200, alignment: .leading)
                        Spacer()
                    }
                    ForEach(getSpeciesArray(), id: \.name) { species in
                        HStack {
                            Text("\(species.name):")
                                .padding(.leading, 20)
                                .frame(width: 200, alignment: .leading)
                            Text("\(species.count)")
                                .bold()
                                .frame(width: 50, alignment: .trailing)
                                .padding(.trailing, 10)
                            Text("Mort: \(species.mort), Recaptured \(species.recaptured) for \(species.rate.formatted(.number.precision(.fractionLength(1)))) % Rate")
                                .bold()
                                .frame(width: 500, alignment: .leading)
                            Spacer()
                        }.padding(.leading, 30)
                    }
                    HStack {
                        Text("Total trout: ")
                            .bold()
                            .frame(width: 190, alignment: .leading)
                        Text("\(fishList.filter { $0.species == "RB" || $0.species == "LL" }.count)")
                            .bold()
                            .frame(width: 50, alignment: .trailing)
                        Spacer()
                    }
                    .padding(.bottom, 20)
                    
                    ForEach(tripList) { trip in
                        VStack {
                            HStack {
                                Text("\(trip.date.formatted(date: .long, time: .omitted)) - \(q.fetchNameFromCode(context: modelContext, model: "TripType", code: trip.tripType)),  \( getFishCountForDate(date: trip.date) ) trout")
                                    .bold()
                                Spacer()
                            }
                            HStack {
                                Text("Water Temp: \(trip.waterTemperature.formatted(.number.precision(.fractionLength(1))))°F, Discharge: \(trip.waterFlow.formatted(.number.precision(.fractionLength(0)))) cfs,  Gear: \(trip.gear),  Rectifying Unit: \(trip.rectifyingunit),  Volts: \(trip.volts),  Amps: \(trip.amps),  Shock Time (secs): \(trip.shocktime), Anesthetic: \(trip.anesthetic), Dosage: \(trip.dosage)")
                                    .font(.subheadline)
                                    .padding(.leading, 20)
                            }
                        }.padding(.bottom, 12)
                    }
                }.foregroundColor(.black)
                Spacer()

                .onTapGesture {
                    self.isShowingPDFAlert = true
                }
                .alert(isPresented: $isShowingPDFAlert) {
                    Alert(
                        title: Text("PDF Creation"),
                        message: Text("Would you like to print this chart to a PDF?"),
                        primaryButton: .default(Text("Yep!")) {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                pdfURL = createPDF(view: self)
                            }
                        },
                        secondaryButton: .cancel()
                    )
                }
            }
            .padding(.horizontal, 30)
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(Color.white.shadow(color: .black.opacity(0.8), radius: 3, x: 2, y: 4))
            .onChange(of: [startDate, endDate]) {
                tripList = q.fetchTripsByDateRange(context: modelContext, startDate: startDate, endDate: endDate)
                fishList = q.fetchFishByDateRange(context:  modelContext, startDate: startDate, endDate: endDate)
                print("Date changed. Trips: \(tripList.count), Fish: \(fishList.count)")
            }
            .task {
                tripList = q.fetchTripsByDateRange(context: modelContext, startDate: startDate, endDate: endDate)
                fishList = q.fetchFishByDateRange(context: modelContext, startDate: startDate, endDate: endDate)
            }
            .onTapGesture {
                self.isShowingPDFAlert = true
            }
        }
    }
    
    
    func getFishCountForDate(date: Date) -> Int {
        return fishList.filter { $0.date == date && ($0.species == "RB" || $0.species == "LL")}.count
    }
        
    
    func getWatershedNames() -> String {
        var buffer: String = ""
        for trip in tripList {
            let name = q.fetchNameFromCode(context: modelContext, model: "Watershed", code: trip.watershed)
            if !buffer.contains(name) {
                if !buffer.isEmpty {
                    buffer += ", "
                }
                buffer += name
            }
        }
        return buffer
    }
    
    func getTripTypeNames() -> String {
        var buffer: String = ""
        for trip in tripList {
            let name = q.fetchNameFromCode(context: modelContext, model: "TripType", code: trip.tripType)
            if !buffer.contains(name) {
                if !buffer.isEmpty {
                    buffer += ", "
                }
                buffer += name
            }
        }
        return buffer
    }
        
    func getSurveySectionNames() -> String {
        var buffer: String = ""
        for trip in tripList {
            let name = q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: trip.surveySection)
            if !buffer.contains(name) {
                if !buffer.isEmpty {
                    buffer += ", "
                }
                buffer += name

            }
        }
        return buffer
    }
    
    func getSpeciesArray() -> [SpeciesInfo] {
        var rainbowInfo: SpeciesInfo = SpeciesInfo(name: "Rainbow Trout", count: 0, mort: 0, recaptured: 0)
        var brownInfo: SpeciesInfo   = SpeciesInfo(name: "Brown Trout", count: 0, mort: 0, recaptured: 0)

        rainbowInfo.count = fishList.filter { $0.species == "RB" }.count
        brownInfo.count   = fishList.filter { $0.species == "LL" }.count
        
        rainbowInfo.mort = fishList.filter { $0.species == "RB" && $0.mort == "Y" }.count
        brownInfo.mort   = fishList.filter { $0.species == "LL" && $0.mort == "Y" }.count
        
        rainbowInfo.recaptured = fishList.filter { $0.species == "RB" && $0.mc != 0 }.count
        brownInfo.recaptured   = fishList.filter { $0.species == "LL" && $0.mc != 0 }.count
        
        return [rainbowInfo, brownInfo]
    }
    
    @MainActor
    func createPDF(view: SurveySummaryReport) -> URL {
            // Create PDF context
        let pdfMetaData = [
            kCGPDFContextCreator: "Report PDF Creator",
            kCGPDFContextAuthor: "Doug Haacke"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // Define PDF page size
        let pageSize = CGSize(width: 595, height: 842) // A4 size
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize), format: format)
        
        // Create PDF data
        let data = renderer.pdfData { context in
            context.beginPage()
           
            let reportView = view
            // Convert SwiftUI view to UIImage
            let controller = UIHostingController(rootView: reportView)
            controller.view.frame = CGRect(x: 10, y: 50, width: 595 * 2, height: 842 * 2)
            
            // Render the view
            let view = controller.view!
            let targetRect = CGRect(x: 10, y: 50, width: 595, height: 842)
            
            view.drawHierarchy(in: targetRect, afterScreenUpdates: true)
        }

        let folderURL = URL.documentsDirectory.appending(path: "PDF", directoryHint: .isDirectory)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating PDF directory (or directory already exists): \(error)")
        }
        
        let filename = "Survey Summary \(startDate.formatted(date: .long, time: .omitted)) to \(endDate.formatted(date: .long, time: .omitted)).pdf"
        let pdfURL = URL.documentsDirectory.appending(path: "PDF", directoryHint: .isDirectory).appending(path: filename)
        do {
            try data.write(to: pdfURL)
            print("PDF saved at: \(pdfURL)")
        } catch {
            print("Error saving PDF: \(error)")
        }
        
        return pdfURL
        
    }
}

struct SpeciesInfo {
    var name: String
    var count: Int
    var mort: Int
    var recaptured: Int
    var rate: Double {
        if count > 0 && recaptured > 0 {
            return Double(recaptured * 100) / Double(count)
        }
        return 0.0
    }
}
