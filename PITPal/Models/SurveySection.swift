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

struct SurveySection: Codable {
    var id: Int64
    var description: String
    var color: String
    var sort: Int
    var poly: Poly
    
    enum CodingKeys: String, CodingKey {
        case id
        case description
        case color
        case sort
        case poly
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.description = try container.decode(String.self, forKey: .description)
        self.color = try container.decode(String.self, forKey: .color)
        self.sort = try container.decode(Int.self, forKey: .sort)
        self.poly = try container.decode(Poly.self, forKey: .poly)
    }
}
