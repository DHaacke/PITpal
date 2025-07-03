//
//  SegmentedPicker.swift
//  PITPal
//
//  Created by Doug Haacke on 6/18/25.
//

import SwiftUI
import SwiftData

struct SegmentedPickerSpecies: View {
    @Environment(\.modelContext) var modelContext
    @Environment(JSONManager.self) var jsonManager
    
    @Binding var selectedSpecies: String
    @Binding var isValidSpecies: Bool
    
    @State private var selectedItem: String = ""
    
    // @Query(sort: \Species.code) var species: [Species]
    // @Query(filter: #Predicate<Species> { sp in sp.active == "Y"},  sort: \Species.name) var filteredSpecies: [Species]
    
    @Query(filter: #Predicate<Species> { sp in
        sp.active == "Y"
    }, sort: \.name) var activeSpecies: [Species]
    
    @Namespace private var animation
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                VStack {
                    HStack(spacing: 0) {
                        VStack {
                            if isValidSpecies {
                                Text(Image(systemName: "checkmark.circle.fill")) + Text(" Species: ")
                            } else {
                                Text("Species:")
                            }
                        }.padding(.trailing, 20)
                        
                        ForEach(activeSpecies) { sp in
                            Text(sp.name)
                                .padding(.vertical, 10)
                                .frame(width: 120)
                                .foregroundStyle(selectedItem == sp.code ? Color("TextForegroundWhite") : Color("TextForeground"))
                                .bold(selectedItem == sp.code)

                                .background {
                                    ZStack {
                                        if selectedItem == sp.code {
                                            Capsule()
                                                .foregroundStyle(.gray)
                                                 .matchedGeometryEffect(id: "selectedItem", in: animation)
                                        }
                                    }
                                    .animation(.bouncy, value: selectedItem)
                                }
//                                    // .contentShape(.rect)
                                .onTapGesture {
                                    selectedItem = sp.code
                                }
                        }
                        Spacer()
                    }
                    .onChange(of: selectedItem) {
                        print("Selected \(selectedItem)")
                        selectedSpecies = selectedItem
                    }
                    .background(Color("CardBackground"))
                    .padding(.horizontal, 20)
                    // .background(.primary.opacity(0.06), in: .capsule)
                }
                .frame(width: geometry.size.width, height: 60)
                .background(Color("CardBackground"))
            }
        }
   }
        
}


//#Preview {
//    @State var speciesCode: String = "RB"
//    SegmentedPickerSpecies(speciesCode : $speciesCode)
//        .environment(JSONManager())
//}

