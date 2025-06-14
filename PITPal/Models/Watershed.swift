//
//  Watershed.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI
import CoreLocation

struct Watershed: Codable {
    var code: String
    var description: String
    var geofence: [Coordinate]
    var poly: [CLLocationCoordinate2D] = []
    var color: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case description
        case geofence
        case color
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.description = try container.decode(String.self, forKey: .description)
        self.geofence = try container.decode([Coordinate].self, forKey: .geofence)
        self.color = try container.decode(String.self, forKey: .color)
    }
}
