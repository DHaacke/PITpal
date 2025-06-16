
//
//  NumberedCircledButton.swift
//  PITPal
//
//  Created by Doug Haacke on 6/16/25.
//

import SwiftUI

struct NumberedCircledButtonView: View {
    @Binding var enteredNumber: String
    let buttonText: String

    var body: some View {
        Button(action: {
            self.enteredNumber = buttonText
        }) {
            ZStack {
                Circle()
                    .fill(.blue)
                    .frame(width: 50, height: 50)
                Text(buttonText)
                    .foregroundColor(.white)
                    .font(.title2)
            }
        }
    }
}

