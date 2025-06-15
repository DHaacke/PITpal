//
//  JSONManager.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import Foundation
import CoreLocation
import SwiftUI

@Observable
class JSONManager: NSObject {
    var isConfigLoaded: Bool = false
    var tripInProgress: Bool = false
    var config: Config = Config(gender: [], season: [], species: [], surveySection: [], watershed: [])
    
//    var trip: Trip = Trip(id: UUID(), date: Date().format(format: "yyyy-MM-dd"), identifier: "", river: "UNK", initialLat: 0.0, initialLon: 0.0, anglers: 2, method: "", transport: "", notes: "", route: [], fish: [])
//    var trips: [Trip] = []
    
    override init() {
        super.init()
        Task {
            await loadConfig()
        }
    }
    
    func loadConfig() async {
        print("Loading config.json...")
        self.config = Bundle.main.decodeJson(Config.self, file: "config.json")
        self.isConfigLoaded = true
        print("Config loaded...")
        print(config)
    }
    
}
