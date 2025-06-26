//
//  TripType.swift
//  PITPal
//
//  Created by Doug Haacke on 6/24/25.
//

import SwiftUI
import SwiftData

@Model
final class TripType: Codable, Equatable {
    @Attribute(.unique) var code: String
    var name: String
    var active: String
    
    init(
        code: String = "",
        name: String = "",
        active: String = "Y"
    ) {
        self.code = code
        self.name = name
        self.active = active
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case active
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.active = try container.decode(String.self, forKey: .active)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(active, forKey: .active)
    }
    
    static func == (lhs: TripType, rhs: TripType) -> Bool {
        return lhs.persistentModelID == rhs.persistentModelID
    }
    
//    func hash(into hasher: inout Hasher) {
//      hasher.combine(id)
//    }
}
