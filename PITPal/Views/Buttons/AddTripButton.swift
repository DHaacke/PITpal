//
//  AddTripButton.swift
//  PITPal
//
//  Created by Doug Haacke on 6/28/25.
//

import SwiftUI

struct AddTripButton: View {
    
    @Binding var isAddingNewTrip: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                self.isAddingNewTrip.toggle()
            }, label: {
                Text("Add New Trip")
                    .frame(width: 200, height: 30)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("TextForegroundWhite"))
//                     .background(.clear)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 14,
                            style: .continuous
                        )
                        .stroke(Color("TextForegroundWhite"), lineWidth: 2)
                        .background(Color("CardBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    )
            })
        }
        .background(.clear)
        .padding(.bottom, 12)
    }
}

#Preview {
    @Previewable @State var isAddingNewTrip: Bool = false
    AddTripButton(isAddingNewTrip: $isAddingNewTrip)
}
