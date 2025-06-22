//
//  Trip.swift
//  PITPal
//
//  Created by Doug Haacke on 6/20/25.
//

import SwiftData
import SwiftUI

@Model
class Trip: Codable {
    #Unique<Trip>([\.date], [\.watershed])
    var date: Date
    var watershed: String
    var initialLat: Double
    var initialLon: Double
    var waterTemperature: Double
    var waterFlow: Double
    @Relationship(deleteRule: .cascade) var fish = [Fish]()
    
    init(
        date: Date = Date(),
        watershed: String = "",
        initialLat: Double = 0.0,
        initialLon: Double = 0.0,
        waterTemperature: Double = 0,
        waterFlow: Double = 0,
        fish: [Fish] = []
    ) {
        self.date = date
        self.watershed = watershed
        self.initialLat = initialLat
        self.initialLon = initialLon
        self.waterTemperature = waterTemperature
        self.waterFlow = waterFlow
        self.fish = fish
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case watershed
        case initialLat
        case initialLon
        case waterTemperature
        case waterFlow
        case fish
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.watershed = try container.decode(String.self, forKey: .watershed)
        self.initialLat = try container.decode(Double.self, forKey: .initialLat)
        self.initialLon = try container.decode(Double.self, forKey: .initialLon)
        self.waterTemperature = try container.decode(Double.self, forKey: .waterTemperature)
        self.waterFlow = try container.decode(Double.self, forKey: .waterFlow)
        self.fish = try container.decode([Fish].self, forKey: .fish)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(watershed, forKey: .watershed)
        try container.encode(initialLat, forKey: .initialLat)
        try container.encode(initialLon, forKey: .initialLon)
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
            "watershed": "\(trip.watershed)",
            "initialLat": \(trip.initialLat),
            "initialLon": \(trip.initialLon),
            "waterTemperature": \(waterTemperature),
            "waterFlow": \(waterFlow)
        }
        """
        return json
    }

}



