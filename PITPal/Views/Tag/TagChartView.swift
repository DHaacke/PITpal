//
//  TagChartView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI
import SwiftData
import Charts

struct FishData: Identifiable {
    var id: Int
    var sizeGroup: Int
    var count: Int
    var species: String
}

@Observable
class TagChartView {
    var fishData: [FishData] = []
}

struct BarChartView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var viewModel = TagChartView()
    
    var species: String = ""
    var title:   String = ""
    
    @Query(filter: #Predicate<Fish> { fish in fish.species == "RB" && fish.length > 0}) var rainbows: [Fish]
    @Query(filter: #Predicate<Fish> { fish in fish.species == "LL" && fish.length > 0}) var browns: [Fish]
    
    var body: some View {
        VStack {
            Chart(filterFish(by: species), id: \.id) { data in
            // Chart(viewModel.fishData, id: \.id) { data in
                BarMark(
                    x: .value("Size", data.sizeGroup),
                    y: .value("Count", data.count),
                    width: 14
                )
                .foregroundStyle(species == "RB" ? .green : .yellow)
                .annotation(position: .overlay) {
                           Rectangle()
                        .stroke(Color.white, lineWidth: 0.75)
                              .padding(-4)
                }
                .cornerRadius(4)
            }
            .chartXScale(domain: [6, 24])
            // .chartYScale(domain: [minStockPrice ?? 0, maxStockPrice ?? 0])
            .chartXAxis {
                AxisMarks(values: [6, 8, 10, 12, 14, 16, 18, 20]) { value in
                    AxisValueLabel()
                        .foregroundStyle(.white)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { value in
                    AxisGridLine()
                    AxisValueLabel()
                        .foregroundStyle(.white)
                        .offset(x: 4)
                }
            }
            Text(title)
                .font(.system(size: 12, weight: .light, design: .default))
        }
        .padding(.trailing, 12)
    }
    
    func filterFish(by species: String) -> [FishData] {
        viewModel.fishData.removeAll()
        if species == "RB" && rainbows.count > 0 {
            viewModel.fishData.append(FishData(id:  1,  sizeGroup:  6,  count: rainbows.filter { $0.length <= 125}.count , species: "RB"))
            viewModel.fishData.append(FishData(id:  2,  sizeGroup:  8,  count: rainbows.filter { $0.length >  125 && $0.length <= 203 }.count , species: "RB"))
            viewModel.fishData.append(FishData(id:  3,  sizeGroup: 10,  count: rainbows.filter { $0.length >  203 && $0.length <= 253 }.count , species: "RB"))
            viewModel.fishData.append(FishData(id:  4,  sizeGroup: 12,  count: rainbows.filter { $0.length >  253 && $0.length <= 305 }.count , species: "RB"))
            viewModel.fishData.append(FishData(id:  5,  sizeGroup: 14,  count: rainbows.filter { $0.length >  305 && $0.length <= 355 }.count , species: "RB"))
            viewModel.fishData.append(FishData(id:  6,  sizeGroup: 16,  count: rainbows.filter { $0.length >  355 && $0.length <= 406 }.count , species: "RB"))
            viewModel.fishData.append(FishData(id:  7,  sizeGroup: 18,  count: rainbows.filter { $0.length >  406 && $0.length <= 458 }.count , species: "RB"))
            viewModel.fishData.append(FishData(id:  8,  sizeGroup: 20,  count: rainbows.filter { $0.length >  458 }.count , species: "RB"))
        } else if species == "LL" && browns.count > 0 {
            viewModel.fishData.append(FishData(id: 10, sizeGroup:  6,  count: browns.filter { $0.length <= 125}.count , species: "LL"))
            viewModel.fishData.append(FishData(id: 12, sizeGroup:  8,  count: browns.filter { $0.length >  125 && $0.length <= 203 }.count , species: "LL"))
            viewModel.fishData.append(FishData(id: 13, sizeGroup: 10,  count: browns.filter { $0.length >  203 && $0.length <= 253 }.count , species: "LL"))
            viewModel.fishData.append(FishData(id: 14, sizeGroup: 12,  count: browns.filter { $0.length >  253 && $0.length <= 305 }.count , species: "LL"))
            viewModel.fishData.append(FishData(id: 15, sizeGroup: 14,  count: browns.filter { $0.length >  305 && $0.length <= 355 }.count , species: "LL"))
            viewModel.fishData.append(FishData(id: 16, sizeGroup: 16,  count: browns.filter { $0.length >  355 && $0.length <= 406 }.count , species: "LL"))
            viewModel.fishData.append(FishData(id: 17, sizeGroup: 18,  count: browns.filter { $0.length >  406 && $0.length <= 458 }.count , species: "LL"))
            viewModel.fishData.append(FishData(id: 18, sizeGroup: 20,  count: browns.filter { $0.length >  458 }.count , species: "LL"))
        }
        
        
        return viewModel.fishData.filter { $0.species == species }
    }
}





/*
#Preview {
    TagChartView()
        .environment(.modelContext)
}
*/

/*
150
203
253
305
255
406
458
507
*/
