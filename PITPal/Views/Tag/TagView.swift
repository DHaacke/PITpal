//
//  TagView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI

struct TagView: View {
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]
    
    var body: some View {
        VStack {
            TagStatusView(path: $path)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

#Preview {
    TagView(path: .constant([]))
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}



/*
 
 struct TagScheme<Content: View>: View {
     @ViewBuilder var content: Content
     var body: some View {
         VStack {
            statusView
         }
     }
     
     var statusView : some View {
         VStack {
             Text("Hello, Status!")
                 .font(.title)
         }
     }
 }
 
 var body: some View {
     TagScheme {
         CardView(path: $path)
     }
}
 
*/
