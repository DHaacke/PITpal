//
//  SettingsView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("darkMode") private var darkMode: Bool = false

    @AppStorage("uomFishLength") private var uomFishLength: String = "mm"
    @AppStorage("lengthMin") private var lengthMin: Int = 0
    @AppStorage("lengthMax") private var lengthMax: Int = 2000
    @AppStorage("useBluetoothLength") private var useBluetoothLength: Bool = false
    @AppStorage("uomFishWeight") private var uomFishWeight: String = "gm"
    @AppStorage("weightMin") private var weightMin: Int = 0
    @AppStorage("weightMax") private var weightMax: Int = 1000
    @AppStorage("useBluetoothWeight") private var useBluetoothWeight: Bool = false
    
    @AppStorage("boatCaptain") private var boatCaptain: String = ""
    @AppStorage("biologistPrimary") private var biologistPrimary: String = ""
    @AppStorage("biologistSecondary") private var biologistSecondary: String = ""
    @AppStorage("technicians") private var technicians: String = ""
    @AppStorage("volunteers") private var volunteers: String = ""
    
    @Binding var path: [String]
    
    let decimalFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }()
    
    let angleFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        VStack {
            Form {
                Section(
                    header: Text("Appearance").font(.title2).foregroundStyle(.white)) {
                    LabeledContent {
                        Toggle("", isOn: $darkMode)
                            .frame(width: 50, height: 40)
                            .shadow(radius: 2)
                    } label: {
                        Text("Use Dark Mode")
                        Text("Dark Mode may help in bright sunlight.")
                            .font(.footnote)
                    }.frame(width: 500)
                }
                .listRowBackground(Color("CardBackground"))
                
                Section(header: Text("Length Measurements").font(.title2).foregroundStyle(.white)) {
                    LabeledContent {
                        Picker("", selection: $uomFishLength) {
                            Text("Millimeters").tag("mm")
                            Text("Grams").tag("gm")
                        }.tint(Color("TextForegroundWhite"))
                    } label: {
                        Text("Unit of Measurement for Length")
                    }.frame(width: 500, height: 40)
                    
                    LabeledContent {
                        TextField("", value: $lengthMin, formatter: NumberFormatter())
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 100)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Min Length")
                    }.frame(width: 500)
                    LabeledContent {
                        TextField("", value: $lengthMax, formatter: NumberFormatter())
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 100)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishLength).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Max Length")
                    }.frame(width: 500)
                    LabeledContent {
                        Toggle("", isOn: $useBluetoothLength)
                            .frame(width: 50, height: 40)
                            .shadow(radius: 2)
                    } label: {
                        Text("Use Bluetooth Length")
                    }.frame(width: 500)
                }
                .listRowBackground(Color("CardBackground"))
                
                Section(header: Text("Weight Measurements").font(.title2).foregroundStyle(.white)) {
                    LabeledContent {
                        Picker("", selection: $uomFishWeight) {
                            Text("Grams").tag("gm")
                            Text("Kilograms").tag("kg")
                            Text("Ounces").tag("oz")
                            Text("Pounds").tag("lb")
                        }.tint(Color("TextForegroundWhite"))
                    } label: {
                        Text("Unit of Measurement for Weight")
                    }.frame(width: 500, height: 40)
                    
                    LabeledContent {
                        TextField("", value: $weightMin, formatter: NumberFormatter())
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 100)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishWeight).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Min Weight")
                    }.frame(width: 500)
                    LabeledContent {
                        TextField("", value: $weightMax, formatter: NumberFormatter())
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 100)
                          .multilineTextAlignment(.trailing)
                        Text(uomFishWeight).frame(width: 40, alignment: .leading)
                    } label: {
                        Text("Max Weight")
                    }.frame(width: 500)
                    LabeledContent {
                        Toggle("", isOn: $useBluetoothWeight)
                            .frame(width: 50, height: 40)
                            .shadow(radius: 2)
                    } label: {
                        Text("Use Bluetooth Weight")
                    }.frame(width: 500)
                }
                .listRowBackground(Color("CardBackground"))

                Section(header: Text("Personnel").font(.title2).foregroundStyle(.white)) {
                    LabeledContent {
                        TextField("", text: $boatCaptain)
                          .border(Color.gray, width: 1)
                          .textFieldStyle(.roundedBorder)
                          .frame(width: 400)
                          .multilineTextAlignment(.leading)
                    } label: {
                        Text("Boat Captain")
                    }.frame(width: 600)
                    
                    LabeledContent {
                        TextField("", text: $biologistPrimary)
                          .textFieldStyle(.roundedBorder)
                          .border(Color.gray, width: 1)
                          .frame(width: 400)
                          .multilineTextAlignment(.leading)
                    } label: {
                        Text("Primary Biologist")
                    }.frame(width: 600)
                    
                    LabeledContent {
                        TextField("", text: $biologistSecondary)
                          .textFieldStyle(.roundedBorder)
                          .border(Color.gray, width: 1)
                          .frame(width: 400)
                          .multilineTextAlignment(.leading)
                    } label: {
                        Text("Secondary Biologist")
                    }.frame(width: 600)
                    
                    LabeledContent {
                        TextField("", text: $technicians)
                          .textFieldStyle(.roundedBorder)
                          .border(Color.gray, width: 1)
                          .frame(width: 400)
                          .multilineTextAlignment(.leading)
                    } label: {
                        Text("Technician(s)")
                    }.frame(width: 600)

                    
                    LabeledContent {
                        TextField("", text: $volunteers)
                          .textFieldStyle(.roundedBorder)
                          .border(Color.gray, width: 1)
                          .frame(width: 400)
                          .multilineTextAlignment(.leading)
                    } label: {
                        Text("Volunteer(s)")
                    }.frame(width: 600)
                }
                .listRowBackground(Color("CardBackground"))
            } // end of form
            .scrollContentBackground(.hidden)
            .background(Color("AppBackground"))
            
            Spacer()
            DoneButton(path: $path, nextView: K.MAINMENU)
               
       } // end of VStack
        .background(Color("AppBackground"))
        .frame(minWidth: 0, maxWidth: .infinity)
        
    } // end of View
        
}

#Preview {
    SettingsView(path: .constant([]))
}
