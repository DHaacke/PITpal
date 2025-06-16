//
//  TagChartView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI
import Charts

struct FishData: Identifiable {
    var id: Int
    var sizeGroup: Int
    var count: Int
    var species: String
}

@Observable
class TagChartView {
    var fishData: [FishData] = [
        FishData(id: 1,  sizeGroup: 6,  count: 6 , species: "RB"),
        FishData(id: 2,  sizeGroup: 8,  count: 8 , species: "RB"),
        FishData(id: 3,  sizeGroup: 10, count: 4 , species: "RB"),
        FishData(id: 4,  sizeGroup: 12, count: 7 , species: "RB"),
        FishData(id: 5,  sizeGroup: 14, count: 18, species: "RB"),
        FishData(id: 6,  sizeGroup: 16, count: 24, species: "RB"),
        FishData(id: 7,  sizeGroup: 18, count: 37, species: "RB"),
        FishData(id: 8,  sizeGroup: 20, count: 20, species: "RB"),
        FishData(id: 9,  sizeGroup: 22, count: 9 , species: "RB"),
        FishData(id: 10, sizeGroup: 24, count: 5 , species: "RB"),
        
        FishData(id: 11, sizeGroup: 6,  count: 8 ,  species: "LL"),
        FishData(id: 12, sizeGroup: 8,  count: 13 , species: "LL"),
        FishData(id: 13, sizeGroup: 10, count: 11 , species: "LL"),
        FishData(id: 14, sizeGroup: 12, count: 7 ,  species: "LL"),
        FishData(id: 15, sizeGroup: 14, count: 15,  species: "LL"),
        FishData(id: 16, sizeGroup: 16, count: 39,  species: "LL"),
        FishData(id: 17, sizeGroup: 18, count: 37,  species: "LL"),
        FishData(id: 18, sizeGroup: 20, count: 35,  species: "LL"),
        FishData(id: 19, sizeGroup: 22, count: 11 , species: "LL"),
        FishData(id: 20, sizeGroup: 24, count: 8 ,  species: "LL")

    ]
}

struct BarChartView: View {
    @State private var viewModel = TagChartView()
    
    var species: String = ""
    var title:   String = ""
    
    var body: some View {
        VStack {
            Chart(filterFish(by: species), id: \.id) { data in
            // Chart(viewModel.fishData, id: \.id) { data in
                BarMark(
                    x: .value("Size", data.sizeGroup),
                    y: .value("Count", data.count)
                )
                .foregroundStyle(species == "RB" ? .green : .yellow)
                .cornerRadius(8)
            }
            .chartXScale(domain: [6, 24])
            // .chartYScale(domain: [minStockPrice ?? 0, maxStockPrice ?? 0])
            .chartXAxis {
                AxisMarks(values: [6, 8, 10, 12, 14, 16, 18, 20, 22, 24])
//                AxisMarks(values: .automatic) { value in
//                    AxisValueLabel()
//                        .foregroundStyle(.white)
//                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel()
                        .foregroundStyle(.white)
                }
            }
            Text(title)
                .font(.system(size: 12, weight: .light, design: .default))
        }
    }
    
    func filterFish(by species: String) -> [FishData] {
        return viewModel.fishData.filter { $0.species == species }
    }
}






//struct TagChartView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//#Preview {
//    TagChartView()
//}
