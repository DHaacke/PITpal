//
//  PDFButton.swift
//  PITPal
//
//  Created by Doug Haacke on 7/1/25.
//

import SwiftUI

struct PDFButton: View {

    var onPDFButtonTapped: () -> Void
   
    var body: some View {

        ZStack {
            Button(action: {
                onPDFButtonTapped()
            }, label: {
                Text("PDF")
                    .font(.system(size: 24, weight: .medium))
                    .frame(width: 100, height: 38)
                    .foregroundColor(.white)
                    .shadow(color: Color(.black), radius: 2, x: 1, y: 2)
            }).frame(width: 100, height: 38)
        }
        .shadow(color: Color(.black), radius: 2, x: 1, y: 2)
    }
}


#Preview {
    PDFButton(onPDFButtonTapped: {
        print("PDF button tapped")
    })
}
