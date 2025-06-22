//
//  TagFishEntryView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/16/25.
//

import SwiftUI

// @AppStorage("usingPitTags") private var usingPitTags: Bool = true

struct TagFishEntryView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]
    
    @AppStorage("usingPitTags") private var usingPitTags: Bool = true
    
    @State private var bluetoothManager = BluetoothManager()
    
    @Binding var surveySection: String
    
    @State private var pitTagNumber: String = ""
    @State private var enteredNumber: String = ""
    
    @State private var speciesCode: String = ""
    @State private var fishLength: String = "0"
    @State private var enteredLength: String = ""
    @State private var fishWeight: String = "0"
    @State private var enteredWeight: String = ""
    
    @State private var isPresentedPitTag: Bool = false
    @State private var isPresentedLength: Bool = false
    @State private var isPresentedWeight: Bool = false
    
    @State private var isValidPitTag: Bool = false
    @State private var isValidSpecies: Bool = false
    @State private var isValidSurveySection: Bool = false
    @State private var isValidLength: Bool = false
    @State private var isValidWeight: Bool = false
          
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
                                        Text(Image(systemName: "checkmark.circle.fill")) + Text(" PIT Tag #")
                                    } else {
                                        Text(" PIT Tag #")
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
                                        Button {
                                            if bluetoothManager.isConnected == false || bluetoothManager.connectionStatus == K.DISCONNECTED {
                                                print(getBluetoothStatus())
                                                print("* * Restarting Bluetooth * *")
                                                bluetoothManager.restart()
                                            }
                                        } label: {
                                            Image("Bluetooth")
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .shadow(radius: 8)
                                                .frame(width: 30, height: 30)
                                                .padding(0)
                                        }
                                            .buttonStyle(PlainButtonStyle())
                                            .padding(0)

                                        HStack {
                                            if bluetoothManager.connectionStatus == K.SCANNING {
                                                ProgressView()
                                                    .frame(width: 12, height: 12)
                                            }
                                            Text(getBluetoothStatus())
                                                .foregroundColor(Color("TextForegroundWhite"))  // getBluetoothColor()
                                                .font(.system(size: 10, weight: .regular, design: .default))
                                                .shadow(radius: 3)
                                        }
                                    }
                                    .frame(width: 140)
                                }
                            }
                            .padding(.horizontal, 20)
                            .frame(height: usingPitTags ? 50 : 0)
                        } else {
                            Text("Not using PIT tags")
                        }

                        
                        VStack {
                            HStack {
                                SegmentedPickerSpecies(speciesCode: $speciesCode, isValidSpecies: $isValidSpecies)
                                    
                            }
                        }
                            .frame(height: 50)
                            .padding(.bottom, 10)
                        
                        VStack {
                            HStack {
                                LabeledContent {
                                    TextField("", text: $fishLength)
                                        .disabled(true)
                                        .border(Color.gray, width: 1)
                                        .foregroundColor(Color("TextForeground"))
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 80)
                                        .multilineTextAlignment(.leading)
                                        .popover(isPresented: $isPresentedLength) {
                                            NumberPadView(isPresented: $isPresentedLength, enteredNumber: $enteredLength)
                                        }
                                } label: {
                                    if isValidLength {
                                        Text(Image(systemName: "checkmark.circle.fill")) + Text(" Fish Length: ")
                                    } else {
                                        Text("Fish Length: ")
                                    }
                                }.frame(width: 200)
                                
                                Button {
                                    self.isPresentedLength = true
                                } label: {
                                    Image(systemName: "keyboard.onehanded.right.fill")
                                }
                                .foregroundColor(.white)
                                .background(Color.clear)
                                .font(.system(size: 28, weight: .regular, design: .default))
                                .padding(.trailing, 60)
                                
                                LabeledContent {
                                    TextField("", text: $fishWeight)
                                        .disabled(true)
                                        .border(Color.gray, width: 1)
                                        .foregroundColor(Color("TextForeground"))
                                        .textFieldStyle(.roundedBorder)
                                        .frame(width: 80)
                                        .multilineTextAlignment(.leading)
                                        .popover(isPresented: $isPresentedWeight) {
                                            NumberPadView(isPresented: $isPresentedWeight, enteredNumber: $enteredWeight)
                                        }
                                } label: {
                                    if isValidWeight {
                                        Text(Image(systemName: "checkmark.circle.fill")) + Text(" Fish Weight: ")
                                    } else {
                                        Text("Fish Weight: ")
                                    }
                                }.frame(width: 200)
                                
                                Button {
                                    self.isPresentedWeight = true
                                } label: {
                                    Image(systemName: "keyboard.onehanded.right.fill")
                                }
                                .foregroundColor(.white)
                                .background(Color.clear)
                                .font(.system(size: 28, weight: .regular, design: .default))
                                .padding(.trailing, 60)
                                
                                Spacer()
                            }
                            HStack {
                                SaveButton(onSaveButtonTapped: {
                                    print("Save button tapped")
                                })
                                    .padding(.vertical, 20)
                                    .opacity(fishLength.isEmpty || fishWeight.isEmpty || speciesCode.isEmpty || surveySection.isEmpty ? 0.2 : 1)
                                    .disabled(isValidLength || isValidWeight || isValidSpecies || isValidSurveySection || (isValidPitTag && usingPitTags))
                            }
                            HStack {
                                
                            }
                        }.padding(.horizontal, 20)
                        
                    }
                    .onChange(of: bluetoothManager.pitTagNumber) {
                        if bluetoothManager.pitTagNumber.isEmpty { return }
                        self.pitTagNumber = bluetoothManager.pitTagNumber
                        bluetoothManager.pitTagNumber = ""
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
                        if enteredLength == "<" && !fishLength.isEmpty {
                            fishLength = String(fishLength.dropLast())
                        } else {
                            fishLength += enteredLength
                        }
                        enteredLength = ""
                        isValidLength = Int(fishLength) ?? 0 > 0
                    }
                    .onChange(of: enteredWeight) {
                        if enteredWeight == "<" && !fishWeight.isEmpty {
                            fishWeight = String(fishWeight.dropLast())
                        } else {
                            fishWeight += enteredWeight
                        }
                        enteredWeight = ""
                        isValidWeight = Int(fishWeight) ?? 0 > 0
                    }
                    .onChange(of: speciesCode) {
                        isValidSpecies = !speciesCode.isEmpty
                        isValidSurveySection = !surveySection.isEmpty
                    }
                    .onChange(of: pitTagNumber) {
                        isValidPitTag = validatePitTag(tag: pitTagNumber)
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .frame(height: 200)
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
}


#Preview {
    @Previewable @State var path: [String] = [K.TAG]
    @Previewable @State var surveySection: String = ""
    TagFishEntryView(path: $path, surveySection: $surveySection)
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}


