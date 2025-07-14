//
//  TagView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import SwiftUI

struct TripView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]

    @State private var isChoosingTrip: Bool = true
    @State private var isAddingTrip: Bool = false
    @State private var tripData : TripData = TripData()
    
    @State var tripValidation: TripValidation = TripValidation()
    
    var body: some View {
        VStack {
            if !isChoosingTrip {
                TripStatusView(path: $path, tripData: $tripData)
                TripHeaderView(path: $path, tripData: $tripData, isAddingTrip: $isAddingTrip)
                if tripData.isClosed == "N" {
                    TripFishView(path: $path, tripData: $tripData, isAddingTrip: $isAddingTrip)
                } else {
                    VStack {
                        TripFishListView(tripData: $tripData)
                            .padding(.top, 24)
                    }
                }
                Spacer()
            } else {
                ChooseTripView(path: $path, tripData: $tripData, isChoosingTrip: $isChoosingTrip, isAddingTrip: $isAddingTrip)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        .background(Color("AppBackground"))
        .onAppear {
            isChoosingTrip = true
            isAddingTrip = false
        }
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
class TripValidation {
    var isValidWatershed: Bool = false
    var isValidTripType: Bool = false
    var isValidSurveySection: Bool = false
    var isValidStartTime: Bool = false
    var isValidEndTime: Bool = false
    var isValidPitTag: Bool = false
    var isValidSpecies: Bool = false

    init(isValidWatershed: Bool = false, isValidTripType: Bool = false, isValidSurveySection: Bool = false, isValidStartTime: Bool = false, isValidEndTime: Bool = false, isValidPitTag: Bool = false, isValidSpecies: Bool = false) {
        self.isValidWatershed = isValidWatershed
        self.isValidTripType = isValidTripType
        self.isValidSurveySection = isValidSurveySection
        self.isValidStartTime = isValidStartTime
        self.isValidEndTime = isValidEndTime
        self.isValidPitTag = isValidPitTag
        self.isValidSpecies = isValidSpecies
    }
    
    func isValid() -> Bool {
        return isValidWatershed && isValidTripType && isValidSurveySection && isValidStartTime && isValidEndTime && isValidPitTag && isValidSpecies
    }
    
    func clearAll() {
        self.isValidWatershed = false
        self.isValidTripType = false
        self.isValidSurveySection = false
        self.isValidStartTime = false
        self.isValidEndTime = false
        self.isValidPitTag = false
        self.isValidSpecies = false
    }

}
