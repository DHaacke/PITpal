//
//  TestView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import SwiftUI

struct TestView: View {
    @Binding var path: [String]
    
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("CardBackground"))
                        .shadow(radius: 6, x: 1, y: 3)
                    
                    VStack {
                        
                    }
                }
            }
        }
        .frame(height: 150)
    }
}


#Preview {
    TestView(path: .constant([]))
}


/*
 VStack {
     HStack {
         Text("HStack")
         Text("HStack")
         Spacer()
         HStack {
             BarChartView(species: "RB", title: "Rainbow trout")
                 .padding(.top, 10).padding(.trailing, 10)
             BarChartView(species: "LL", title: "Brown trout")
                 .padding(.top, 10)
         }
     }
     .frame(width: 400, height: 120)
     HStack {
         LabeledContent {
             TextField("", text: $date)
               .border(Color.gray, width: 1)
               .textFieldStyle(.roundedBorder)
               .multilineTextAlignment(.leading)
         } label: {
             Text("Date")
         }
     }
 }
}
 */
