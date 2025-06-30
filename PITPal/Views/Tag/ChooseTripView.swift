//
//  ChooseTripView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/26/25.
//

import SwiftUI
import SwiftData

struct ChooseTripView: View {
    @Environment(\.modelContext) var modelContext
    
    @Query(sort: \Trip.date, order: .reverse) var trips: [Trip]
    
    @Binding var path: [String]
    @Binding var trip: Trip
    @Binding var isChoosingTrip: Bool
    @Binding var isAddingTrip: Bool
    
    @State private var tripSelection: Trip?
    
    let q = Queries()
    
    @AppStorage("tripTripType") private var tripTripType: String = "M"
    @AppStorage("tripSurveySection") private var tripSurveySection: String = "U"
    @AppStorage("tripWatershed") private var tripWatershed: String = "BHR"
    @AppStorage("tripEquipment") private var tripEquipment: String = "Jet Boat- Boom anodes"
    
    var body: some View {

            VStack {
                Text("Choose Trip")
                    .font(.title)
                    .padding()
                List(trips, id: \.self, selection: $tripSelection) { trip in
                    Text("\(trip.date.formatted(date: .numeric, time: .omitted)) - \(q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: trip.surveySection)), \(q.fetchNameFromCode(context: modelContext, model: "TripType", code: trip.tripType)), \(trip.fish.count) Fish")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .onTapGesture {
                            tripSelection = trip
                        }
                }
                AddTripButton(isAddingTrip: $isAddingTrip)
            }
            .frame(minWidth: 0, maxWidth: 500, minHeight: 0, maxHeight: 600)
            // .background(Color("CardBackground"))
            .background(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .stroke(Color("TextForegroundWhite"), lineWidth: 2)
                .background(Color("CardBackground"))
                .clipShape(RoundedRectangle(cornerRadius: 20))
            )
        
            .onChange(of: isAddingTrip) {
                if isAddingTrip {
                    print("Adding new trip...")
                    self.trip = Trip(
                        date: Date(),
                        tripType: tripTripType,
                        surveySection: tripSurveySection,
                        watershed: tripWatershed,
                        equipment: tripEquipment,
                        latDown: 0,
                        lonDown: 0,
                        latUp: 0,
                        lonUp: 0,
                        sectionLength: 0,
                        startTime: "00:00",
                        endTime: "00:00",
                        waterTemperature: 0.0,
                        waterFlow: 0.0,
                        fish: []
                    )
                    self.isChoosingTrip.toggle()
                    self.isAddingTrip.toggle()
                }
            }
            .onChange(of: tripSelection) {
                if let tripSelection {
                    print("\(tripSelection.date.formatted(date: .numeric, time: .omitted)) - \(q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: tripSelection.surveySection)), \(q.fetchNameFromCode(context: modelContext, model: "TripType", code: tripSelection.tripType)), \(tripSelection.fish.count) Fish")
                    self.trip = tripSelection
                    self.isChoosingTrip.toggle()
                }
            }

    }
}

/*
#Preview {
    // let trip = Trip()
    ChooseTripView(path: .constant([]))
}
*/

