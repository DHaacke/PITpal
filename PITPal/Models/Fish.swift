//
//  Fish.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import Foundation
import SwiftUI

struct Fish: Codable, Identifiable {
    var id: Int64 = 0
    var tripId: Int64
    var date: String = Date().format(format: "yyyy-MM-dd")
    var lat: Double = 0.0
    var lon: Double = 0.0
    var species: String = ""
    var weight: Double = 0.0
    var length: Double = 0.0
    var gender: String = ""

    enum CodingKeys: String, CodingKey{
        case id
        case tripId
        case date
        case lat
        case lon
        case species
        case weight
        case length
        case gender
    }
    
    init(
        id: Int64,
        tripId: Int64,
        date: String,
        watershed: String,
        lat: Double,
        lon: Double,
        species: String,
        weight: Double,
        length: Double,
        gender: String
    ) {
        self.id = id
        self.tripId = tripId
        self.date = date
        self.lat = lat
        self.lon = lon
        self.species = species
        self.weight = weight
        self.length = length
        self.gender = gender
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.tripId = try container.decode(Int64.self, forKey: .tripId)
        self.date = try container.decode(String.self, forKey: .date)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.species = try container.decode(String.self, forKey: .species)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.length = try container.decode(Double.self, forKey: .length)
        self.gender = try container.decode(String.self, forKey: .gender)
    }
}

