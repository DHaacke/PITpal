//
//  EditDoneButtom.swift
//  PITPal
//
//  Created by Doug Haacke on 7/7/25.
//

import SwiftUI

struct EditDoneButton: View {
    var onEditDoneButtonTapped: () -> Void
   
    var body: some View {
        VStack {
            Button(action: {
                onEditDoneButtonTapped()
            }, label: {
                Text("Done")
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
    EditDoneButton(onEditDoneButtonTapped: {
        print("Edit done button tapped")
    })
}
