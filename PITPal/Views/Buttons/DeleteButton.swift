//
//  DeleteButton.swift
//  PITPal
//
//  Created by Doug Haacke on 7/6/25.
//

import SwiftUI

struct DeleteButton: View {
    var onDeleteButtonTapped: () -> Void
   
    var body: some View {
        VStack {
            Button(action: {
                onDeleteButtonTapped()
            }, label: {
                Text("Delete")
                    .frame(width: 90, height: 34)
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
    DeleteButton(onDeleteButtonTapped: {
        print("Delete button tapped")
    })
}
