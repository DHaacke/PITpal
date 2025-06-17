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

import Foundation

struct SurveySection: Codable, Identifiable, Hashable, Equatable {
    
    var id: Int
    var description: String
    var color: String
    var location: Coordinate
    var radius: Double
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case color
        case location
        case radius
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.description = try container.decode(String.self, forKey: .description)
        self.color = try container.decode(String.self, forKey: .color)
        self.location = try container.decode(Coordinate.self, forKey: .location)
        self.radius = try container.decode(Double.self, forKey: .radius)
    }
    
    static func == (lhs: SurveySection, rhs: SurveySection) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}
