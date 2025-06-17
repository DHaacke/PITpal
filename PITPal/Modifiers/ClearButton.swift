//
//  ClearButton.swift
//  PITPal
//
//  Created by Doug Haacke on 6/16/25.
//

import SwiftUI

struct ClearButton: ViewModifier {
    @Binding var text: String // Binding to the text in the TextField

    public func body(content: Content) -> some View {
        HStack { // Use HStack for better text alignment
            content // The TextField itself
            Spacer() // Pushes the clear button to the right

            if !text.isEmpty { // Only show the clear button when there's text
                Button(action: {
                    self.text = "" // Clear the text
                }) {
                    Image(systemName: "multiply.circle.fill") // SF Symbol for a filled circle with an X
                        .foregroundColor(.secondary) // Make the button subtle
                }
            }
        }
    }
}
