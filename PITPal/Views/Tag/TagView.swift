//
//  TagView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI

struct TagView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]

    @State private var isChoosingTrip: Bool = true
    @State private var trip : Trip = Trip()
    
    var body: some View {
        VStack {
            if !isChoosingTrip {
                TagStatusView(path: $path, trip: $trip)
                TagTripView(path: $path, trip: $trip)
                TagFishEntryView(path: $path, trip: $trip)
                Spacer()
            } else {
                ChooseTripView(path: $path, trip: $trip, isChoosingTrip: $isChoosingTrip)
            }
        }
        .padding()
        .onChange(of: trip) {
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("AppBackground"))
    }
}

/*
#Preview {
    TagView(path: .constant([]))
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}
*/

