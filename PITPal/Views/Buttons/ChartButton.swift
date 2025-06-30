//
//  ChartButton.swift
//  PITPal
//
//  Created by Doug Haacke on 6/29/25.
//

import SwiftUI

struct ChartButton: View {

    var onChartButtonTapped: () -> Void
   
    var body: some View {

        ZStack {
            Button(action: {
                onChartButtonTapped()
            }, label: {
                Text("Chart")
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
    ChartButton(onChartButtonTapped: {
        print("Chart button tapped")
    })
}
