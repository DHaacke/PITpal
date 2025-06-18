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
    @State private var species: Int = 0
    @State private var enteredNumber: String = ""
    @State private var isPresented: Bool = false
    @FocusState private var isFocused
            
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
                                    .popover(isPresented: $isPresented) {
                                        NumberPadView(isPresented: $isPresented, enteredNumber: $enteredNumber)
                                    }
                            } label: {
                                Text("PIT TAG #")
                            }.frame(width: 450)
                            
                            Button {
                                self.isPresented = true
                            } label: {
                                Image(systemName: "keyboard.onehanded.right.fill")
                            }
                            .foregroundColor(.white)
                            .background(Color.clear)
                            .font(.system(size: 28, weight: .regular, design: .default))
                            
                            Spacer()
                            
                            VStack {
                                Button {
                                    if [K.BLUETOOTH_OFF, K.BLUETOOTH_UNAUTHORIZED, K.CONNECTION_FAILED, K.DISCONNECTED, K.SCANNING_STOPPED].contains(self.bluetoothManager.connectionStatus) {
                                        self.bluetoothManager.startScanning()
                                    } else if [K.CONNECTING, K.SCANNING].contains(self.bluetoothManager.connectionStatus) {
                                        self.bluetoothManager.stopScanning()
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
                }
            }
        }
        .padding(.vertical, 10)
        .frame(height: 160)
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


