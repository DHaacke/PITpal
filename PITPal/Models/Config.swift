//
//  Config.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import Foundation

struct Config: Codable {
    var gender : [Gender] = []
    var species: [Species] = []
    var surveySection: [SurveySection] = []
    var watershed : [Watershed] = []
    var tripType: [TripType] = []
    
    enum CodingKeys: String, CodingKey {
        case gender
        case species
        case surveySection
        case watershed
        case tripType
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gender = try container.decode([Gender].self, forKey: .gender)
        self.species = try container.decode([Species].self, forKey: .species)
        self.surveySection = try container.decode([SurveySection].self, forKey: .surveySection)
        self.watershed = try container.decode([Watershed].self, forKey: .watershed)
        self.tripType = try container.decode([TripType].self, forKey: .tripType)
    }

    init (gender: [Gender], species: [Species], surveySection: [SurveySection], watershed: [Watershed], tripType: [TripType] ) {
        self.gender = gender
        self.species = species
        self.surveySection = surveySection
        self.watershed = watershed
        self.tripType = tripType
    }

}
