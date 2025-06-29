//
//  ExportButton.swift
//  PITPal
//
//  Created by Doug Haacke on 6/28/25.
//

import SwiftUI

struct ExportButton: View {

    var onExportButtonTapped: () -> Void
   
    var body: some View {
        VStack {
            Button(action: {
                onExportButtonTapped()
            }, label: {
                Text("Export")
                    .frame(width: 120, height: 38)
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

    ExportButton(onExportButtonTapped: {
        print("Export button tapped")
    })
}
