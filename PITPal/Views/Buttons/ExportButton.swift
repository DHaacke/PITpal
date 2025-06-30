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

        ZStack {
            Button(action: {
                onExportButtonTapped()
            }, label: {
                Text("Export")
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
