//
//  LengthChartView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/29/25.
//

import Foundation
import SwiftUI
import SwiftData
import Charts



struct LengthChartView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var path: [String]
    
    @State private var startDate: Date = "2024-04-01".toDate(format: "yyyy-MM-dd") // Date()
    @State private var endDate:   Date = "2024-04-30".toDate(format: "yyyy-MM-dd") // Date()
    @State private var selectedTitle: String = "{SPECIES} Size Distribution ({SECTION})"
    @State private var parsedTitle: String = ""
    @State private var selectedWatershed: String = ""
    @State private var selectedTripType: String = ""
    @State private var selectedSurveySection: String = ""
    @State private var selectedSpecies: String = ""
    @State private var selectedMinLength: Int = 0
    @State private var selectedMaxLength: Int = 0
    @State private var selectedBarColor: Color = .blue

    
    @State private var filteredTrips: [TripData] = []
    @State private var filteredFish: [FishData] = []
    @State private var fishChartData: [FishChartData] = []
    @State private var isChartReady: Bool = false
    
    @AppStorage("tripTripType") private var tripTripType: String = "M"
    @AppStorage("tripSurveySection") private var tripSurveySection: String = "U"
    @AppStorage("tripWatershed") private var tripWatershed: String = "BHR"
    @AppStorage("lengthMin") private var lengthMin: Int = 0
    @AppStorage("lengthMax") private var lengthMax: Int = 3000
    @AppStorage("uomFishLength") private var uomFishLength: String = "mm"
    @AppStorage("uomFishWeight") private var uomFishWeight: String = "gm"
    @AppStorage("tripSpecies") private var tripSpecies: String = "LL"
    
    @Query(sort: \Trip.date, order: .forward) var tripList: [Trip]
    @Query(filter: #Predicate<Species> { sp in sp.active == "Y"},  sort: \Species.name) var speciesList: [Species]
    @Query(sort: \TripType.name, order: .forward) var tripTypeList: [TripType]
    @Query(sort: \SurveySection.name, order: .forward) var surveySectionList: [SurveySection]
    @Query(sort: \Watershed.name, order: .forward) var watershedList: [Watershed]
    
    let q = Queries()
    
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
                
                HStack {
                    LabeledContent {
                        TextField("", text: $selectedTitle)
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 400)
                          .multilineTextAlignment(.leading)
                    } label: {
                        Text("Chart Title")
                    }.frame(width: 550)
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
                        TextField("", value: $selectedMinLength, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.leading)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Min Length")
                    }.frame(width: 250).padding(.trailing, 60)
                    
                    LabeledContent {
                        TextField("", value: $selectedMaxLength, formatter: NumberFormatter())
                          .foregroundColor(Color("TextForeground"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 70)
                          .multilineTextAlignment(.leading)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Max Length")
                    }.frame(width: 250)
                }.padding(.bottom, 10)
                
                HStack {
                    LabeledContent {
                        ColorPicker("", selection: $selectedBarColor)
                    } label: {
                        Text("Bar Color")
                    }.frame(width: 250).padding(.trailing, 60)
                }
                
                HStack(alignment: .center) {
                    Spacer()
                    ChartButton(onChartButtonTapped: {
                        filteredFish = filterFish()
                        print("Filtered Fish Found: \(filteredFish.count)")
                        fishChartData = buildMatrix(species: selectedSpecies)
                        
                        parsedTitle = selectedTitle
                        if parsedTitle.contains("{SPECIES}") {
                            parsedTitle = parsedTitle.replacingOccurrences(of: "{SPECIES}", with: q.fetchNameFromCode(context: modelContext, model: "Species", code: selectedSpecies))
                        }
                        if parsedTitle.contains("{WATERSHED}") {
                            parsedTitle = parsedTitle.replacingOccurrences(of: "{WATERSHED}", with: q.fetchNameFromCode(context: modelContext, model: "Watershed", code: selectedWatershed))
                        }
                        if parsedTitle.contains("{SECTION}") {
                            parsedTitle = parsedTitle.replacingOccurrences(of: "{SECTION}", with: q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: selectedSurveySection))
                        }
                        if parsedTitle.contains("{TYPE}") {
                            parsedTitle = parsedTitle.replacingOccurrences(of: "{TRIPTYPE}", with: q.fetchNameFromCode(context: modelContext, model: "TripType", code: selectedSpecies))
                        }
                        self.isChartReady = filteredFish.count > 0 ? true : false
                    })
                    Spacer()
                }
                if isChartReady {
                    VStack {
                        LengthBarChartView(
                            filteredFish: $filteredFish,
                            fishChartData: $fishChartData,
                            title: $parsedTitle,
                            species: $selectedSpecies,
                            color: $selectedBarColor
                        )
                            .padding(.top, 20)
                            .padding(.bottom, 20)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 100)
        }
        .padding(.horizontal, 20)
        .background(Color("AppBackground"))
        .frame(minWidth: 700, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        
        
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
        .onChange(of: selectedTripType) {
            tripTripType = selectedTripType
        }
        .onChange(of: selectedSpecies) {
            tripSpecies = selectedSpecies
        }
            
        .onAppear {
            print("LengthChartView appeared")
            selectedMinLength = lengthMin
            selectedMaxLength = lengthMax
            
            selectedWatershed = tripWatershed
            selectedTripType  = tripTripType
            selectedSurveySection = tripSurveySection
        }
    }

    
    func filterFish() -> [FishData] {
        var filteredTrips : [TripData] = []
        var filteredFish  : [FishData] = []
        
        for trip in tripList {
            if (startDate.millisecondsSince1970...endDate.millisecondsSince1970).contains(trip.date.millisecondsSince1970) &&
               (selectedWatershed.isEmpty || trip.watershed == selectedWatershed) &&
               (selectedTripType.isEmpty || trip.tripType == selectedTripType) &&
               (selectedSurveySection.isEmpty || trip.surveySection == selectedSurveySection)
            {
                let tripData = trip.deepCopy()
                filteredTrips.append(tripData)
            }
        }
        if !selectedSpecies.isEmpty {
            for trip in filteredTrips {
                filteredFish.append(contentsOf: trip.fish.filter { $0.species == selectedSpecies && $0.length >= selectedMinLength && $0.length <= selectedMaxLength })
            }
        } else {
            for trip in filteredTrips {
                filteredFish.append(contentsOf: trip.fish)
            }
        }
        return filteredFish
    }
    
    func buildMatrix(species: String) -> [FishChartData] {
        DispatchQueue.main.async {
            fishChartData.removeAll()
            fishChartData.append(FishChartData(id:  1,  sizeGroup:  6,  count: filteredFish.filter { $0.length <= 125}.count, species: species))
            fishChartData.append(FishChartData(id:  2,  sizeGroup:  8,  count: filteredFish.filter { $0.length >  125 && $0.length <= 203 }.count ,species: species))
            fishChartData.append(FishChartData(id:  3,  sizeGroup: 10,  count: filteredFish.filter { $0.length >  203 && $0.length <= 253 }.count ,species: species))
            fishChartData.append(FishChartData(id:  4,  sizeGroup: 12,  count: filteredFish.filter { $0.length >  253 && $0.length <= 305 }.count ,species: species))
            fishChartData.append(FishChartData(id:  5,  sizeGroup: 14,  count: filteredFish.filter { $0.length >  305 && $0.length <= 355 }.count ,species: species))
            fishChartData.append(FishChartData(id:  6,  sizeGroup: 16,  count: filteredFish.filter { $0.length >  355 && $0.length <= 406 }.count ,species: species))
            fishChartData.append(FishChartData(id:  7,  sizeGroup: 18,  count: filteredFish.filter { $0.length >  406 && $0.length <= 458 }.count ,species: species))
            fishChartData.append(FishChartData(id:  8,  sizeGroup: 20,  count: filteredFish.filter { $0.length >  458 }.count, species: species))
        }
        return fishChartData
    }
}

