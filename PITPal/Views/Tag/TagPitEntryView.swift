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
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 240)
                                    .multilineTextAlignment(.leading)
                                    .popover(isPresented: $isPresented) {
                                        NumberPadView(isPresented: $isPresented, enteredNumber: $enteredNumber)
                                    }
                            } label: {
                                Text("PIT tag #")
                            }.frame(width: 340)
                            
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
                                Image("Bluetooth")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .padding(.trailing, 10)
                                    .onTapGesture {
                                    }
                                HStack {
                                    if bluetoothManager.connectionStatus == K.SCANNING {
                                        ProgressView()
                                            .frame(width: 12, height: 12)
                                    }
                                    Text(getBluetoothStatus())
                                        .foregroundColor(getBluetoothColor())
                                        .font(.system(size: 10, weight: .regular, design: .default))
                                }
                            }
                            .frame(width: 100)
                        }
                        .padding(.horizontal, 20)
                    }
                }
            }
        }
        .frame(height: 60)
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
                return "??"
        }
    }
    
    func getBluetoothColor() -> Color {
        switch bluetoothManager.connectionStatus {
            case K.BLUETOOTH_OFF:
                return Color.red
            case K.BLUETOOTH_UNAUTHORIZED:
                return Color.red
            case K.CONNECTING:
                return Color.blue
            case K.CONNECTED:
                return Color.green
            case K.CONNECTION_FAILED:
                return Color.red
            case K.DISCONNECTED:
                return Color.red
            case K.SCANNING:
                return Color.blue
            case K.SCANNING_STOPPED:
                return Color.red
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


