//
//  SegmentedPicker.swift
//  PITPal
//
//  Created by Doug Haacke on 6/18/25.
//

import SwiftUI

struct SegmentedPickerSpecies: View {
    @Environment(JSONManager.self) var jsonManager
    
    @State private var selectedItem: Int = 1
    
    @Namespace private var animation
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                // NavigationStack {
                    VStack {
                        HStack(spacing: 0) {
                            Text("Species:")
                                .padding(.trailing, 20)
                            ForEach(jsonManager.config.species, id: \.id) { sp in
                                Text(sp.description)
                                    .padding(.vertical, 10)
                                    .frame(width: 120)
                                    .foregroundStyle(selectedItem == sp.id ? Color("TextForegroundWhite") : Color("TextForeground"))
                                    .bold(selectedItem == sp.id)

                                    .background {
                                        ZStack {
                                            if selectedItem == sp.id {
                                                Capsule()
                                                    .foregroundStyle(.gray)  // jsonManager.config.species[selectedItem].color
                                                     .matchedGeometryEffect(id: "selectedItem", in: animation)
                                            }
                                        }
                                        .animation(.bouncy, value: selectedItem)
                                    }
                                    // .contentShape(.rect)
                                    .onTapGesture {
                                        selectedItem = sp.id
                                    }
                            }
                            Spacer()
                        }
                        .background(Color("CardBackground"))
                        .padding(.horizontal, 20)
                        
                        // .background(.primary.opacity(0.06), in: .capsule)
                    }
                    .frame(width: geometry.size.width, height: 60)
                    // .frame(width: .infinity, height: 60)
                    .background(Color("CardBackground"))
                // }
            }
        }
   }
        
}


#Preview {
    SegmentedPickerSpecies()
        .environment(JSONManager())
}
