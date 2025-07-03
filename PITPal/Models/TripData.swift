//
//  TripData.swift
//  PITPal
//
//  Created by Doug Haacke on 6/30/25.
//

import SwiftUI

final class TripData {
    var date: Date
    var tripType: String  // M or R
    var surveySection: String
    var watershed: String
    var equipment: String
    var latDown: Double
    var lonDown: Double
    var latUp: Double
    var lonUp: Double
    var sectionLength: Double  // meters
    var startTime: String      // 08:35
    var endTime: String        // 17:10
    var waterTemperature: Double
    var waterFlow: Double
    var turbidity: String
    var isClosed: String
    var fish: [FishData]
    
    init(
        date: Date = Date(),
        tripType: String = "M",
        surveySection: String = "",
        watershed: String = "",
        equipment: String = "",
        latDown: Double = 0.0,
        lonDown: Double = 0.0,
        latUp: Double = 0.0,
        lonUp: Double = 0.0,
        sectionLength: Double = 0.0,
        startTime: String = "",
        endTime: String = "",
        waterTemperature: Double = 0,
        waterFlow: Double = 0,
        turbidity: String = "CLEAR",
        isClosed: String = "Y",
        fish: [FishData] = []
    ) {
        self.date = date
        self.tripType = tripType
        self.surveySection = surveySection
        self.watershed = watershed
        self.equipment = equipment
        self.latDown = latDown
        self.lonDown = lonDown
        self.latUp = latUp
        self.lonUp = lonUp
        self.sectionLength = sectionLength
        self.startTime = startTime
        self.endTime = endTime
        self.waterTemperature = waterTemperature
        self.waterFlow = waterFlow
        self.turbidity = turbidity
        self.isClosed = isClosed
        self.fish = fish
    }
}

