//
//  Gender.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI
import SwiftData

@Model
final class Gender: Codable {
    @Attribute(.unique) var code: String
    var name: String
    var color: String
    
    init(
        code: String = "",
        name: String = "",
        color: String = ""
    ) {
        self.code = code
        self.name = name
        self.color = color
    }

    enum CodingKeys: String, CodingKey {
        case code
        case name
        case color
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.color = try container.decode(String.self, forKey: .color)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
    }
    
}
