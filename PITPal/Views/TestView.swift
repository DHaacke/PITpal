//
//  TestView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import Foundation
import SwiftUI
import Charts

struct GradientBackgroundAnimation: View {
    
    @State private var animateGradient: Bool = false
    
    private let startColor: Color = .blue
    private let endColor: Color = .green
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "swift")
                .font(.system(size: 72, weight: .light))
                .padding(.top, 80)
                .padding(.bottom, 64)
            
            Text("Gradient background animation in SwiftUI")
                .font(.title)
                .bold()
            
            Text("It is a visual effect where the colors of a gradient background transition over time.")
                .fontWeight(.thin)
            
            Spacer()
            
            Button {
                
            } label: {
                Image(systemName: "arrow.right")
            }
            .frame(width: 50, height: 50)
            .background(Color.white)
            .cornerRadius(25)
            .padding(10)
            .overlay {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 1))
                    .foregroundColor(.white)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(.black)
        .padding(.horizontal)
        .multilineTextAlignment(.center)
        .background {
            LinearGradient(colors: [startColor, endColor], startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
                .hueRotation(.degrees(animateGradient ? 45 : 0))
                .onAppear {
                    withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                        animateGradient.toggle()
                    }
                }
        }
    }
}

struct GradientBackgroundAnimation_Previews: PreviewProvider {
    static var previews: some View {
        GradientBackgroundAnimation()
    }
}

//struct FontPreview: View {
//    let textStyles: [(Font.TextStyle, String)] = [
//        (.largeTitle, "Large Title"),
//        (.title, "Title 1"),
//        (.title2, "Title 2"),
//        (.title3, "Title 3"),
//        (.headline, "Headline"),
//        (.subheadline, "Subheadline"),
//        (.body, "Body"),
//        (.callout, "Callout"),
//        (.footnote, "Footnote"),
//        (.caption, "Caption 1"),
//        (.caption2, "Caption 2")
//    ]
//
//    var body: some View {
//        ScrollView {
//            VStack(alignment: .leading, spacing: 10) {
//                ForEach(textStyles, id: \.1) { style, name in
//                    Text(name)
//                        .font(.system(style))
//                        .padding(.horizontal)
//                }
//            }
//            .padding(.vertical)
//        }
//        .navigationTitle("iOS Text Styles")
//        .background(Color("AppBackground"))
//    }
//}
//
//struct FontPreview_Previews: PreviewProvider {
//    static var previews: some View {
//        FontPreview()
//    }
//}
//
//struct TestView: View {
//    
//    var body: some View {
//        let fishArray = [
//            (species: "LL", fishCount:[81, 234, 64, 227, 103, 247, 819, 339, 125]),
//            (species: "RB", fishCount:[21, 10, 1, 93, 62, 52, 220, 268, 175])
//        ]
//        // let xAxisLabels = [6, 8, 10, 12, 14, 16, 18, 20, 22]
//        let xAxisLabels = ["6", "8", "10", "12", "14", "16", "18", "20", "22"]
////        Species: LL, 81, 234, 64, 227, 103, 247, 819, 339, 125
////        Species: RB, 21, 10, 1, 93, 62, 52, 220, 268, 175
//        
//        Chart(fishArray, id: \.species) { fish in
//            ForEach(0..<fish.fishCount.count, id: \.self) { i in
//                let sizeGroup = 6 + (i * 2) // Assuming size groups are 6, 8, 10, ..., 22
//                BarMark(
//                    x: .value("SizeGroup", String(sizeGroup)),
//                    y: .value("Length", fish.fishCount[i]),
//                    width: 30
//                )
//                .foregroundStyle(by: .value("Species", fish.species))
//                .position(by: .value("Species", fish.species))
//                .clipShape(RoundedRectangle(cornerRadius: 8))
//            }
//        }
//        .padding()
//        // .chartXScale(domain: [6, 22])
//        .chartXAxisLabel("Fish Size (inches)", alignment: .leading)
//        .chartXAxis {
//            AxisMarks(values: xAxisLabels.map { $0 }) { value in
//                AxisValueLabel(centered: true)
//                    .font(.headline)
//                    .foregroundStyle(.black)
//                // AxisGridLine()
//                // AxisTick()
//            }
//        }
////        .chartXAxis {
////            AxisMarks(values: [6,8,10,12,14,16,18,20,22]) { value in
////                AxisValueLabel(centered: false)
////                    .font(.headline)
////                    .foregroundStyle(.black)
////                    .offset(x: -8)
////            }
////        }
//        .chartYAxisLabel("Fish Count", alignment: .topTrailing)
//        .chartYAxis {
//            AxisMarks(values: .automatic) { value in
//                AxisGridLine()
//                AxisValueLabel()
//                    .font(.headline)
//                    .foregroundStyle(.black)
//                    .offset(x: 10)
//            }
//        }
//        .chartForegroundStyleScale([
//            "LL": .orange,
//            "RB": .green
//        ])
//        .padding()
//    }
//}
//
//#Preview {
//    TestView()
//}


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
