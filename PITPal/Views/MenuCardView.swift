//
//  MenuCardView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import SwiftUI

struct MenuCardView: View {

    var text: String = ""

    var body: some View {

        GeometryReader { geometry in
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color("CardBackground"))
                    .shadow(radius: 6, x: 1, y: 3)
                VStack {
                    Text(text)
                        .font(.title)
                        .foregroundStyle(Color("TextForegroundWhite"))
                        .font(.system(size: 24, weight: .bold, design: .default))
                }
                .multilineTextAlignment(.center)
            }
            .frame(width: geometry.size.width - 40, height: 80)
        }
        .frame(height: 80)
    }
}

#Preview {
    MenuCardView(text: "Start a new Tagging Run")
}
