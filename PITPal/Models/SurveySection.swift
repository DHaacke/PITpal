//
//  Season.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import SwiftUI
import SwiftData

// upper 45.362514,-107.830852
// lower 45.34681,-107.87468


@Model
final class SurveySection: Codable, Equatable, Identifiable {
    @Attribute(.unique) var code: String
    var name: String
    var color: String
    var latDown: Double
    var lonDown: Double
    var latUp: Double
    var lonUp: Double
    var radius: Double
    var startDate: Date
    var endDate: Date
    var active: String
    var id: String {
        code
    }
    
    init(
        code: String = "",
        name: String = "",
        color: String = "",
        latDown: Double = 45.39395,
        lonDown: Double = -107.80418,
        latUp: Double = 45.34681,
        lonUp: Double = -107.87468,
        radius: Double = 0.0,
        startDate: Date = Date(),
        endDate: Date = Date(),
        active: String = "Y"
    ) {
        self.code = code
        self.name = name
        self.color = color
        self.latDown = latDown
        self.lonDown = lonDown
        self.latUp = latUp
        self.lonUp = lonUp
        self.radius = radius
        self.startDate = startDate
        self.endDate = endDate
        self.active = active
    }
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case color
        case latDown
        case lonDown
        case latUp
        case lonUp
        case radius
        case startDate
        case endDate
        case active
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"  // was "yyyy-MM-dd HH:mm"
        let startDateString = try container.decode(String.self, forKey: .startDate)
        let endDateString = try container.decode(String.self, forKey: .endDate)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.color = try container.decode(String.self, forKey: .color)
        self.latDown = try container.decode(Double.self, forKey: .latDown)
        self.lonDown = try container.decode(Double.self, forKey: .lonDown)
        self.latUp = try container.decode(Double.self, forKey: .latUp)
        self.lonUp = try container.decode(Double.self, forKey: .lonUp)
        self.radius = try container.decode(Double.self, forKey: .radius)
        self.startDate = dateFormatter.date(from: startDateString)!
        self.endDate = dateFormatter.date(from: endDateString)!
        self.active = try container.decode(String.self, forKey: .active)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(color, forKey: .color)
        try container.encode(latDown, forKey: .latDown)
        try container.encode(lonDown, forKey: .lonDown)
        try container.encode(latUp, forKey: .latUp)
        try container.encode(lonUp, forKey: .lonUp)
        try container.encode(radius, forKey: .radius)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(active, forKey: .active)
    }
    
    static func == (lhs: SurveySection, rhs: SurveySection) -> Bool {
        return lhs.persistentModelID == rhs.persistentModelID
    }
    
    func fetchNameFromCode(context: ModelContext, code: String) -> String {
        let descriptor = FetchDescriptor<SurveySection>(
            predicate: #Predicate { section in
                section.code == code
            }
        )
        do {
            let sections : [SurveySection] = try context.fetch(descriptor)
            var section: SurveySection? { sections.first }
            return section?.name ?? "N/A"
        } catch {
            print("Error fetching SurveySection name: \(error)")
            return "N/A" // Handle the error appropriately
        }
    }
}
