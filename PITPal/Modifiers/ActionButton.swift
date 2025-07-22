//
//  ActionButton.swift
//  PITPal
//
//  Created by Doug Haacke on 7/21/25.
//

import SwiftUI

struct ActionButton: ViewModifier {
    var backgroundColor: Color = .green
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 26, weight: .bold))
            .padding(6)
            .foregroundStyle(.white)
            .tint(.green)
            .background(backgroundColor)
            .cornerRadius(12)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: Color(.black), radius: 2, x: 1, y: 2)
    }
}

extension View {
    func actionButtomStyle() -> some View {
        modifier(Title())
    }
}

struct ActionButtonView : View {
    var body: some View {
        Button(action: {
            print("Here!")
        }) {
            Text("Action")
//            Image(systemName: "multiply.circle.fill") // SF Symbol for a filled
//                .foregroundColor(.white) // Make the button subtle
        }
            .modifier(ActionButton())
    }
}

#Preview {
    ActionButtonView()
        // .background(Color("AppBackground"))
        
}
