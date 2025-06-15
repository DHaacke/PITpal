//
//  TestView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import SwiftUI

struct TestView: View {
//     @Environment(\.scenePhase) var scenePhase
//     @Environment(LocationsHandler.self) var locationsHandler
//  @AppStorage("darkMode") private var darkMode: Bool = false
    

    // @State private var path = [String]()
    
    var body: some View {
        NavigationStack {
            List {
                NavigationLink("Go to Detail", destination: Text("Detail View"))
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//#Preview {
//    @Previewable @State var path: [String] = []
//    TestView()
//        .environment(LocationsHandler())
//}
