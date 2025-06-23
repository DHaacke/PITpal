//
//  Coordinate.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI
import CoreLocation

struct Coordinate: Codable, Identifiable {
    var id: UUID
    var lat: Double
    var lon: Double
    var altitude: Double = 0.0
    
    init(latitude: Double, longitude: Double, altitude: Double = 0.0) {
        self.id = UUID()
        self.lat = latitude
        self.lon = longitude
        self.altitude = altitude
    }
        
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case altitude
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .lat)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.altitude = try container.decode(Double.self, forKey: .altitude)
    }
}

struct CoordinateTime: Codable {
    var lat: Double
    var lon: Double
    var time: Int
    
    enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case time
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.time = try container.decode(Int.self, forKey: .time)
    }
}

struct Poly: Codable {
    var poly: [Coordinate]
    
    enum CodingKeys: String, CodingKey {
        case poly
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.poly = try container.decode([Coordinate].self, forKey: .poly)
    }
}

