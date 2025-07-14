//
//  NumberPadView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/16/25.
//

import SwiftUI

struct NumberPadView: View {
    
    @Binding var isPresented: Bool
    @Binding var enteredNumber: String

    var body: some View {
        VStack {
            HStack {
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "1")
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "2")
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "3")
            }.foregroundColor(Color("TextForeground"))
            HStack {
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "4")
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "5")
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "6")
            }.foregroundColor(Color("TextForeground"))
            HStack {
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "7")
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "8")
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "9")
            }.foregroundColor(Color("TextForeground"))
            HStack {
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "-")
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "0")
                NumberedButtonView(enteredNumber: $enteredNumber, buttonText: "<")
            }.foregroundColor(Color("TextForeground"))
            .padding(.bottom, 16)
            
            Button("Done") {
                isPresented = false // Dismiss the popover
            }.foregroundColor(Color("TextForeground"))
        }
        .frame(width: 220, height: 350)
        .padding()
    }
}


#Preview {
    @Previewable @State var enteredNumber: String = ""
    @Previewable @State var isPresented: Bool = true
    NumberPadView(isPresented: $isPresented, enteredNumber: $enteredNumber)
        
}

