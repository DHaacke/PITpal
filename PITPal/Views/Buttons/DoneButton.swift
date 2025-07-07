//
//  DoneButton.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import SwiftUI

struct DoneButton: View {
    
    @Binding var path: [String]
    var nextView: String = K.MAINMENU
    
    var body: some View {
        VStack {
            Button(action: {
                self.path = [nextView]
            }, label: {
                Text("Done")
                    .frame(width: 100, height: 50)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("TextForegroundWhite"))
                    .background(.clear)
            })
        }
        .background(.clear)
        .padding(.bottom, 12)
    }
}

#Preview {
    @Previewable @State var path: [String] = [K.MAINMENU, K.SETTINGS]
    DoneButton(path: $path, nextView: K.MAINMENU)
        .environment(LocationsHandler())
}
