//
//  MenuCardView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import SwiftUI

struct MenuCardView: View {
    
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
            .frame(width: geometry.size.width - 40, height: 80)
            .onTapGesture {
                // print("Initial path: \(path)")
                self.path = [K.MAINMENU, K.SETTINGS]
                // print("New path: \(path)")
            }
            
        }
        .frame(height: 80)
    }
}

#Preview {
    @Previewable @State var path: [String] = [K.MAINMENU, K.SETTINGS]
    MenuCardView(path: $path, text: "Start a new Tagging Run")
        .environment(LocationsHandler())
}

