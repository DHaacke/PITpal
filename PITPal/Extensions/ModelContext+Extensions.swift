//
//  ModelContext+Extensions.swift
//  PITPal
//
//  Created by Doug Haacke on 6/25/25.
//

import SwiftData

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}
