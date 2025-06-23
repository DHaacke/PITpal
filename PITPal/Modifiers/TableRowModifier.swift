//
//  TableRowModifier.swift
//  PITPal
//
//  Created by Doug Haacke on 6/22/25.
//

import SwiftUI

extension View {
    func tableRowStyle() -> some View {
        modifier(TableRow())
    }
}

struct TableRow: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 13, weight: .medium))
            .padding(.all, 0)
    }
}
