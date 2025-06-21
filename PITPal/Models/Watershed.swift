//
//  Watershed.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI
import CoreLocation

struct Watershed: Codable, Identifiable, Hashable, Equatable {
    @Environment(JSONManager.self) var jsonManager
    
    var id: Int
    var code: String
    var description: String
    var geofence: [Coordinate]
    var poly: [CLLocationCoordinate2D] = []
    var color: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case code
        case description
        case geofence
        case color
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.code = try container.decode(String.self, forKey: .code)
        self.description = try container.decode(String.self, forKey: .description)
        self.geofence = try container.decode([Coordinate].self, forKey: .geofence)
        self.color = try container.decode(String.self, forKey: .color)
    }
    
    static func == (lhs: Watershed, rhs: Watershed) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
      hasher.combine(id)
    }
}
