//
//  AddTripButton.swift
//  PITPal
//
//  Created by Doug Haacke on 6/28/25.
//

import SwiftUI

struct AddTripButton: View {
    
    @Binding var isAddingTrip: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                self.isAddingTrip.toggle()
            }, label: {
                Text("Add New Trip")
                    .frame(width: 100, height: 34)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .shadow(color: Color(.black), radius: 2, x: 1, y: 2)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                        .stroke(Color.white, lineWidth: 2)
                        .background(Color("ButtonBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color(.darkGray), radius: 3, x: 2, y: 3)
                    )
            })
        }
        .background(.clear)
        .padding(.bottom, 12)
    }
}

#Preview {
    @Previewable @State var isAddingTrip: Bool = false
    AddTripButton(isAddingTrip: $isAddingTrip)
}
