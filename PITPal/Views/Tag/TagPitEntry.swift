//
//  TagPitEntry.swift
//  PITPal
//
//  Created by Doug Haacke on 6/16/25.
//

import SwiftUI

// @AppStorage("usingPitTags") private var usingPitTags: Bool = true

struct TagPitEntry: View {
    @Environment(LocationsHandler.self) var locationsHandler
    @Environment(JSONManager.self) var jsonManager
    @Environment(NetworkMonitor.self) var networkMonitor
    @Environment(\.scenePhase) var scenePhase
    
    @Binding var path: [String]
    
    @State private var pitTagNumber: String = ""
    @State private var enteredNumber: String = ""
    @State private var showNumberPad: Bool = false
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
                                  .border(Color.gray, width: 1)
                                  .textFieldStyle(.roundedBorder)
                                  .frame(width: 300)
                                  .multilineTextAlignment(.leading)
                                  .focused($isFocused)
                                  .onChange(of: isFocused) {
                                      if isFocused {
                                          showNumberPad = true
                                      }
                                  }
                                  .popover(isPresented: $showNumberPad) {
                                      NumberPadView(isPresented: $showNumberPad, enteredNumber: $enteredNumber)
                                  }
                            } label: {
                                Text("PIT tag #")
                            }.frame(width: 400)
                        }
                    }
                    
                }
                .frame(width: geometry.size.width, height: 60)
                .onChange(of: pitTagNumber) {
                    pitTagNumber += enteredNumber
                }
            }
        }
        .frame(height: 100)
        Spacer()
    }
}


#Preview {
    @Previewable @State var path: [String] = [K.TAG]
    TagPitEntry(path: $path)
        .environment(LocationsHandler())
        .environment(JSONManager())
        .environment(NetworkMonitor())
}


