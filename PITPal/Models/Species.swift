//
//  Species.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import SwiftUI
import SwiftData

@Model
final class Species: Codable, Equatable, Hashable, Identifiable {
    @Attribute(.unique) var code: String
    var fwpCode: String = ""
    var name: String
    var imageName: String
    var color: String
    var active: String
    var id: String {
        code
    }
    
    init(
        code: String = "",
        fwpCode: String = "",
        name: String = "",
        imageName: String = "",
        color: String = "",
        active: String = "Y"
    ) {
        self.code = code
        self.fwpCode = fwpCode
        self.name = name
        self.imageName = imageName
        self.color = color
        self.active = active
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case fwpCode
        case name
        case imageName
        case color
        case active
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.fwpCode = try container.decode(String.self, forKey: .fwpCode)
        self.name = try container.decode(String.self, forKey: .name)
        self.imageName = try container.decode(String.self, forKey: .imageName)
        self.color = try container.decode(String.self, forKey: .color)
        self.active = try container.decode(String.self, forKey: .active)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(fwpCode, forKey: .fwpCode)
        try container.encode(name, forKey: .name)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(color, forKey: .color)
        try container.encode(active, forKey: .active)
    }
    
    static func == (lhs: Species, rhs: Species) -> Bool {
        return lhs.persistentModelID == rhs.persistentModelID
    }
    
}

