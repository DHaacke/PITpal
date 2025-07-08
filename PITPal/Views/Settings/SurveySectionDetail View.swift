//
//  SurveySectionDetail View.swift
//  PITPal
//
//  Created by Doug Haacke on 7/7/25.
//

import SwiftUI
import SwiftData

struct SurveySectionDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var surveySection: SurveySection
    @State var isAddingSurveySection: Bool
    
    @State private var isActive: Bool = true
    @State private var isShowingAddAlert: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
    
    @Query(sort: \SurveySection.name, order: .forward) var surveySectionList: [SurveySection]
    
    enum FocusedField {
        case int, dec
    }
    @FocusState private var focusedField: FocusedField?
    @State private var latDownText = ""
    @State private var lonDownText = ""
    @State private var latUpText = ""
    @State private var lonUpText = ""
    @State private var radiusText = ""
    
    var body: some View {
        VStack {
            Text("Edit \(surveySection.name)")
                .font(.title)
            HStack {
                Text("Code:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $surveySection.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            
            HStack {
                Text("Color:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $surveySection.color)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            
            HStack {
                Text("Lat Down:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $latDownText)
                    .focused($focusedField, equals: .dec)
                    .numbersOnly($latDownText, includeDecimal: true)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            HStack {
                Text("Lon Down:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $lonDownText)
                    .focused($focusedField, equals: .dec)
                    .numbersOnly($lonDownText, includeDecimal: true)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            HStack {
                Text("Lat Up:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $latUpText)
                    .focused($focusedField, equals: .dec)
                    .numbersOnly($latUpText, includeDecimal: true)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            HStack {
                Text("Lon Up:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $lonUpText)
                    .focused($focusedField, equals: .dec)
                    .numbersOnly($lonUpText, includeDecimal: true)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            
            HStack {
                Text("Radius:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $radiusText)
                    .focused($focusedField, equals: .dec)
                    .numbersOnly($radiusText, includeDecimal: true)
                    .disableAutocorrection(true)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }

            HStack {
                Text("Active:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                Toggle("", isOn: $isActive)
                    .frame(width: 50, height: 40)
                    .tint(Color.green)
                    .shadow(radius: 2)
                Spacer()
            }
            .padding(.bottom, 20)
            
            HStack {
                Spacer()
                if isAddingSurveySection {
                    AddButton(onAddButtonTapped: {
                        let dupes = surveySectionList.filter { $0.code == surveySection.code }
                        if !surveySection.code.isEmpty && dupes.isEmpty {
                            print("Adding survey section: \(surveySection.code)")
                            modelContext.insert(surveySection)
                            try! modelContext.save()
                            dismiss()
                        } else {
                            isShowingAddAlert = true
                        }
                    })
                    .alert("Oops! You must enter a unique code.", isPresented: $isShowingAddAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                if !isAddingSurveySection {
                    DeleteButton(onDeleteButtonTapped: {
                        let exists = surveySectionList.filter { $0.code == surveySection.code }
                        if exists.isEmpty {
                            modelContext.delete(surveySection)
                            try! modelContext.save()
                            dismiss()
                        } else {
                            isShowingDeleteAlert = true
                        }
                    })
                    .alert("Oops! You cannot delete a survey section that is currently used.", isPresented: $isShowingDeleteAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                EditDoneButton(onEditDoneButtonTapped: {
                    dismiss()
                })
                Spacer()
            }
            .padding(.top, 20)
            Spacer()
        }
        .padding(.horizontal, 60)
        .padding(.vertical, 20)
        .presentationSizing(.padded)
        .background(Color("AppBackground"))
        .foregroundColor(Color("TextForegroundWhite"))

        .onChange(of: radiusText) {
            surveySection.radius = Double(radiusText) ?? 0.0
        }
        .onChange(of: latUpText) {
            surveySection.latUp   = Double(latUpText) ?? 0.0
        }
        .onChange(of: lonUpText) {
            surveySection.lonUp   = Double(lonUpText) ?? 0.0
        }
        .onChange(of: latDownText) {
            surveySection.latDown = Double(latDownText) ?? 0.0
        }
        .onChange(of: lonDownText) {
            surveySection.lonDown = Double(lonDownText) ?? 0.0
        }
        .onChange(of: isActive) {
            surveySection.active = isActive == true ? "Y" : "N"
        }
        .onAppear {
            latDownText = String(format: "%.8f", surveySection.latDown)
            lonDownText = String(format: "%.8f", surveySection.lonDown)
            latUpText   = String(format: "%.8f", surveySection.latUp)
            lonUpText   = String(format: "%.8f", surveySection.lonUp)
            
            isActive = surveySection.active == "Y" ? true : false
        }
    }
}

