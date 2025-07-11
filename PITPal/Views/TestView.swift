//
//  TestView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import Foundation
import SwiftUI
import Charts

struct PDFTestView: View {
    @State private var startDate: Date = "2024-04-01".toDate(format: "yyyy-MM-dd") // Date()
    @State private var endDate:   Date = "2024-04-30".toDate(format: "yyyy-MM-dd") // Date()
    
    var body: some View {
        ShareLink("Export PDF", item: render())
            .font(.headline)
            .foregroundStyle(.black)
    }

    func render() -> URL {
        // 1: Render Hello World with some modifiers
        let renderer = ImageRenderer(
            content: SurveySummaryReport(
                startDate: $startDate,
                endDate: $endDate
            )
        )

        // 2: Save it to our documents directory
        let url = URL.documentsDirectory.appending(path: "output.pdf")

        // 3: Start the rendering process
        renderer.render { size, context in
            // 4: Tell SwiftUI our PDF should be the same size as the views we're rendering
            var box = CGRect(x: 0, y: 0, width: size.width, height: size.height)

            // 5: Create the CGContext for our PDF pages
            guard let pdf = CGContext(url as CFURL, mediaBox: &box, nil) else {
                return
            }

            // 6: Start a new PDF page
            pdf.beginPDFPage(nil)

            // 7: Render the SwiftUI view data onto the page
            context(pdf)

            // 8: End the page and close the file
            pdf.endPDFPage()
            pdf.closePDF()
        }

        return url
    }
}

struct FontPreview: View {
    let textStyles: [(Font.TextStyle, String)] = [
        (.largeTitle, "Large Title"),
        (.title, "Title 1"),
        (.title2, "Title 2"),
        (.title3, "Title 3"),
        (.headline, "Headline"),
        (.subheadline, "Subheadline"),
        (.body, "Body"),
        (.callout, "Callout"),
        (.footnote, "Footnote"),
        (.caption, "Caption 1"),
        (.caption2, "Caption 2")
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(textStyles, id: \.1) { style, name in
                    Text(name)
                        .font(.system(style))
                        .padding(.horizontal)
                }
            }
            .padding(.vertical)
        }
        .navigationTitle("iOS Text Styles")
        .background(Color("AppBackground"))
    }
}

struct FontPreview_Previews: PreviewProvider {
    static var previews: some View {
        FontPreview()
    }
}

struct TestView: View {
    
    var body: some View {
        let fishArray = [
            (species: "LL", fishCount:[81, 234, 64, 227, 103, 247, 819, 339, 125]),
            (species: "RB", fishCount:[21, 10, 1, 93, 62, 52, 220, 268, 175])
        ]
        // let xAxisLabels = [6, 8, 10, 12, 14, 16, 18, 20, 22]
        let xAxisLabels = ["6", "8", "10", "12", "14", "16", "18", "20", "22"]
//        Species: LL, 81, 234, 64, 227, 103, 247, 819, 339, 125
//        Species: RB, 21, 10, 1, 93, 62, 52, 220, 268, 175
        
        Chart(fishArray, id: \.species) { fish in
            ForEach(0..<fish.fishCount.count, id: \.self) { i in
                let sizeGroup = 6 + (i * 2) // Assuming size groups are 6, 8, 10, ..., 22
                BarMark(
                    x: .value("SizeGroup", String(sizeGroup)),
                    y: .value("Length", fish.fishCount[i]),
                    width: 30
                )
                .foregroundStyle(by: .value("Species", fish.species))
                .position(by: .value("Species", fish.species))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding()
        // .chartXScale(domain: [6, 22])
        .chartXAxisLabel("Fish Size (inches)", alignment: .leading)
        .chartXAxis {
            AxisMarks(values: xAxisLabels.map { $0 }) { value in
                AxisValueLabel(centered: true)
                    .font(.headline)
                    .foregroundStyle(.black)
                // AxisGridLine()
                // AxisTick()
            }
        }
//        .chartXAxis {
//            AxisMarks(values: [6,8,10,12,14,16,18,20,22]) { value in
//                AxisValueLabel(centered: false)
//                    .font(.headline)
//                    .foregroundStyle(.black)
//                    .offset(x: -8)
//            }
//        }
        .chartYAxisLabel("Fish Count", alignment: .topTrailing)
        .chartYAxis {
            AxisMarks(values: .automatic) { value in
                AxisGridLine()
                AxisValueLabel()
                    .font(.headline)
                    .foregroundStyle(.black)
                    .offset(x: 10)
            }
        }
        .chartForegroundStyleScale([
            "LL": .orange,
            "RB": .green
        ])
        .padding()
    }
}

#Preview {
    TestView()
}


/*
 VStack {
     HStack {
         Text("HStack")
         Text("HStack")
         Spacer()
         HStack {
             BarChartView(species: "RB", title: "Rainbow trout")
                 .padding(.top, 10).padding(.trailing, 10)
             BarChartView(species: "LL", title: "Brown trout")
                 .padding(.top, 10)
         }
     }
     .frame(width: 400, height: 120)
     HStack {
         LabeledContent {
             TextField("", text: $date)
               .border(Color.gray, width: 1)
               .textFieldStyle(.roundedBorder)
               .multilineTextAlignment(.leading)
         } label: {
             Text("Date")
         }
     }
 }
}
 */
