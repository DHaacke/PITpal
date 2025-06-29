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
                    .shadow(color: Color(.black), radius: 3, x: 1, y: 2)
            })
            // .border(Color.gray, width: 2)
        }
    }
}


#Preview {

    ExportButton(onExportButtonTapped: {
        print("Export button tapped")
    })
}

/*
Button(action: {
    onExportButtonTapped()
}, label: {
    Text("Export")
        .frame(width: 120, height: 38)
        .font(.system(size: 24, weight: .medium))
        .foregroundColor(.white)
})
.shadow(color: Color(.gray), radius: 4, x: 2, y: 3)
*/
