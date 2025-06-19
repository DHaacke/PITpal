//
//  TagPitEntry.swift
//  PITPal
//
//  Created by Doug Haacke on 6/16/25.
//

import SwiftUI

// @AppStorage("usingPitTags") private var usingPitTags: Bool = true

struct TagPitEntryView: View {
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]
    
    @State private var bluetoothManager = BluetoothManager()
    
    @State private var pitTagNumber: String = ""
    @State private var enteredNumber: String = ""
    
    @State private var species: Int = 0
    
    @State private var fishLength: String = "0"
    @State private var enteredLength: String = ""
    @State private var fishWeight: String = "0"
    @State private var enteredWeight: String = ""
    
    @State private var isPresentedPitTag: Bool = false
    @State private var isPresentedLength: Bool = false
    @State private var isPresentedWeight: Bool = false
    
    

            
    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color("CardBackground"))
                        .shadow(radius: 6, x: 1, y: 3)
                    
                    VStack {
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
                                Text("PIT Tag #")
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
                            
                            VStack {
                                Button {
                                    if bluetoothManager.isConnected == false {
                                        if [K.BLUETOOTH_OFF, K.BLUETOOTH_UNAUTHORIZED, K.CONNECTION_FAILED, K.DISCONNECTED, K.SCANNING_STOPPED].contains(self.bluetoothManager.connectionStatus) {
                                            self.bluetoothManager.startScanning()
                                        } else if [K.CONNECTING, K.SCANNING].contains(self.bluetoothManager.connectionStatus) {
                                            self.bluetoothManager.stopScanning()
                                        }
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
                        }.padding(.horizontal, 20)
                        
                        VStack {
                            HStack {
                                SegmentedPickerSpecies()
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
                                    Text("Fish Length: ")
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
                                    Text("Fish Weight: ")
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
                        }.padding(.horizontal, 20)
                        
                    }
                    .onChange(of: bluetoothManager.pitTagNumber) {
                        self.pitTagNumber = bluetoothManager.pitTagNumber
                    }
                    .onChange(of: enteredNumber) {
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
                    }
                    .onChange(of: enteredWeight) {
                        if enteredWeight == "<" && !fishWeight.isEmpty {
                            fishWeight = String(fishWeight.dropLast())
                        } else {
                            fishWeight += enteredWeight
                        }
                        enteredWeight = ""
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .frame(height: 200)
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
            case K.SCANNING_STOPPED:
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
            case K.SCANNING_STOPPED:
                return Color.gray
            default:
                return Color.clear
        }
    }
}


#Preview {
    @Previewable @State var path: [String] = [K.TAG]
    TagPitEntryView(path: $path)
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}


