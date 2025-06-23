//
//  Section.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

//
//  Season.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import SwiftUI
import SwiftData

@Model
class SurveySection: Codable, Equatable {
    @Attribute(.unique) var code: String
    var name: String
    var color: String
    var lat: Double
    var lon: Double
    var radius: Double
    var active: String
    
    init(
        code: String = "",
        name: String = "",
        color: String = "",
        lat: Double = 0.0,
        lon: Double = 0.0,
        radius: Double = 0.0,
        active: String = "Y"
    ) {
        self.code = code
        self.name = name
        self.color = color
        self.lat = lat
        self.lon = lon
        self.radius = radius
        self.active = active
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case color
        case lat
        case lon
        case radius
        case active
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.color = try container.decode(String.self, forKey: .color)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.radius = try container.decode(Double.self, forKey: .radius)
        self.active = try container.decode(String.self, forKey: .active)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(radius, forKey: .radius)
        try container.encode(active, forKey: .active)
    }
    
    static func == (lhs: SurveySection, rhs: SurveySection) -> Bool {
        return lhs.persistentModelID == rhs.persistentModelID
    }
    
//    func hash(into hasher: inout Hasher) {
//      hasher.combine(id)
//    }
}
