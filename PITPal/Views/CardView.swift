//
//  CardView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI

struct CardView: View {
    
    @Binding var path: [String]

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
            .frame(width: geometry.size.width, height: 80)
        }
        .frame(height: 80)
    }
}

#Preview {
    @Previewable @State var path: [String] = [K.MAINMENU, K.SETTINGS]
    CardView(path: $path, text: "Simple Card View")
        .environment(LocationsHandler())
}
