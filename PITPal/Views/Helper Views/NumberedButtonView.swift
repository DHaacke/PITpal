
//
//  NumberedCircledButton.swift
//  PITPal
//
//  Created by Doug Haacke on 6/16/25.
//

import SwiftUI

struct NumberedButtonView: View {
    @Binding var enteredNumber: String
    let buttonText: String

    var body: some View {
        Button(action: {
            self.enteredNumber = buttonText
        }) {
            ZStack {
                Text(buttonText)
                    .foregroundColor(.white)
                    .font(.system(size: 30, weight: .regular, design: .default))
            }.frame(width: 30)
        }
    }
}

