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
    @Binding var tripData: TripData
    @Binding var isChoosingTrip: Bool
    @Binding var isAddingTrip: Bool
    
    @State private var tripSelection: Trip?
    
    let q = Queries()
    
    @AppStorage("tripTripType") private var tripTripType: String = "M"
    @AppStorage("tripSurveySection") private var tripSurveySection: String = "U"
    @AppStorage("tripWatershed") private var tripWatershed: String = "BHR"
    @AppStorage("tripGear") private var tripGear: String = "Jet Boat, Anodes boom"
    @AppStorage("tripRectifyingunit") private var tripRectifyingunit: String = "SR Model VVP-15B"
    @AppStorage("tripVolts") private var tripVolts: String = "150"
    @AppStorage("tripAmps") private var tripAmps: String = "6"
    @AppStorage("tripShocktime") private var tripShocktime: String = "6"
    @AppStorage("tripAnesthetic") private var tripAnesthetic: String = "222"
    @AppStorage("tripDosage") private var tripDosage: String = ""

    
    var body: some View {

            VStack {
                Text("Choose Trip")
                    .font(.title)
                    .padding(.top, 10)

                List(trips, id: \.self, selection: $tripSelection) { trip in
                    Text("\(trip.date.formatted(date: .numeric, time: .omitted)) - \(q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: trip.surveySection)), \(q.fetchNameFromCode(context: modelContext, model: "TripType", code: trip.tripType)), \(trip.fish.count) Fish")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .onTapGesture {
                            tripSelection = trip
                        }
                }
                .padding(.top, 0)
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
                    self.tripData = TripData(
                        date: Date(),
                        tripType: tripTripType,
                        surveySection: tripSurveySection,
                        watershed: tripWatershed,
                        gear: tripGear,
                        rectifyingunit: tripRectifyingunit,
                        volts: tripVolts,
                        amps: tripAmps,
                        shocktime: tripShocktime,
                        anesthetic: tripAnesthetic,
                        dosage: tripDosage,
                        latDown: 0,
                        lonDown: 0,
                        latUp: 0,
                        lonUp: 0,
                        sectionLength: 0,
                        startTime: "00:00",
                        endTime: "00:00",
                        waterTemperature: 0.0,
                        waterFlow: 0.0,
                        turbidity: "",
                        isClosed: "N",
                        fish: []
                    )
                    self.isChoosingTrip.toggle()
                    self.isAddingTrip.toggle()
                }
            }
            .onChange(of: tripSelection) {
                if let tripSelection {
                    print("\(tripSelection.date.formatted(date: .numeric, time: .omitted)) - \(q.fetchNameFromCode(context: modelContext, model: "SurveySection", code: tripSelection.surveySection)), \(q.fetchNameFromCode(context: modelContext, model: "TripType", code: tripSelection.tripType)), \(tripSelection.fish.count) Fish")
                    self.tripData = tripSelection.deepCopy()
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

