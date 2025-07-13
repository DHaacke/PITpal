//
//  SpeciesSizeChartView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/8/25.
//

import Foundation
import SwiftUI
import SwiftData
import Charts

struct Series {
    var groupName: String
    var fishCount: [Int]
}


struct SpeciesSizeChartView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var path: [String]
    
    @State private var startDate: Date = Date()         // = "2024-04-01".toDate(format: "yyyy-MM-dd") // Date()
    @State private var endDate:   Date = Date()         // = "2024-04-30".toDate(format: "yyyy-MM-dd") // Date()
    @State private var selectedTitle: String = "Size Distribution Comparison"
    @State private var parsedTitle: String = ""
    @State private var selectedWatershed: String = ""
    @State private var selectedTripType: String = ""
    @State private var selectedSurveySection: String = ""
    @State private var selectedSpecies1: String = "LL"
    @State private var selectedSpecies2: String = "RB"
    @State private var selectedMinLength: Int = 0
    @State private var selectedMaxLength: Int = 0
    @State private var selectedBarColor1: Color = Color("TroutYellow")
    @State private var selectedBarColor2: Color = Color("TroutGreen")
    
    @State private var filteredTrips: [TripData] = []
    @State private var filteredFish: [FishData] = []
    @State private var matrix : [Series] = []
    @State private var isChartReady: Bool = false
    
    @State var pdfURL = URL(string: "https://bighornriver.org")!
    
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
    
    enum FocusedField {
        case int, dec
    }
    @FocusState private var focusedField: FocusedField?
    @State private var selectedMinLengthText: String = ""
    @State private var selectedMaxLengthText: String = ""

    
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
            .padding(.top, 20)
            .padding(.horizontal, 100)
            .padding(.bottom, 20)
            
            VStack(alignment: .leading) {
                
                HStack {
                    LabeledContent {
                        TextField("", text: $selectedTitle)
                          .foregroundColor(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 400)
                          .multilineTextAlignment(.leading)
                    } label: {
                        Text("Chart Title")
                    }.frame(width: 550)
                    Spacer()
                }.padding(.leading, 100)
                
                HStack() {
                    LabeledContent {
                        Picker("", selection: $selectedWatershed) {
                            Text("All Waters").tag("")
                            ForEach(watershedList, id: \.code) { water in
                                Text(water.name)
                                    .frame(width: 400)
                            }
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                    } label: {
                        Text("Watershed:")
                    }.frame(width: 400, height: 40)
                    Spacer()
                }.padding(.leading, 100)
                
                HStack {
                    LabeledContent {
                        Picker("", selection: $selectedTripType) {
                            Text("All Trip Types").tag("")
                            ForEach(tripTypeList, id: \.code) { type in
                                Text(type.name)
                                    .frame(width: 400)
                            }
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                    } label: {
                        Text("Trip Type:")
                    }.frame(width: 400, height: 40)
                }.padding(.leading, 100)
                
                HStack {
                    LabeledContent {
                        Picker("", selection: $selectedSurveySection) {
                            Text("All Survey Sections").tag("")
                            ForEach(surveySectionList, id: \.code) { section in
                                Text(section.name)
                                    .frame(width: 400)
                            }
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                    } label: {
                        Text("Survey Section:")
                    }.frame(width: 400, height: 40)
                }.padding(.leading, 100)
                
                HStack {
                    LabeledContent {
                        Picker("", selection: $selectedSpecies1) {
                            ForEach(speciesList, id: \.code) { species in
                                Text(species.name)
                                    .frame(width: 200)
                            }
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                    } label: {
                        Text("Species:")
                    }.frame(width: 300, height: 40).padding(.trailing, 50)
                    
                    LabeledContent {
                        Picker("", selection: $selectedSpecies2) {
                            ForEach(speciesList, id: \.code) { species in
                                Text(species.name)
                                    .frame(width: 200)
                            }
                        }.tint(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                    } label: {
                        Text("Species:")
                    }.frame(width: 300, height: 40)
                }.padding(.leading, 100)
                
                HStack {
                    LabeledContent {
                        TextField("", text: $selectedMinLengthText)
                            .focused($focusedField, equals: .int)
                            .numbersOnly($selectedMinLengthText, includeDecimal: false)
                            .disableAutocorrection(true)
                            .foregroundColor(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 90)
                            // .multilineTextAlignment(.leading)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Min Length")
                    }.frame(width: 250).padding(.trailing, 60)
                    
                    LabeledContent {
                        TextField("", text: $selectedMaxLengthText)
                            .focused($focusedField, equals: .int)
                            .numbersOnly($selectedMaxLengthText, includeDecimal: false)
                            .disableAutocorrection(true)
                            .foregroundColor(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 90)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Max Length")
                    }.frame(width: 250)
                }.padding(.bottom, 10).padding(.leading, 100)
                
                HStack {
                    LabeledContent {
                        ColorPicker("", selection: $selectedBarColor1)
                    } label: {
                        Text("1st Bar Color")
                    }.frame(width: 220).padding(.trailing, 50)
                    
                    LabeledContent {
                        ColorPicker("", selection: $selectedBarColor2)
                    } label: {
                        Text("2nd Bar Color")
                    }.frame(width: 220).padding(.trailing, 50)
                    
                    
                }.padding(.leading, 100)
                
                HStack(alignment: .center) {
                    Spacer()
                    Button( action: {
                        filteredFish = filterFish(species1: selectedSpecies1, species2: selectedSpecies2)
                      
                        let species1Fish = filteredFish.filter { $0.species == selectedSpecies1 }
                        let species2Fish = filteredFish.filter { $0.species == selectedSpecies2 }
                        
                        matrix.append(buildMatrix(species: selectedSpecies1, filteredFish: species1Fish))
                        matrix.append(buildMatrix(species: selectedSpecies2, filteredFish: species2Fish))
                        
                        parsedTitle = selectedTitle
                        if parsedTitle.contains("{WATERSHED}") {
                            parsedTitle = parsedTitle.replacingOccurrences(of: "{WATERSHED}", with: q.fetchNameFromCode(context: modelContext, model: "Watershed", code: selectedWatershed))
                        }
                        if parsedTitle.contains("{SECTION}") {
                            parsedTitle = parsedTitle.replacingOccurrences(of: "{SECTION}", with: q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: selectedSurveySection))
                        }
                        if parsedTitle.contains("{TYPE}") {
                            parsedTitle = parsedTitle.replacingOccurrences(of: "{TRIPTYPE}", with: q.fetchNameFromCode(context: modelContext, model: "TripType", code: selectedTripType))
                        }
                        
                        self.selectedMinLength = Int(selectedMinLength)
                        self.selectedMaxLength = Int(selectedMaxLength)
                        
                        self.isChartReady = true
                    }) {
                        Text("Chart")
                           .font(.system(size: 24, weight: .bold))
                           .frame(maxWidth: 80, minHeight: 36)
                           .foregroundColor(Color("TextForegroundWhite"))
                           .shadow(color: Color(.black), radius: 2, x: 1, y: 2)
                           .cornerRadius(10)
                   }
                   .padding(.bottom, 10)
                   .buttonStyle(.borderedProminent)
                    Spacer()
                }
                if isChartReady {
                    VStack {
                        SpeciesSizeBarChartView(
                            selectedTitle: $selectedTitle,
                            filteredFish: $filteredFish,
                            matrix: $matrix,
                            startDate: $startDate,
                            endDate: $endDate,
                            title: $parsedTitle,
                            species1: $selectedSpecies1,
                            species2: $selectedSpecies2,
                            color1: $selectedBarColor1,
                            color2: $selectedBarColor2,
                            pdfURL: $pdfURL
                        )
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    }
                    HStack {
                        Spacer()
                        if pdfURL.absoluteString != "https://bighornriver.org" {
                            ShareLink("Export PDF", item: URL(string: pdfURL.absoluteString)!)
                                .padding(.bottom, 8)
                        }
                        Spacer()
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
        }
        .padding(.horizontal, 20)
        .background(Color("AppBackground"))
        .frame(minWidth: 700, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        
        .onChange(of: selectedTripType) {
            tripTripType = selectedTripType
        }
        .onAppear {
            UITextField.appearance().clearButtonMode = .whileEditing

            selectedMinLength = lengthMin
            selectedMaxLength = lengthMax
            
            selectedMinLengthText = String(selectedMinLength)
            selectedMaxLengthText = String(selectedMaxLength)
            
            self.startDate = tripList.first?.date ?? Date()
            self.endDate   = tripList.last?.date ?? Date()
        }
    }

    
    func filterFish(species1: String, species2: String) -> [FishData] {
        // var filteredTrips : [TripData] = []
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
        if !species1.isEmpty && !species2.isEmpty {
            for trip in filteredTrips {
                for fish in trip.fish {
                    if ( (fish.species == species1 || fish.species == species2) && fish.length >= selectedMinLength && fish.length <= selectedMaxLength) {
                        filteredFish.append(fish)
                    }
                }
            }
        }
        return filteredFish
    }
    
    func buildMatrix(species: String, filteredFish: [FishData]) -> Series {
        
        let group6:  Int = filteredFish.filter { $0.species == species && $0.length <= 125 }.count
        let group8:  Int = filteredFish.filter { $0.species == species && $0.length >  125 && $0.length <= 203 }.count
        let group10: Int = filteredFish.filter { $0.species == species && $0.length >  203 && $0.length <= 253 }.count
        let group12: Int = filteredFish.filter { $0.species == species && $0.length >  253 && $0.length <= 305 }.count
        let group14: Int = filteredFish.filter { $0.species == species && $0.length >  305 && $0.length <= 355 }.count
        let group16: Int = filteredFish.filter { $0.species == species && $0.length >  355 && $0.length <= 406 }.count
        let group18: Int = filteredFish.filter { $0.species == species && $0.length >  406 && $0.length <= 458 }.count
        let group20: Int = filteredFish.filter { $0.species == species && $0.length >  458 && $0.length <= 500 }.count
        let group22: Int = filteredFish.filter { $0.species == species && $0.length >  500 }.count

        let series = Series(groupName: species, fishCount: [ group6, group8, group10, group12, group14, group16, group18, group20, group22 ])
        
        return series
    }
}

struct SpeciesSizeBarChartView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.colorScheme) var colorScheme

    @Binding var selectedTitle: String
    @Binding var filteredFish: [FishData]
    @Binding var matrix: [Series]
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var title: String
    @Binding var species1: String
    @Binding var species2: String
    @Binding var color1: Color
    @Binding var color2: Color
    @Binding var pdfURL: URL
    
    @State private var isShowingPDFAlert: Bool = false
    
    let xAxisLabels = ["6", "8", "10", "12", "14", "16", "18", "20", "22"]
    
    var body: some View {
        VStack {
            GroupBox {
                Text(title)
                    .font(.title)
                    .foregroundColor(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                    .padding(.bottom, 4)
                Text("\(startDate, format: .dateTime.day().month().year()) to \(endDate, format: .dateTime.day().month().year())")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                Chart(matrix, id: \.groupName) { fish in
                    ForEach(0..<fish.fishCount.count, id: \.self) { i in
                        let sizeGroup = 6 + (i * 2) // Assuming size groups are 6, 8, 10, ..., 22
                        BarMark(
                            x: .value("SizeGroup", String(sizeGroup)),
                            y: .value("Length", fish.fishCount[i]),
                            width: 30
                        )
                        .foregroundStyle(by: .value("Species", fish.groupName))
                        .position(by: .value("Species", fish.groupName))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                
                .chartXAxisLabel("Fish Size (inches)", alignment: .leading)
                .chartXAxis {
                    AxisMarks(values: xAxisLabels.map { $0 }) { value in
                        AxisValueLabel(centered: true)
                            .font(.headline)
                            .foregroundStyle(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                        AxisGridLine()
                        AxisTick()
                    }
                }
                .chartYAxisLabel("Fish Count", alignment: .topTrailing)
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisValueLabel()
                            .font(.headline)
                            .foregroundStyle(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
                            .offset(x: 10)
                    }
                }
                .chartForegroundStyleScale([
                    "LL": color1,  // Color("TroutYellow"),
                    "RB": color2   // Color("TroutGreen")
                ])
                .padding()
                Text("Total fish:  \(filteredFish.count)")
                    .font(.headline)
                    .foregroundColor(colorScheme == .dark ? Color("TextForegroundWhite") : Color("TextFieldBlackOnWhite"))
            }
            .frame(minWidth: 300, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
            .background(Color.black)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onTapGesture {
                self.isShowingPDFAlert = true
            }
            .alert(isPresented: $isShowingPDFAlert) {
                Alert(
                    title: Text("PDF Creation"),
                    message: Text("Would you like to print this chart to a PDF?"),
                    primaryButton: .default(Text("Yep!")) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.isShowingPDFAlert = false
                            pdfURL = createPDF(view: self)
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            .overlay {
                ZStack {
                    VStack {
                        HStack {
                            Spacer()
                            Image("FWPLogo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                                .shadow(radius: 16)
                                .padding(.trailing, 10)
                                .padding(.top, 10)
                        }
                        Spacer()
                    }
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 20)
        
    }
    
    func createPDF(view: SpeciesSizeBarChartView) -> URL {
            // Create PDF context
        let pdfMetaData = [
            kCGPDFContextCreator: "Chart PDF Creator",
            kCGPDFContextAuthor: "Doug Haacke"
        ]
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        // Define PDF page size
        let pageSize = CGSize(width: 842, height: 595) // A4 size
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize), format: format)
        
        // Create PDF data
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Create SwiftUI view
            let chartView = view
            
            // Convert SwiftUI view to UIImage
            let controller = UIHostingController(rootView: chartView)
            controller.view.frame = CGRect(x: 50, y: 50, width: 700, height: 500)
            
            // Render the view
            let view = controller.view!
            let targetRect = CGRect(x: 50, y: 50, width: 700, height: 500)
            view.drawHierarchy(in: targetRect, afterScreenUpdates: true)
        }
        
        let folderURL = URL.documentsDirectory.appending(path: "PDF", directoryHint: .isDirectory)
        do {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Error creating PDF directory (or directory already exists): \(error)")
        }
        
        let pdfURL = URL.documentsDirectory.appending(path: "PDF", directoryHint: .isDirectory).appending(path: "\(selectedTitle).pdf")
        do {
            try data.write(to: pdfURL)
            print("PDF saved at: \(pdfURL)")
        } catch {
            print("Error saving PDF: \(error)")
        }
        
        return pdfURL

    }
}
