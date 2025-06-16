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
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "1")
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "2")
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "3")
            }
            HStack {
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "4")
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "5")
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "6")
            }
            HStack {
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "7")
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "8")
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "9")
            }
            HStack {
                Spacer()
                NumberedCircledButtonView(enteredNumber: $enteredNumber, buttonText: "0")
                Spacer()
            }
            .padding(.bottom, 16)
            
            Button("Done") {
                isPresented = false // Dismiss the popover
            }
        }
    }
}

#Preview {
    @Previewable @State var enteredNumber: String = ""
    @Previewable @State var isPresented: Bool = true
    NumberPadView(isPresented: $isPresented, enteredNumber: $enteredNumber)
        
}
