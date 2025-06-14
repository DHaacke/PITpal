//
//  Lookups.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import Foundation

struct Lookups: Codable {
    var code: String
    var description: String
    var sort: Int
    
    enum CodingKeys: String, CodingKey {
        case code
        case description
        case sort
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.description = try container.decode(String.self, forKey: .description)
        self.sort = try container.decode(Int.self, forKey: .sort)
    }
}
