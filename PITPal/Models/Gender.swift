//
//  Gender.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import Foundation

struct Gender: Codable, Identifiable, Hashable {
    var id: Int
    var code: String
    var description: String
    var color: String

    enum CodingKeys: String, CodingKey {
        case id
        case code
        case description
        case color
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.code = try container.decode(String.self, forKey: .code)
        self.description = try container.decode(String.self, forKey: .description)
        self.color = try container.decode(String.self, forKey: .color)
    }
}