#Preview {
    LengthChartView(path: .constant([]))
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}

struct LengthBarChartView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var filteredFish: [FishData]
    @Binding var fishChartData: [FishChartData]
    @Binding var title: String
    @Binding var species: String
    @Binding var color: Color
    
    var body: some View {
        VStack {
            GroupBox {
                Text(title)
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                Chart(fishChartData, id: \.id) { data in
                    BarMark(
                        x: .value("Size", data.sizeGroup),
                        y: .value("Count", data.count),
                        width: 40)
                    .foregroundStyle(color.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
                .chartXScale(domain: [6, 24])
                // .chartYScale(domain: [minStockPrice ?? 0, maxStockPrice ?? 0])
                .chartXAxisLabel("Fish Size (inches)", alignment: .leading)
                .chartXAxis {
                    AxisMarks(values: [6, 8, 10, 12, 14, 16, 18, 20, 22, 24]) { value in
                        AxisValueLabel()
                            .foregroundStyle(.black)
                            .offset(x: -8)
                    }
                }
                .chartYAxisLabel("Fish Count", alignment: .topTrailing)
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisValueLabel()
                            .foregroundStyle(.black)
                            .offset(x: 10)
                    }
                }
            }
            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 200, maxHeight: .infinity)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
            .padding(.horizontal, 12)
            .padding(.vertical, 20)
        VStack {
            PDFButton(onPDFButtonTapped: {
                print("Creating PDF...")
                createPDF()
            })
            .padding(.bottom, 10)
        }
    }
    
    func createPDF() {
            // Create PDF context
        let pdfMetaData = [
            kCGPDFContextCreator: "Chart PDF Creator",
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
            
            // Create SwiftUI view
            let chartView = LengthBarChartView(
                filteredFish: $filteredFish,
                fishChartData: $fishChartData,
                title: $title,
                species: $species,
                color: $color
            )
            
            // Convert SwiftUI view to UIImage
            let controller = UIHostingController(rootView: chartView)
            controller.view.frame = CGRect(x: 50, y: 50, width: 495, height: 500)
            
            // Render the view
            let view = controller.view!
            let targetRect = CGRect(x: 50, y: 50, width: 495, height: 500)
            view.drawHierarchy(in: targetRect, afterScreenUpdates: true)
            
//            // Add a large group title
//            let title = "Sales Chart"
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.boldSystemFont(ofSize: 24),
//                .foregroundColor: UIColor.black
//            ]
//            title.draw(at: CGPoint(x: 50, y: 20), withAttributes: attributes)
        }
        
//        let tempDir = FileManager.default.temporaryDirectory
//        let fileURL = tempDir.appendingPathComponent("\(title).pdf")
        
        let folderURL = URL.documentsDirectory.appending(path: "PDF", directoryHint: .isDirectory)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating PDF directory (or directory already exists): \(error)")
        }
        
        let pdfURL = URL.documentsDirectory.appending(path: "PDF", directoryHint: .isDirectory).appending(path: "\(title).pdf")
        do {
            try data.write(to: pdfURL)
            print("PDF saved at: \(pdfURL)")
        } catch {
            print("Error saving PDF: \(error)")
        }

    }
}
    
/*
 struct FishData: Identifiable {
 var id: Int
 var sizeGroup: Int
 var count: Int
 var species: String
 }
*/
