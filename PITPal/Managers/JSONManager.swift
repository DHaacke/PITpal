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
    var config: Config = Config(trip: [], species: [], gender: [], surveySection: [], watershed: [], tripType: [], comment: [], gear: [] )
    
    override init() {
        super.init()
        Task {
            await loadConfig()
        }
    }
    
    func loadConfig() async {
        print("Loading config.json...")
        self.config = Bundle.main.decodeJson(Config.self, file: "config-master.json")
        self.isConfigLoaded = true
        print("Config loaded...")
    }
    
}
