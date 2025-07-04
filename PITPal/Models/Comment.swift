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
    #Unique<Comment>([\.code])
    var code: String
    var name: String
    var active: String
    var selected: Bool
    var sort: Int
    
    init(code: String = "", name: String = "", active: String = "Y", selected: Bool = false, sort: Int = 0) {
        self.code = code
        self.name = name
        self.active = active
        self.selected = false
        self.sort = sort
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case active
        case selected
        case sort
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code =   try container.decode(String.self, forKey: .code)
        name =   try container.decode(String.self, forKey: .name)
        active = try container.decode(String.self, forKey: .active)
        selected = try container.decodeIfPresent(Bool.self, forKey: .selected) ?? false
        sort =   try container.decode(Int.self, forKey: .sort)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(active, forKey: .active)
        try container.encode(selected, forKey: .selected)
        try container.encode(sort, forKey: .sort)
    }
}

extension Comment {
    func deepCopy() -> CommentData {
        let newComment = CommentData(
            code: self.code,
            name: self.name,
            active: self.active,
            selected: self.selected,
            sort: self.sort
        )
        return newComment
    }
}
