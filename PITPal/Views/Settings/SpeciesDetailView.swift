//
//  SpeciesDetailView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/6/25.
//

import SwiftUI
import SwiftData

struct SpeciesDetailView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State var species: Species
    @State var isAddingSpecies: Bool
    
    @State private var isActive: Bool = true
    @State private var isShowingAddAlert: Bool = false
    @State private var isShowingDeleteAlert: Bool = false
    
    @State private var isChanged: Bool = false
    
    @Query(sort: \Species.name, order: .forward) var speciesList: [Species]
    @Query(sort: \Fish.species, order: .forward) var fishList: [Fish]
    
    var body: some View {
        VStack {
            Text("Edit \(species.name)")
                .font(.title)
            HStack {
                Text("Code:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $species.code)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            HStack {
                Text("FWP Code:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $species.fwpCode)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            HStack {
                Text("Name:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $species.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            HStack {
                Text("Image Name:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $species.imageName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 100)
                    .foregroundColor(Color("TextForeground"))
                Spacer()
            }
            HStack {
                Text("Color:")
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                TextField("", text: $species.color)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 200)
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
                if isAddingSpecies {
                    Button(action: {
                        let dupes = speciesList.filter { $0.code == species.code }
                        if !species.code.isEmpty && !species.name.isEmpty && !species.fwpCode.isEmpty && dupes.isEmpty {
                            print("Adding species: \(species.code)")
                            modelContext.insert(species)
                            try! modelContext.save()
                            dismiss()
                        } else {
                            isShowingAddAlert = true
                        }
                    }) {
                        Text("Add")
                            .padding(.horizontal, 10)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                        
                    }
                    .modifier(ActionButton())
                    .alert("Oops! You must enter a unique code and at least a name and FWP code.", isPresented: $isShowingAddAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                if !isAddingSpecies {
                    Button(action: {
                        let exists = fishList.filter { $0.species == species.code }
                        if exists.isEmpty {
                            modelContext.delete(species)
                            try! modelContext.save()
                            dismiss()
                        } else {
                            isShowingDeleteAlert = true
                        }
                    }) {
                        Text("Delete")
                            .padding(.horizontal, 10)
                            .shadow(color: .black, radius: 2, x: 2, y: 2)
                    }
                    .modifier(ActionButton(backgroundColor: Color.red) )
                    .alert("Oops! You cannot delete a species that is currently used in a fish record.", isPresented: $isShowingDeleteAlert) {
                        Button("OK", role: .cancel) { }
                    }
                }
                Spacer()
            }
            HStack {
                Spacer()
                Button(action: {
                    if isChanged {
                        try! modelContext.save()
                    }
                    dismiss()
                }) {
                    Text("Save")
                        .padding(.horizontal, 10)
                        .shadow(color: .black, radius: 2, x: 2, y: 2)
                }
                .modifier(ActionButton())
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
        
        .onChange(of: isActive) {
            species.active = isActive == true ? "Y" : "N"
            isChanged = true
        }
        .onChange(of: $species.code.wrappedValue) {
            isChanged = true
        }
        .onChange(of: $species.fwpCode.wrappedValue) {
            isChanged = true
        }
        .onChange(of: $species.name.wrappedValue) {
            isChanged = true
        }
        .onChange(of: $species.imageName.wrappedValue) {
            isChanged = true
        }
        .onChange(of: $species.color.wrappedValue) {
            isChanged = true
        }
        .onAppear {
            isActive = species.active == "Y" ? true : false
        }
    }
}

struct PaddedSizing: PresentationSizing {
    func proposedSize(for root: PresentationSizingRoot, context: PresentationSizingContext) -> ProposedViewSize {
        let size = root.sizeThatFits(.unspecified)
        return ProposedViewSize(width: size.width + 20, height: size.height + 20)
    }
}

extension PresentationSizing where Self == PaddedSizing {
    static var padded: Self {
        PaddedSizing()
    }
}
/*
#Preview {
    SpeciesDetailView(species: .constant(Species(code: "ABCD", fwpCode: "000", name: "Example Species", imageName: "whatever", color: "Blue", active: "Y")))
}
*/

/*
 @Attribute(.unique) var code: String
 var fwpCode: String = ""
 var name: String
 var imageName: String
 var color: String
 var active: String
 
 */
