//
//  SplitColorView.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import SwiftUI

struct SplitColorView: View {
    var body: some View {
        ScrollView {
            // SplitColorScheme {
            SplitScreenView {
                Section("Standard Colors") {
                    Color.black
                        .overlay {
                            Text("Black")
                        }
                    Color.blue
                        .overlay {
                            Text("Blue")
                        }
                    Color.brown
                        .overlay {
                            Text("Brown")
                        }
                    Color.clear
                        .overlay {
                            Text("Clear")
                        }
                    Color.cyan
                        .overlay {
                            Text("Cyan")
                        }
                    Color.gray
                        .overlay {
                            Text("Gray")
                        }
                    Color.green
                        .overlay {
                            Text("Green")
                        }
                    Color.indigo
                        .overlay {
                            Text("Indigo")
                        }
                    Color.mint
                        .overlay {
                            Text("Mint")
                        }
                    Color.orange
                        .overlay {
                            Text("Orange")
                        }
                    Color.pink
                        .overlay {
                            Text("Pink")
                        }
                    Color.purple
                        .overlay {
                            Text("Purple")
                        }
                    Color.red
                        .overlay {
                            Text("Red")
                        }
                    Color.teal
                        .overlay {
                            Text("Teal")
                        }
                    Color.white
                        .overlay {
                            Text("White")
                        }
                    Color.yellow
                        .overlay {
                            Text("Yellow")
                        }
                }
            }
        }
    }
}

#Preview {
    SplitColorView()
}
