//
//  Trip.swift
//  PITPal
//
//  Created by Doug Haacke on 6/20/25.
//

import SwiftData
import SwiftUI

@Model
class Trip {
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
        waterFlow: Double = 0
    ) {
        self.date = date
        self.watershed = watershed
        self.initialLat = initialLat
        self.initialLon = initialLon
        self.waterTemperature = waterTemperature
        self.waterFlow = waterFlow
    }
    
    func toJSON(trip: Trip) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        // let formattedDate = formatter.string(from: Date())
        
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

@Model
class Fish {
    var date: Date
    var lat: Double
    var lon: Double
    var surveySection: String
    var species: String
    var weight: Double
    var length: Double
    var gender: String
    
    init(
        date: Date = Date(),
        lat: Double = 0.0,
        lon: Double = 0.0,
        surveySection: String = "",
        species: String = "",
        weight: Double = 0.0,
        length: Double = 0.0,
        gender: String = ""
    ) {
        self.date = date
        self.lat = lat
        self.lon = lon
        self.surveySection = surveySection
        self.species = species
        self.weight = weight
        self.length = length
        self.gender = gender
    }
    
}

