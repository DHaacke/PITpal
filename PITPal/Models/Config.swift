//
//  Config.swift
//  PITPal
//
//  Created by Doug Haacke on 6/14/25.
//

import Foundation

struct Config: Codable {
    var trip: [Trip] = []
    var species: [Species] = []
    var gender : [Gender] = []
    var surveySection: [SurveySection] = []
    var watershed : [Watershed] = []
    var tripType: [TripType] = []
    
    
    enum CodingKeys: String, CodingKey {
        case trip
        case species
        case gender
        case surveySection
        case watershed
        case tripType
        
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.trip = try container.decode([Trip].self, forKey: .trip)
        self.species = try container.decode([Species].self, forKey: .species)
        self.gender = try container.decode([Gender].self, forKey: .gender)
        self.surveySection = try container.decode([SurveySection].self, forKey: .surveySection)
        self.watershed = try container.decode([Watershed].self, forKey: .watershed)
        self.tripType = try container.decode([TripType].self, forKey: .tripType)
        
    }

    init (trip: [Trip], species: [Species], gender: [Gender], surveySection: [SurveySection], watershed: [Watershed], tripType: [TripType], ) {
        self.trip = trip
        self.species = species
        self.gender = gender
        self.surveySection = surveySection
        self.watershed = watershed
        self.tripType = tripType
        
    }

}
