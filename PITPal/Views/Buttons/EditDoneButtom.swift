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
                    .frame(width: 100, height: 50)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("TextForegroundWhite"))
                    .background(.clear)
            })
        }
        .background(.clear)
        .padding(.bottom, 12)
    }
}

#Preview {
    EditDoneButton(onEditDoneButtonTapped: {
        print("Delete button tapped")
    })
}
