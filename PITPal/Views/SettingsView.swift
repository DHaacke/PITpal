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
       

//            ScrollView(showsIndicators: false) {
                VStack {
                    Form {
                        Section(header: Text("Appearance").font(.headline)) {
                            LabeledContent {
                                Toggle("", isOn: $darkMode)
                                    .frame(width: 50, height: 40)
                            } label: {
                                Text("Use Dark Mode")
                                Text("Dark Mode may help in bright sunlight.")
                                    .font(.footnote)
                            }.frame(width: 500)
                        }
                        Section(header: Text("Length Measurements").font(.headline)) {
                            LabeledContent {
                                Picker("", selection: $uomFishLength) {
                                    Text("Millimeters").tag("mm")
                                    Text("Grams").tag("gm")
                                }
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
                            } label: {
                                Text("Use Bluetooth Length")
                            }.frame(width: 500)
                        }
                        
                        Section(header: Text("Weight Measurements").font(.headline)) {
                            LabeledContent {
                                Picker("", selection: $uomFishWeight) {
                                    Text("Grams").tag("gm")
                                    Text("Kilograms").tag("kg")
                                    Text("Ounces").tag("oz")
                                    Text("Pounds").tag("lb")
                                }
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
                            } label: {
                                Text("Use Bluetooth Weight")
                            }.frame(width: 500)
                        }
                    }
                }

    }
}

#Preview {
    SettingsView(path: .constant([]))
}


