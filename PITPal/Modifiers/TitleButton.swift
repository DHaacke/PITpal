//
//  TitleButton.swift
//  PITPal
//
//  Created by Doug Haacke on 7/21/25.
//

import SwiftUI

struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color("TextForegroundWhite"))
            .padding()
            .background(.blue)
            .clipShape(.rect(cornerRadius: 10))
    }
}

extension View {
    func titleStyle() -> some View {
        modifier(Title())
    }
}

struct TestExtView : View {
    var body: some View {
        Text("Hello, Douglas!")
            .modifier(Title())
    }
}

#Preview {
    TestExtView()
}
