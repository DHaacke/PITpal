//
//  CustomSegmentedControl.swift
//  PITPal
//
//  Created by Doug Haacke on 6/18/25.
//

import SwiftUI

enum FishSpecies: String, CaseIterable {
    case rainbow = "Rainbow"
    case brown   = "Brown"
    
    var color: Color {
        switch self {
            case .rainbow:
                    return Color.green
            case .brown:
                    return Color.brown
        }
    }
}

struct CustomSegmentedControl: View {
    
    @State private var selectedItem = FishSpecies.rainbow
    @Namespace private var animation
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(spacing: 0) {
//                    Text("Species \(selectedItem)")
//                        .padding(.horizontal, 20)
                    ForEach(FishSpecies.allCases, id: \.rawValue) { sp in
                        Text(sp.rawValue)
                            .padding(.vertical, 10)
                            .frame(width: 100)
                            .foregroundStyle(selectedItem == sp ? Color(.black) : Color(.white))
                            .bold(selectedItem == sp)
                            .background {
                                ZStack {
                                    if selectedItem == sp {
                                        Capsule()
                                            .foregroundStyle(selectedItem.color.gradient)
                                            .matchedGeometryEffect(id: "selectedItem", in: animation)
                                    }
                                }
                                .animation(.snappy, value: selectedItem)
                            }
                            .contentShape(.rect)
                            .onTapGesture {
                                selectedItem = sp
                            }
                    }
                }
                .background(.primary.opacity(0.06), in: .capsule)
            }
        }
    }
}


#Preview {
    CustomSegmentedControl()
}


    
