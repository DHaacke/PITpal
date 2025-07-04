//
//  CommentData.swift
//  PITPal
//
//  Created by Doug Haacke on 7/3/25.
//

import Swift
import SwiftData

@Observable
final class CommentData {
    var code: String
    var name: String
    var active: String
    var selected: Bool
    var sort: Int

    init(code: String, name: String, active: String, selected: Bool, sort: Int) {
        self.code = code
        self.name = name
        self.active = active
        self.selected = selected
        self.sort = sort
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case active
        case selected
        case sort
    }
}
