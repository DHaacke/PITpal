//
//  TestView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import SwiftUI

struct TestView: View {
    @State private var date: String = "2024-01-01"
    var body: some View {
        VStack {
            HStack {
                LeftView()
                RightView()
            }

        }
    }
}

#Preview {
    TestView()
}


struct LeftView : View {
    var body: some View {
        VStack {
            HStack {
                Text("Date")
                Text("Doug Haacke")
                    .font(.system(size: 12, weight: .bold, design: .default))
                    .foregroundStyle(Color("TextForegroundWhite"))
                    .padding(.leading, 10)
            }
            HStack {
                Text("Left View C")
                Text("Left View D")
            }
        }.frame(width: 400, height: 120)
    }
}

struct RightView : View {
    var body: some View {
        VStack {
            HStack {
                BarChartView(species: "RB", title: "Rainbow trout")
                    .padding(.top, 10).padding(.trailing, 10)
                BarChartView(species: "LL", title: "Brown trout")
                    .padding(.top, 10)
            }
        }.frame(width: 400, height: 120)
    }
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
