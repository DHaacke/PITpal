//
//  Defaults.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import Foundation

struct Settings: Codable {
    var name: String
    var organization: String
    var mapStyle: String      // Satellite, Hybrid
    var darkMode: Bool
    
    enum CodingKeys: String, CodingKey {
        case name
        case organization
        case mapStyle
        case darkMode
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.organization = try container.decode(String.self, forKey: .organization)
        self.mapStyle = try container.decode(String.self, forKey: .mapStyle)
        self.darkMode = try container.decode(Bool.self, forKey: .darkMode)
    }

}
