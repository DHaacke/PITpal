//
//  SpeciesDetailView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/6/25.
//

import SwiftUI

struct SpeciesDetailView: View {
    
    @State var species: Species
    
    @State private var isActive: Bool = true
    
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
                AddButton(onAddButtonTapped: {
                    print("Add Button tapped")
                })
                .padding(.trailing, 100)
                DeleteButton(onDeleteButtonTapped: {
                    print("Delete Button tapped")
                })
                Spacer()
            }
            HStack {
                Spacer()
                EditDoneButton(onEditDoneButtonTapped: {
                    print("Edit Button tapped")
                })
                Spacer()
            }
            Spacer()
        }
        .padding(.horizontal, 60)
        .padding(.vertical, 20)
        .presentationSizing(.padded)
        .background(Color("AppBackground"))
        .foregroundColor(Color("TextForegroundWhite"))
        
        .onChange(of: isActive) {
            species.active = isActive == true ? "Y" : "N"
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
