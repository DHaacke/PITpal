//
//  Trip.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//


import Foundation
import SwiftUI
import CoreLocation

struct Trip: Codable, Identifiable {
    public var id: Int64 = 0
    var date: String = Date().format(format: "yyyy-MM-dd")
    var watershed: String = "BHR"
    var season: Season
    var surveySection: SurveySection
    var initialLat: Double = 0.0
    var initialLon: Double = 0.0
    var waterTemperature: Double = 0.0
    var waterFlow: Double = 0.0
    var fish: [Fish] = []
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case watershed
        case season
        case surveySection
        case initialLat
        case initialLon
        case waterTemperature
        case waterFlow
        case fish
    }
    
    init(
        id: Int64,
        date: String,
        watershed: String,
        season: Season,
        surveySection: SurveySection,
        initialLat: Double,
        initialLon: Double,
        waterTemperature: Double,
        waterFlow: Double,
        fish: [Fish]
    ) {
        self.id = id
        self.date = date
        self.watershed = watershed
        self.season = season
        self.surveySection = surveySection
        self.initialLat = initialLat
        self.initialLon = initialLon
        self.waterTemperature = waterTemperature
        self.waterFlow = waterFlow
        self.fish = fish
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.date = try container.decode(String.self, forKey: .date)
        self.watershed = try container.decode(String.self, forKey: .watershed)
        self.season = try container.decode(Season.self, forKey: .season)
        self.surveySection = try container.decode(SurveySection.self, forKey: .surveySection)
        self.initialLat = try container.decode(Double.self, forKey: .initialLat)
        self.initialLon = try container.decode(Double.self, forKey: .initialLon)
        self.waterTemperature = try container.decode(Double.self, forKey: .waterTemperature)
        self.waterFlow = try container.decode(Double.self, forKey: .waterFlow)
        self.fish = try container.decode([Fish].self, forKey: .fish)
    }
}
