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
    var location: Coordinate
    var radius: Double
    
    init(
        code: String = "",
        name: String = "",
        color: String = "",
        location: Coordinate = Coordinate(latitude: 0.0, longitude: 0.0, altitude: 0),
        radius: Double = 0.0,
    ) {
        self.code = code
        self.name = name
        self.color = color
        self.location = location
        self.radius = radius
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case name
        case color
        case location
        case radius
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.color = try container.decode(String.self, forKey: .color)
        self.location = try container.decode(Coordinate.self, forKey: .location)
        self.radius = try container.decode(Double.self, forKey: .radius)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
        try container.encode(location, forKey: .location)
        try container.encode(radius, forKey: .radius)
    }
    
    static func == (lhs: SurveySection, rhs: SurveySection) -> Bool {
        return lhs.persistentModelID == rhs.persistentModelID
    }
    
//    func hash(into hasher: inout Hasher) {
//      hasher.combine(id)
//    }
}
