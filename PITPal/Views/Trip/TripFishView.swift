//
//  TagFishEntryView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/16/25.
//

import Foundation
import SwiftUI
import SwiftData

// @AppStorage("usingPitTags") private var usingPitTags: Bool = true

struct TripFishView: View {
//    init() {
//        // Set background color for unselected segments
//        UISegmentedControl.appearance().backgroundColor = UIColor.lightGray
//    }
    
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]
    @Binding var tripData: TripData
    @Binding var isAddingTrip: Bool
    
    @AppStorage("usingPitTags") private var usingPitTags: Bool = true
    @AppStorage("tripGear") private var tripGear: String = "Jet Boat, Anodes boom"
    @AppStorage("tripRectifyingunit") private var tripRectifyingunit: String = "SR Model VVP-15B"
    @AppStorage("tripVolts") private var tripVolts: String = "150"
    @AppStorage("tripAmps") private var tripAmps: String = "6"
    @AppStorage("tripShocktime") private var tripShocktime: String = "6"
    @AppStorage("tripAnesthetic") private var tripAnesthetic: String = "222"
    @AppStorage("tripDosage") private var tripDosage: String = ""
    @AppStorage("tripTurbidity") private var tripTurbidity: String = "MAX"
    @AppStorage("lengthMax") private var lengthMax: Int = 700
    @AppStorage("weightMax") private var weightMax: Int = 2400
    @AppStorage("pitTagPrefix") private var pitTagPrefix: String = "3D6."
    
    @State private var bluetoothManager = BluetoothManager()
   
    @State private var pitTagNumber: String = ""
    @State private var enteredNumber: String = ""
    
    @State private var selectedSpecies: String = ""
    @State private var selectedLength:  String = ""
    @State private var selectedWeight:  String = ""
    @State private var selectedGender:  String = ""
    @State private var selectedMortality:  String = "N"
    @State private var selectedMC:  String = "N"
    @State private var selectedCount:  String = "1"
    
    @State private var enteredLength:   String = ""
    @State private var enteredWeight:   String = ""
    @State private var enteredCount:   String = ""

    @State private var selectedComments: String = ""
    @State private var isPresentedComments: Bool = false

    @State private var isPresentedPitTag: Bool = false
    @State private var isPresentedLength: Bool = false
    @State private var isPresentedWeight: Bool = false
    @State private var isPresentedCount: Bool = false
    
    @State private var isValidPitTag: Bool = false
    @State private var isValidSpecies: Bool = false
    @State private var isValidSurveySection: Bool = false
    @State private var isValidLength: Bool = false
    @State private var isValidWeight: Bool = false
    @State private var isShowingDuplicateAlert: Bool = false
    
    let q = Queries()
    
    // @Query(sort: \Comment.sort) var commentList: [Comment]
    @Query(sort: \Trip.date) var existingTrips: [Trip]
    
    @Query(filter: #Predicate<Species> { sp in
        sp.active == "Y"
    }, sort: \.name) var activeSpecies: [Species]
    
    @Query(filter: #Predicate<Fish> { fish in
        fish.pitTag != ""
    }, sort: \.pitTag) var taggedFish: [Fish]
    // @Query var comments: [Comment]
    // @Query(filter: #Predicate<Comment> { c in c.active == "Y"}, sort: \Comment.sort) var activeComments: [Comment]

          
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("CardBackground"))
                        .shadow(radius: 6, x: 1, y: 3)
                    
                    VStack {
                        if usingPitTags {
                            HStack {
                                LabeledContent {
                                    TextField("", text: $pitTagNumber)
                                        .disabled(true)
                                        .border(Color.gray, width: 1)
                                        .foregroundColor(Color("TextForeground"))
                                        .textFieldStyle(.roundedBorder)
                                        .modifier(ClearButton(text: $pitTagNumber))
                                        .frame(width: 300)
                                        .multilineTextAlignment(.leading)
                                        .popover(isPresented: $isPresentedPitTag) {
                                            NumberPadView(isPresented: $isPresentedPitTag, enteredNumber: $enteredNumber)
                                        }
                                } label: {
                                    if isValidPitTag {
                                        Text(Image(systemName: "checkmark.circle.fill")) + Text(" PIT Tag #:")
                                    } else {
                                        Text(" PIT Tag #:")
                                    }
                                    
                                }.frame(width: 450)
                                
                                Button {
                                    self.isPresentedPitTag = true
                                } label: {
                                    Image(systemName: "keyboard.onehanded.right.fill")
                                }
                                .foregroundColor(.white)
                                .background(Color.clear)
                                .font(.system(size: 28, weight: .regular, design: .default))
                                
                                Spacer()
                                
                                if usingPitTags {
                                    VStack {
                                        if bluetoothManager.isConnected {
                                            Image("Bluetooth")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .shadow(radius: 8)
                                                .frame(width: 30, height: 30)
                                                .padding(0)
                                        }
//                                        Button {
//                                            if bluetoothManager.isConnected == false || bluetoothManager.connectionStatus == K.DISCONNECTED {
//                                                print(getBluetoothStatus())
//                                                print("* * Restarting Bluetooth * *")
//                                                bluetoothManager.restart()
//                                            }
//                                        } label: {
//                                            Image("Bluetooth")
//                                                .resizable()
//                                                .aspectRatio(contentMode: .fit)
//                                                .shadow(radius: 8)
//                                                .frame(width: 30, height: 30)
//                                                .padding(0)
//                                        }
//                                            .buttonStyle(PlainButtonStyle())
//                                            .padding(0)

//                                        HStack {
//                                            if bluetoothManager.connectionStatus == K.SCANNING {
//                                                ProgressView()
//                                                    .frame(width: 12, height: 12)
//                                            }
//                                            Text(getBluetoothStatus())
//                                                .foregroundColor(Color("TextForegroundWhite"))  // getBluetoothColor()
//                                                .font(.system(size: 10, weight: .regular, design: .default))
//                                                .shadow(radius: 3)
//                                        }
                                    }
                                    .frame(width: 140)
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(height: usingPitTags ? 50 : 0)
                        }


                        //   S P E C I E S
                        HStack {
                            LabeledContent {
                                Picker("", selection: $selectedSpecies) {
                                    ForEach(activeSpecies) { species in
                                        Text(species.name).tag(species.code)
                                    }
                                }
                                    .frame(width: 440)
                                    .tint(Color("TextForegroundWhite"))
                                    .pickerStyle(.segmented)
                                    .scaleEffect(1.4)
                                    // .frame(minHeight: 30 * fontScalingFactor)
                            } label: {
                                Text("Species:")
                                    .multilineTextAlignment(.leading)
                                Spacer()
                            }
                            .frame(width: 670, height: 30)
                            .padding(.bottom, 12)
                            Spacer()
                       }
                           .padding(.horizontal, 20)
                        
//                        VStack {
//                            HStack {
//                                SegmentedPickerSpecies(selectedSpecies: $selectedSpecies, isValidSpecies: $isValidSpecies)
//                            }
//                        }
//                            .frame(height: 50)
//                            .padding(.bottom, 10)
                        
                        VStack {
                            
                            //   F I S H   L E N G T H
                            HStack {
                                LabeledContent {
                                    TextField("", text: $selectedLength)
                                        .disabled(true)
                                        .border(Color.gray, width: 1)
                                        .foregroundColor(Color("TextForeground"))
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 100)
                                        .multilineTextAlignment(.leading)
                                        .popover(isPresented: $isPresentedLength) {
                                            NumberPadView(isPresented: $isPresentedLength, enteredNumber: $enteredLength)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            isPresentedLength = true
                                        }
                                } label: {
                                    if isValidLength {
                                        Text(Image(systemName: "checkmark.circle.fill")) + Text(" Fish Length: ")
                                    } else {
                                        Text("Fish Length: ")
                                    }
                                }.frame(width: 250)
                                
                                Button {
                                    self.isPresentedLength = true
                                } label: {
                                    Image(systemName: "keyboard.onehanded.right.fill")
                                }
                                .foregroundColor(.white)
                                .background(Color.clear)
                                .font(.system(size: 28, weight: .regular, design: .default))
                                .padding(.trailing, 60)
                                Spacer()
                            }
                            .padding(.bottom, 12)
                            
                            
                            //   F I S H   W E I G H T
                            HStack {
                                LabeledContent {
                                    TextField("", text: $selectedWeight)
                                        .disabled(true)
                                        .border(Color.gray, width: 1)
                                        .foregroundColor(Color("TextForeground"))
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 100)
                                        .multilineTextAlignment(.leading)
                                        .popover(isPresented: $isPresentedWeight) {
                                            NumberPadView(isPresented: $isPresentedWeight, enteredNumber: $enteredWeight)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            isPresentedLength = true
                                        }
                                } label: {
                                    if isValidWeight {
                                        Text(Image(systemName: "checkmark.circle.fill")) + Text(" Fish Weight: ")
                                    } else {
                                        Text("Fish Weight: ")
                                    }
                                }.frame(width: 250)
                                
                                Button {
                                    self.isPresentedWeight = true
                                } label: {
                                    Image(systemName: "keyboard.onehanded.right.fill")
                                }
                                .foregroundColor(.white)
                                .background(Color.clear)
                                .font(.system(size: 28, weight: .regular, design: .default))
                               
                                Spacer()
                            }
                            .padding(.bottom, 12)
                            
                            
                            //  G E N D E R
                            HStack {
                                LabeledContent {
                                    Picker("", selection: $selectedGender) {
                                        Text("Male").tag("M")
                                        Text("Female").tag("F")
                                        Text("Unspecifed").tag("")
                                    }
                                        .frame(width: 300)
                                        .tint(Color("TextForegroundWhite"))
                                        .pickerStyle(.segmented)
                                        .scaleEffect(1.4)
                                        // .frame(minHeight: 30 * fontScalingFactor)
                                } label: {
                                    Text("Sex:")
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .frame(width: 500, height: 30)
                                .padding(.bottom, 12)
                                
                                Spacer()
                            }
                                
                            //   M O R T
                            HStack {
                                LabeledContent {
                                    Picker("", selection: $selectedMortality) {
                                        Text("Yes").tag("Y")
                                        Text("No").tag("N")
                                    }
                                        .frame(width: 300)
                                        .tint(Color("TextForegroundWhite"))
                                        .pickerStyle(.segmented)
                                        .scaleEffect(1.4)
                                } label: {
                                    Text("Mortality:")
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .frame(width: 500, height: 30)
                                .padding(.bottom, 12)
                                
                                Spacer()
                            }
                            
                            //   M / C
                            HStack {
                                LabeledContent {
                                    Picker("", selection: $selectedMC) {
                                        Text("Yes").tag("Y")
                                        Text("No").tag("N")
                                    }
                                        .frame(width: 300)
                                        .tint(Color("TextForegroundWhite"))
                                        .pickerStyle(.segmented)
                                        .scaleEffect(1.4)

                                } label: {
                                    Text("M/C:")
                                        .multilineTextAlignment(.leading)
                                    Spacer()
                                }
                                .frame(width: 500, height: 30)
                                .padding(.bottom, 12)
                                
                                Spacer()
                            }
                            
                            
                            //   C O U N T
                            HStack {
                                LabeledContent {
                                    TextField("", text: $selectedCount)
                                        .disabled(true)
                                        .border(Color.gray, width: 1)
                                        .foregroundColor(Color("TextForeground"))
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 100)
                                        .multilineTextAlignment(.leading)
                                        .popover(isPresented: $isPresentedCount) {
                                            NumberPadView(isPresented: $isPresentedCount, enteredNumber: $enteredCount)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            isPresentedCount = true
                                        }
                                } label: {
                                    Text("Count: ")
                                }.frame(width: 250)
                                
                                Button {
                                    self.isPresentedCount = true
                                } label: {
                                    Image(systemName: "keyboard.onehanded.right.fill")
                                }
                                .foregroundColor(.white)
                                .background(Color.clear)
                                .font(.system(size: 28, weight: .regular, design: .default))
                               
                                Spacer()
                            }
                            .padding(.bottom, 12)
                        
                            
                            
                            
                            //   C O M M E N T S
                            HStack {
                                LabeledContent {
                                    TextField("", text: $selectedComments)
                                        .disabled(true)
                                        .border(Color.gray, width: 1)
                                        .foregroundColor(Color("TextForeground"))
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 350)
                                        .multilineTextAlignment(.leading)
                                        .popover(isPresented: $isPresentedComments) {
                                            ChooseCommentsView(isPresentedComments: $isPresentedComments, selectedComments: $selectedComments)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture {
                                            isPresentedComments = true
                                        }
                                } label: {
                                    Text("Comment(s):")
                                }.frame(width: 500)
                                
                                Button {
                                    self.isPresentedComments = true
                                } label: {
                                    Image(systemName: "keyboard.onehanded.right.fill")
                                }
                                .foregroundColor(.white)
                                .background(Color.clear)
                                .font(.system(size: 28, weight: .regular, design: .default))
                                .padding(.trailing, 60)
                                
                                Spacer()
                            }
                            
                            
                            //   S A V E
                            HStack {
                                Button(action: {
                                    print("Save button tapped")
                                    // verify trip is not already saved
                                    if self.isAddingTrip == true {
                                        let existingTripList = existingTrips.filter { isSameDay(firstDate: $0.date, secondDate: tripData.date) && $0.tripType == tripData.tripType && $0.watershed == tripData.watershed && $0.surveySection == tripData.surveySection }
                                        if existingTripList.count > 0 {
                                            isShowingDuplicateAlert = true
                                        }
                                    } else {
                                        try! modelContext.transaction {
                                            let trip = Trip(
                                                date: tripData.date,
                                                tripType: tripData.tripType,
                                                surveySection: tripData.surveySection,
                                                watershed: tripData.watershed,
                                                gear: tripGear,
                                                rectifyingunit: tripRectifyingunit,
                                                volts: tripVolts,
                                                amps: tripAmps,
                                                shocktime: tripShocktime,
                                                anesthetic: tripAnesthetic,
                                                dosage: tripDosage,
                                                latDown: tripData.latDown,
                                                lonDown: tripData.lonDown,
                                                latUp: tripData.latUp,
                                                lonUp: tripData.lonUp,
                                                sectionLength: tripData.sectionLength,
                                                startTime: tripData.startTime,
                                                endTime: tripData.endTime,
                                                waterTemperature: tripData.waterTemperature,
                                                waterFlow: tripData.waterFlow,
                                                turbidity: tripData.turbidity,
                                                isClosed: "N"
                                            )
                                            
                                            self.isAddingTrip = false
                                            
                                            modelContext.insert(trip)
                                            
                                            let fish = Fish(
                                                date:       trip.date,
                                                pitTag:     pitTagNumber,
                                                lat:        locationsHandler.lastLocation2D.latitude,
                                                lon:        locationsHandler.lastLocation2D.longitude,
                                                species:    selectedSpecies,
                                                fwpSpecies: q.fetchFWPCodeFromCode(context: modelContext, code: selectedSpecies),
                                                weight:     Int(selectedWeight) ?? 0,
                                                length:     Int(selectedLength) ?? 0,
                                                gender:     selectedGender,
                                                mort:       selectedMortality == "Y" ? "1" : "",
                                                mc:         selectedMC == "Y" ? 1 : 0,
                                                count:      Int(selectedCount) ?? 1,
                                                comment:    selectedComments
                                            )
                                            
                                            trip.fish.append(fish)
                                            
                                            selectedSpecies  = ""
                                            selectedGender   = ""
                                            selectedLength   = ""
                                            selectedWeight   = ""
                                            selectedCount    = "1"
                                            enteredLength    = ""
                                            enteredWeight    = ""
                                            enteredCount     = ""
                                            selectedComments = ""
                                            pitTagNumber     = ""
                                            
                                            isValidLength    = false
                                            isValidWeight    = false
                                            isValidSpecies   = false
                                            
                                            try modelContext.save()
                                            
                                            self.tripData = trip.deepCopy()
                                        }
                                    }
                                }) {
                                    Text("Save")
                                        .shadow(color: Color(.black), radius: 2, x: 2, y: 2)
                                        .padding(.horizontal, 10)
                                }
                                    .modifier(ActionButton())
                                    .padding(.top, 8)
                                    .opacity(selectedSpecies.isEmpty ? 0.2 : 1)
                                    .disabled(!isValidSpecies)
                                    .alert("Oops!", isPresented: $isShowingDuplicateAlert) {
                                        Button("OK", role: .cancel) { }
                                    } message: {
                                        Text("This trip already. Please choose a different date or trip type, section or watershed.")
                                    }
                            }
                        }.padding(.horizontal, 12)
                         .padding(.bottom, 20)
                        
                    }
                    .onChange(of: bluetoothManager.pitTagNumber) {
                        if bluetoothManager.pitTagNumber.isEmpty { return }
                        self.pitTagNumber = pitTagPrefix + bluetoothManager.pitTagNumber
                        let timesSeen = checkFishHistoryForPitTag(tag: pitTagNumber)
                        if timesSeen > 0 {
                            print("PIT Tag \(pitTagNumber) has been seen \(timesSeen) times")
                        }
                    }
                    .onChange(of: enteredNumber) {
                        print("onChange enteredNumber")
                        if enteredNumber == "<" && !pitTagNumber.isEmpty {
                            pitTagNumber = String(pitTagNumber.dropLast())
                        } else {
                            pitTagNumber += enteredNumber
                        }
                        enteredNumber = ""
                    }
                    
                    .onChange(of: enteredLength) {
                        print("Entered Length: \(selectedLength)")
                        if enteredLength == "<" && !selectedLength.isEmpty  {
                            selectedLength = String(selectedLength.dropLast())
                        }
                        else {
                            selectedLength += enteredLength
                        }
                        enteredLength = ""
                        isValidLength = !selectedLength.isEmpty ? true : false
                        if let length = Int(selectedLength), length > lengthMax {
                            isValidLength = false
                        }
                    }
                    
                    .onChange(of: enteredWeight) {
                        print("Entered Weight: \(selectedWeight)")
                        if enteredWeight == "<" && !selectedWeight.isEmpty  {
                            selectedWeight = String(selectedWeight.dropLast())
                        }
                        else {
                            selectedWeight += enteredWeight
                        }
                        enteredWeight = ""
                        isValidWeight = !selectedWeight.isEmpty ? true : false
                    }
                    
                    .onChange(of: selectedSpecies) {
                        isValidSpecies = !selectedSpecies.isEmpty
                    }
                    .onChange(of: pitTagNumber) {
                        isValidPitTag = validatePitTag(tag: pitTagNumber)
                    }
                    
                    .onAppear {
                        UISegmentedControl.appearance().backgroundColor = UIColor.lightGray
                    }
                }
            }
        }
        .padding(.vertical, 12)
        .frame(height: 290)
    }
    
    func validatePitTag(tag: String) -> Bool {
        if usingPitTags {
            let pattern = "^[0-9]{15}$"  // exactly 15 digits
            let regex = try! NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: tag.utf16.count)
            let match = regex.firstMatch(in: tag, options: [], range: range)
            if match == nil {
                print("Invalid PIT tag format")
                return false
            }
            print("Valid PIT tag format")
        }
        return true
    }
        
    
    func getBluetoothStatus() -> String {
        switch bluetoothManager.connectionStatus {
            case K.BLUETOOTH_OFF:
                return "Bluetooth is OFF"
            case K.BLUETOOTH_UNAUTHORIZED:
                return "Unauthorized"
            case K.CONNECTING:
                return "Connecting..."
            case K.CONNECTED:
                return "Connected"
            case K.CONNECTION_FAILED:
                return "Failed"
            case K.DISCONNECTED:
                return "Disconnected"
            case K.SCANNING:
                return "Scanning..."
            case K.SCANNING_OFF:
                return "Stopped"
            default:
                return "\(bluetoothManager.connectionStatus)"
        }
    }
    
    func getBluetoothColor() -> Color {
        switch bluetoothManager.connectionStatus {
            case K.BLUETOOTH_OFF:
                return Color.red
            case K.BLUETOOTH_UNAUTHORIZED:
                return Color.red
            case K.CONNECTING:
                print("Connecting")
                return Color.gray
            case K.CONNECTED:
                print("Connected")
                return Color.green
            case K.CONNECTION_FAILED:
                return Color.red
            case K.DISCONNECTED:
                return Color.black
            case K.SCANNING:
                print("Scanning")
                return Color.gray
            case K.SCANNING_OFF:
                return Color.gray
            default:
                return Color.clear
        }
    }
    
    func isSameDay(firstDate: Date, secondDate: Date) -> Bool {
        var calender = Calendar.current
        calender.timeZone = TimeZone.current
        let result = calender.compare(firstDate, to: secondDate, toGranularity: .day)
        return result == .orderedSame
    }
    
    func checkFishHistoryForPitTag(tag: String) -> Int {
        let fish = taggedFish.filter { $0.pitTag == tag }
        if fish.isEmpty {
            return 0;
        } else {
            return fish.count
        }
    }
}

//#Preview {
//    @Previewable @State var path: [String] = [K.TAG]
//    @Previewable @State var tripData: TripData = TripData(date: Date(), tripType: "Marking", surveySection: "Section", watershed: "Watershed")
//    TripFishView(path: $path, tripData: $tripData, isAddingTrip: .constant(true))
//        .environment(LocationsHandler())
//        .environment(JSONManager())
//        .environment(NetworkMonitor())
//}
//
