//
//  Comment.swift
//  PITPal
//
//  Created by Doug Haacke on 7/2/25.
//

import SwiftUI
import SwiftData

@Model
final class Comment: Codable, Equatable {
    @Attribute(.unique) var code: String
    var name: String
    var active: String
    var sort: Int
    
    init(code: String = "", name: String = "", active: String = "Y", sort: Int = 0) {
        self.code = code
        self.name = name
        self.active = active
        self.sort = sort
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case active
        case sort
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code =   try container.decode(String.self, forKey: .code)
        name =   try container.decode(String.self, forKey: .name)
        active = try container.decode(String.self, forKey: .active)
        sort =   try container.decode(Int.self, forKey: .sort)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(active, forKey: .active)
        try container.encode(sort, forKey: .sort)
    }
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        lhs.code == rhs.code
    }
}
