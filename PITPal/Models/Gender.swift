//
//  Gender.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import Foundation

struct Gender: Codable {
    var code: String
    var description: String
    var color: String
    var sort: Int
    
    enum CodingKeys: String, CodingKey {
        case code
        case description
        case color
        case sort
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.description = try container.decode(String.self, forKey: .description)
        self.color = try container.decode(String.self, forKey: .color)
        self.sort = try container.decode(Int.self, forKey: .sort)
    }
}
