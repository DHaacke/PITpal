//
//  SplitScreenView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import SwiftUI

struct SplitScreenView<Content: View>: View {
    @ViewBuilder var content: Content
    var body: some View {
        HStack {
            sectionView
                .padding(.bottom)
                .background(Color("SkyBlueBackground"))
                .environment(\.colorScheme, .light)
            
            sectionView
                .padding(.bottom)
                .background(Color("SkyBlueBackground"))
                .environment(\.colorScheme, .dark)
        }
    }
    
    var sectionView: some View {
        VStack {
            ForEach(sections: content) { section in
                section.header
                    .font(.subheadline)
                    .textCase(.uppercase)
                    .frame(maxWidth: .infinity, alignment: .leading)
                section.content
                    .frame(height: 50)
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}



