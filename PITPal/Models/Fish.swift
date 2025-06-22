//
//  Fish.swift
//  PITPal
//
//  Created by Doug Haacke on 6/21/25.
//

import SwiftData
import SwiftUI

@Model
class Fish: Codable, Equatable {
    var date: Date
    var pitTag: String
    var lat: Double
    var lon: Double
    var surveySection: SurveySection
    var species: String
    var weight: Double
    var length: Double
    var gender: String
    
    init(
        date: Date = Date(),
        pitTag: String = "",
        lat: Double = 0.0,
        lon: Double = 0.0,
        surveySection: SurveySection,
        species: String = "",
        weight: Double = 0.0,
        length: Double = 0.0,
        gender: String = ""
    ) {
        self.date = date
        self.pitTag = pitTag
        self.lat = lat
        self.lon = lon
        self.surveySection = surveySection
        self.species = species
        self.weight = weight
        self.length = length
        self.gender = gender
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case pitTag
        case lat
        case lon
        case surveySection
        case species
        case weight
        case length
        case gender
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.date = try container.decode(Date.self, forKey: .date)
        self.pitTag = try container.decode(String.self, forKey: .pitTag)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.surveySection = try container.decode(SurveySection.self, forKey: .surveySection)
        self.species = try container.decode(String.self, forKey: .species)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.length = try container.decode(Double.self, forKey: .length)
        self.gender = try container.decode(String.self, forKey: .gender)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(pitTag, forKey: .pitTag)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(surveySection, forKey: .surveySection)
        try container.encode(species, forKey: .species)
        try container.encode(weight, forKey: .weight)
        try container.encode(length, forKey: .length)
    }
    
}
