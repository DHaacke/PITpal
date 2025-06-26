//
//  Fish.swift
//  PITPal
//
//  Created by Doug Haacke on 6/21/25.
//

import SwiftData
import SwiftUI

@Model
final class Fish: Codable {
    var date: Date
    var pitTag: String
    var lat: Double
    var lon: Double
    var surveySection: String
    var species: String
    var fwpSpecies: String
    var weight: Double
    var length: Double
    var gender: String
    var doa: Bool = false
    var hookScar: Bool = false
    var comment: String = ""
    
    init(
        date: Date = Date(),
        pitTag: String = "",
        lat: Double = 0.0,
        lon: Double = 0.0,
        surveySection: String = "",
        species: String = "",
        fwpSpecies: String = "",
        weight: Double = 0.0,
        length: Double = 0.0,
        gender: String = "",
        doa: Bool = false,
        hookScar: Bool = false,
        comment: String = "",
    ) {
        self.date = date
        self.pitTag = pitTag
        self.lat = lat
        self.lon = lon
        self.surveySection = surveySection
        self.species = species
        self.fwpSpecies = fwpSpecies
        self.weight = weight
        self.length = length
        self.gender = gender
        self.doa = doa
        self.hookScar = hookScar
        self.comment = comment
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case pitTag
        case lat
        case lon
        case surveySection
        case species
        case fwpSpecies
        case weight
        case length
        case gender
        case doa
        case hookScar
        case comment
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dateString = try container.decode(String.self, forKey: .date)
        self.date = dateFormatter.date(from: dateString)!
        self.pitTag = try container.decode(String.self, forKey: .pitTag)
        self.lat = try container.decode(Double.self, forKey: .lat)
        self.lon = try container.decode(Double.self, forKey: .lon)
        self.surveySection = try container.decode(String.self, forKey: .surveySection)
        self.species = try container.decode(String.self, forKey: .species)
        self.fwpSpecies = try container.decode(String.self, forKey: .fwpSpecies)
        self.weight = try container.decode(Double.self, forKey: .weight)
        self.length = try container.decode(Double.self, forKey: .length)
        self.gender = try container.decode(String.self, forKey: .gender)
        let doaInt = try container.decode(Int.self, forKey: .doa)
        self.doa = doaInt == 1 ? true : false
        let hookScarInt = try container.decode(Int.self, forKey: .hookScar)
        self.hookScar = hookScarInt == 1 ? true : false
        self.comment = try container.decode(String.self, forKey: .comment)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(pitTag, forKey: .pitTag)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(surveySection, forKey: .surveySection)
        try container.encode(species, forKey: .species)
        try container.encode(fwpSpecies, forKey: .fwpSpecies)
        try container.encode(weight, forKey: .weight)
        try container.encode(length, forKey: .length)
        try container.encode(gender, forKey: .gender)
        try container.encode(doa, forKey: .doa)
        try container.encode(hookScar, forKey: .hookScar)
        try container.encode(comment, forKey: .comment)
    }
    
}


/*
 
 let dateFormatter = DateFormatter()
 dateFormatter.dateFormat = "yyyy-MM-dd" // Set your custom format
 decoder.dateDecodingStrategy = .formatted(dateFormatter)
 
 do {
     let decodedData = try decoder.decode(MyData.self, from: jsonData)
     print(decodedData.eventDate) // Access the decoded Date object
 } catch {
     print("Error decoding JSON: \(error)")
 }
 
*/
