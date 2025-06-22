//
//  SaveButton.swift
//  PITPal
//
//  Created by Doug Haacke on 6/22/25.
//

import SwiftUI

struct SaveButton: View {
    var onSaveButtonTapped: () -> Void
   
    var body: some View {
        VStack {
            Button(action: {
                onSaveButtonTapped()
            }, label: {
                Text("Save")
                    .frame(width: 100, height: 50)
                    .font(.system(size: 24, weight: .heavy))
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


//#Preview {
//    SaveButton()
//}
