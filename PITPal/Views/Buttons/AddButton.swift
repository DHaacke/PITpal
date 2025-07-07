//
//  AddButton.swift
//  PITPal
//
//  Created by Doug Haacke on 7/6/25.
//

import SwiftUI

struct AddButton: View {
    var onAddButtonTapped: () -> Void
   
    var body: some View {
        VStack {
            Button(action: {
                onAddButtonTapped()
            }, label: {
                Text("Add")
                    .frame(width: 80, height: 34)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 20,
                            style: .continuous
                        )
                        .stroke(Color.white, lineWidth: 2)
                        .background(Color("ButtonBackground"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    )
            })
        }
    }
}


#Preview {
    AddButton(onAddButtonTapped: {
        print("Add button tapped")
    })
}
