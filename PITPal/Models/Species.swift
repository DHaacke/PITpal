//
//  Species.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import Foundation

struct Species: Codable {
    var code: String
    var description: String
    var imageName: String
    var color: String
    var sort: Int
    var watershed: [String] = []
    
    enum CodingKeys: String, CodingKey {
        case code
        case description
        case imageName
        case color
        case sort
        case watershed
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.description = try container.decode(String.self, forKey: .description)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.color = try container.decode(String.self, forKey: .color)
        self.sort = try container.decode(Int.self, forKey: .sort)
        self.watershed = try container.decode([String].self, forKey: .watershed)
    }
}

