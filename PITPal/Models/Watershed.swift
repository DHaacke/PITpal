//
//  Watershed.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI
import SwiftData
import CoreLocation

@Model
class Watershed: Codable, Equatable {
    @Attribute(.unique) var code: String
    var name: String
    var geofence: [Coordinate]
    var poly: [Coordinate]

    init(
        code: String = "",
        name: String = "",
        geofence: [Coordinate] = [],
        poly: [Coordinate] = [],
    ) {
        self.code = code
        self.name = name
        self.geofence = geofence
        self.poly = poly
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case name
        case geofence
        case poly
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.geofence = try container.decode([Coordinate].self, forKey: .geofence)
        self.poly = try container.decode([Coordinate].self, forKey: .poly)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(geofence, forKey: .geofence)
        try container.encode(poly, forKey: .poly)
    }
    
    static func == (lhs: Watershed, rhs: Watershed) -> Bool {
        return lhs.persistentModelID == rhs.persistentModelID
    }
    
//    func hash(into hasher: inout Hasher) {
//      hasher.combine(id)
//    }
}
