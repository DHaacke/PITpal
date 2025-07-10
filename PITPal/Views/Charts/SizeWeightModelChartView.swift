//
//  SizeWeightModelChartView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/8/25.
//

import Foundation
import SwiftUI
import SwiftData
import Charts



struct SizeWeightModelChartView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var path: [String]
    
    @State private var selectedTitle: String = "Length-Weight Scatter Plot {SECTION}"
    @State private var selectedWatershed: String = ""
    @State private var selectedTripType: String = ""
    @State private var selectedSurveySection: String = ""
    
    @State private var fishList: [FishData] = []
    @State private var isChartReady: Bool = false

    
    @Query(sort: \TripType.name, order: .forward) var tripTypeList: [TripType]
    @Query(sort: \Watershed.name, order: .forward) var watershedList: [Watershed]
    @Query(sort: \SurveySection.name, order: .forward) var surveySectionList: [SurveySection]
    
    let q = Queries()

    var body: some View {
        VStack {
            HStack {
                LabeledContent {
                    TextField("", text: $selectedTitle)
                      .foregroundColor(Color("TextForeground"))
                      .textFieldStyle(.roundedBorder)
                      .frame(width: 300)
                      .multilineTextAlignment(.leading)
                } label: {
                    Text("Chart Title")
                }.frame(width: 400)
            }.padding(.leading, 100)
            
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
            }.padding(.leading, 100)
            
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
            }.padding(.leading, 100)
            
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

            }.padding(.leading, 100)
            
            ChartButton(onChartButtonTapped: {
                // fishList = q.fetchFishWithLengthAndWeight(context: modelContext)
                fishList = q.fetchFishWithLengthAndWeight(context: modelContext, tripType: selectedTripType, watershed: selectedWatershed, surveySection: selectedSurveySection )
                
                var parsedTitle = self.selectedTitle
                if parsedTitle.contains("{WATERSHED}") {
                    parsedTitle = parsedTitle.replacingOccurrences(of: "{WATERSHED}", with: q.fetchNameFromCode(context: modelContext, model: "Watershed", code: selectedWatershed))
                }
                if parsedTitle.contains("{SECTION}") {
                    parsedTitle = parsedTitle.replacingOccurrences(of: "{SECTION}", with: q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: selectedSurveySection))
                }
                if parsedTitle.contains("{TYPE}") {
                    parsedTitle = parsedTitle.replacingOccurrences(of: "{TRIPTYPE}", with: q.fetchNameFromCode(context: modelContext, model: "TripType", code: selectedTripType))
                }
                selectedTitle = parsedTitle
                
                isChartReady = true
            })
            .padding(.bottom, 20)

            if isChartReady {
                VStack {
                    SizeWeightChartView(
                        selectedTitle: $selectedTitle,
                        selectedWatershed: $selectedWatershed,
                        selectedTripType: $selectedTripType,
                        selectedSurveySection: $selectedSurveySection,
                        fishList: $fishList
                    )
                }
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}


struct SizeWeightChartView: View {
    @Environment(\.modelContext) var modelContext

    @Binding var selectedTitle: String
    @Binding var selectedWatershed: String
    @Binding var selectedTripType: String
    @Binding var selectedSurveySection: String
    @Binding var fishList: [FishData]
    
    @State private var isShowingPDFAlert: Bool = false
    
    var body: some View {
        VStack {
            GroupBox {
                Text("\(selectedTitle)")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.bottom, 14)
                Chart(fishList) { fish in
                    PointMark(
                        x: .value("Length", fish.length),
                        y: .value("Weight", fish.weight)
                    )
                    .position(by: .value("Species", fish.species))
                    .foregroundStyle(fish.species == "LL" ? .orange : .green)
                    .symbolSize(CGSize(width: 3, height: 3)) // Adjust point size
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .chartXAxisLabel("Fish Length (mm)")
                .chartXAxis {
                    AxisMarks(values:  .stride(by: 100)) { value in
                        AxisGridLine()
                        AxisValueLabel()
                            .font(.headline)
                            .foregroundStyle(.black)
                            .offset(x: -8)
                    }
                }
                .chartYAxisLabel("Fish Weight (g)")
                .chartYAxis {
                    AxisMarks(values: .stride(by: 500)) { value in
                        AxisGridLine()
                        AxisValueLabel()
                            .font(.headline)
                            .foregroundStyle(.black)
                            .offset(x: 10)
                    }
                }
                .frame(height: 350)
                
                Text("Total fish:  \(fishList.count)")
                    .font(.headline)
                    .foregroundColor(.black)
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
            .padding(.horizontal, 20)
            .frame(minWidth: 700, maxWidth: .infinity, minHeight: 300, maxHeight: .infinity)
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
                            createPDF()
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 20)
        
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
        let pageSize = CGSize(width: 842, height: 595) // A4 size
        let renderer = UIGraphicsPDFRenderer(bounds: CGRect(origin: .zero, size: pageSize), format: format)
        
        // Create PDF data
        let data = renderer.pdfData { context in
            context.beginPage()
            
            // Create SwiftUI view
            let chartView = SizeWeightChartView(
                selectedTitle: $selectedTitle,
                selectedWatershed: $selectedWatershed,
                selectedTripType: $selectedTripType,
                selectedSurveySection: $selectedSurveySection,
                fishList: $fishList
            )
            
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

    }
}
