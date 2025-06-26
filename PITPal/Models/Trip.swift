//
//  Trip.swift
//  PITPal
//
//  Created by Doug Haacke on 6/20/25.
//

import SwiftData
import SwiftUI

@Model
final class Trip: Codable {
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
    var fish: [Fish]
    // #Unique<Trip>([\.date], [\.tripType], [\.surveySection], [\.watershed])
    
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
        fish: [Fish] = []
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
        self.fish = fish
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case tripType
        case surveySection
        case watershed
        case equipment
        case latDown
        case lonDown
        case latUp
        case lonUp
        case sectionLength
        case startTime
        case endTime
        case waterTemperature
        case waterFlow
        case fish
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = try container.decode(String.self, forKey: .date)
        self.date = dateFormatter.date(from: dateString)!
        self.tripType = try container.decode(String.self, forKey: .tripType)
        self.surveySection = try container.decode(String.self, forKey: .surveySection)
        self.watershed = try container.decode(String.self, forKey: .watershed)
        self.equipment = try container.decode(String.self, forKey: .equipment)
        self.latDown = try container.decode(Double.self, forKey: .latDown)
        self.lonDown = try container.decode(Double.self, forKey: .lonDown)
        self.latUp = try container.decode(Double.self, forKey: .latUp)
        self.lonUp = try container.decode(Double.self, forKey: .lonUp)
        self.sectionLength = try container.decode(Double.self, forKey: .sectionLength)
        self.startTime = try container.decode(String.self, forKey: .startTime)
        self.endTime = try container.decode(String.self, forKey: .endTime)
        self.waterTemperature = try container.decode(Double.self, forKey: .waterTemperature)
        self.waterFlow = try container.decode(Double.self, forKey: .waterFlow)
        self.fish = try container.decodeIfPresent([Fish].self, forKey: .fish) ?? []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(tripType, forKey: .tripType)
        try container.encode(watershed, forKey: .watershed)
        try container.encode(equipment, forKey: .equipment)
        try container.encode(latDown, forKey: .latDown)
        try container.encode(lonDown, forKey: .lonDown)
        try container.encode(latUp, forKey: .latUp)
        try container.encode(lonUp, forKey: .lonUp)
        try container.encode(sectionLength, forKey: .sectionLength)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(waterTemperature, forKey: .waterTemperature)
        try container.encode(waterFlow, forKey: .waterFlow)
        try container.encode(fish, forKey: .fish)
    }
    
    func toJSON(trip: Trip) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        let json = """
        {
            "date" : "\(formatter.string(from: trip.date))",
            "tripType": "\(trip.tripType)",
            "watershed": "\(trip.watershed)",
            "equipment": "\(trip.equipment)",
            "latDown": "\(trip.latDown)",
            "lonDown": "\(trip.lonDown)",
            "latUp": "\(trip.latUp)",
            "lonUp": "\(trip.lonUp)",
            "sectionLength": \(trip.sectionLength),
            "startTime": "\(trip.startTime)",
            "endTime": "\(trip.endTime)",
            "waterTemperature": \(waterTemperature),
            "waterFlow": \(waterFlow)
        }
        """
        return json
    }

}



