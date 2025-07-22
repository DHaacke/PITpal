
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
                if buttonText == "<" {
                    Image(systemName: "delete.left")
                        .resizable()
                        .frame(width: 32, height: 30)
                } else if buttonText == "MAX" {
                    Text(buttonText)
                        .font(.system(size: 14, weight: .regular, design: .default))
                } else {
                    Text(buttonText)
                        .font(.system(size: 36, weight: .regular, design: .default))
                }

            }
            .frame(width: 36)
            .padding(6)
        }
    }
}

