//
//  ChooseCommentsView.swift
//  PITPal
//
//  Created by Doug Haacke on 7/3/25.
//

import SwiftUI
import SwiftData

struct ChooseCommentsView: View {
    @Environment(\.modelContext) var modelContext
    
    @Binding var isPresentedComments: Bool
    @Binding var selectedComments: String
    
    @State private var comments: [CommentData] = []

    // @State private var selection = Set<String>()
    @Query(sort: \Comment.sort) var commentList: [Comment]
    
    var body: some View {
        VStack {
            // EditButton().hidden()
            Section {
                List(comments, id: \.code) { comment in
                    if !comment.selected {
                        Text("\(comment.name)")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .tag(comment.code)
                            .foregroundStyle(.black)
                            .onTapGesture {
                                comment.selected = true
                                selectedComments = ""
                                for c in comments {
                                    if c.selected {
                                        if !selectedComments.isEmpty {
                                            selectedComments += ", "
                                        }
                                        selectedComments += "\(c.code)"
                                    }
                                }
                            }
                    }
                }
                .background(Color("CardBackground"))
                .scrollContentBackground(.hidden)
            }
            
            HStack {
                Button("Done") {
                    print("Done button pressed")
                    isPresentedComments = false // Dismiss the popover
                }
                    .foregroundColor(Color("TextForeground"))
                    .padding(.bottom, 10)
                Spacer()
                Button("Reset") {
                    print("Reset button pressed")
                    selectedComments = ""
                    for c in comments {
                        c.selected = false // Reset all comments
                    }
                }
                    .foregroundColor(Color("TextForeground"))
                    .padding(.bottom, 10)
            }
            .padding()
        }
        .background(Color("AppBackground"))
        .frame(width: 200, height: 780)
        .onAppear {
            for c in commentList {
                comments.append(c.deepCopy())
            }
            for c in commentList {
                c.selected = false
            }
        }
    }
}


//#Preview {
//    ChooseCommentsView()
//        .environment(\.modelContext)
//}
    
