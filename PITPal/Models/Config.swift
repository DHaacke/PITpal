//
//  Config.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import Foundation

struct Config: Codable {
    var gender : [Gender] = []
    var season : [Season] = []
    var species: [Species] = []
    var surveySection: [SurveySection] = []
    var watershed : [Watershed] = []
    
    enum CodingKeys: String, CodingKey {
        case gender
        case season
        case species
        case surveySection
        case watershed
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.gender = try container.decode([Gender].self, forKey: .gender)
        self.season = try container.decode([Season].self, forKey: .season)
        self.species = try container.decode([Species].self, forKey: .species)
        self.surveySection = try container.decode([SurveySection].self, forKey: .surveySection)
        self.watershed = try container.decode([Watershed].self, forKey: .watershed)
    }

    init (gender: [Gender], season: [Season], species: [Species], surveySection: [SurveySection], watershed: [Watershed] ) {
        self.gender = gender
        self.season = season
        self.species = species
        self.surveySection = surveySection
        self.watershed = watershed
    }

}
