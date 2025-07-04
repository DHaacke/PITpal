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
    var trip: Trip?
    var date: Date
    var pitTag: String  // F59534AF76C0
    var lat: Double
    var lon: Double
    var species: String
    var fwpSpecies: String
    var weight: Int
    var length: Int
    var gender: String
    var mort: String = ""
    var mc: Int = 0
    var count: Int = 1
    var comment: String = ""
    
    init(
        date: Date = Date(),
        pitTag: String = "",
        lat: Double = 0.0,
        lon: Double = 0.0,
        species: String = "",
        fwpSpecies: String = "",
        weight: Int = 0,
        length: Int = 0,
        gender: String = "",
        mort: String = "",
        mc: Int = 0,
        count: Int = 1,
        comment: String = "",
    ) {
        self.date = date
        self.pitTag = pitTag
        self.lat = lat
        self.lon = lon
        self.species = species
        self.fwpSpecies = fwpSpecies
        self.weight = weight
        self.length = length
        self.gender = gender
        self.mort = mort
        self.mc = mc
        self.count = count
        self.comment = comment
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case pitTag
        case lat
        case lon
        case species
        case fwpSpecies
        case weight
        case length
        case gender
        case mort
        case mc
        case count
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
        self.species = try container.decode(String.self, forKey: .species)
        self.fwpSpecies = try container.decode(String.self, forKey: .fwpSpecies)
        self.weight = try container.decode(Int.self, forKey: .weight)
        self.length = try container.decode(Int.self, forKey: .length)
        self.gender = try container.decode(String.self, forKey: .gender)
        self.mort = try container.decode(String.self, forKey: .mort)
        self.mc = try container.decode(Int.self, forKey: .mc)
        self.count = try container.decode(Int.self, forKey: .count)
        self.comment = try container.decode(String.self, forKey: .comment)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(pitTag, forKey: .pitTag)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
        try container.encode(species, forKey: .species)
        try container.encode(fwpSpecies, forKey: .fwpSpecies)
        try container.encode(weight, forKey: .weight)
        try container.encode(length, forKey: .length)
        try container.encode(gender, forKey: .gender)
        try container.encode(mort, forKey: .mort)
        try container.encode(mc, forKey: .mc)
        try container.encode(count, forKey: .count)
        try container.encode(comment, forKey: .comment)
    }
    
    func getFishCount(modelContext: ModelContext, speciesCode: String) -> Int {
        let descriptor = FetchDescriptor<Fish>(predicate: #Predicate { $0.species == speciesCode })
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }
    
    func toJSON() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = TimeZone.current
        let json = """
        {
            "date" : "\(formatter.string(from: self.date))",
            "pitTag: "\(self.pitTag))",
            "lat": \(self.lat)),
            "lon": \(self.lon)),
            "species": "\(self.species)")",
            "fwpSpecies": "\(self.fwpSpecies)")",
            "weight": \(self.weight)),
            "length": \(self.length)),
            "gender": "\(self.gender))",
            "mort": "\(self.mort)")",
            "mc": \(self.mc)),
            "count": \(self.count)),
            "comment": "\(self.comment)")"
        },
        """
        return json
    }
    
    func toCSVHeader() -> String {
        return "date,pitTag,lat,lon,species,fwpSpecies,weight,length,gender,mort,mc,count,comment"
    }
    
    func toCSV() -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        
        var buffer = ""
        
        buffer += "\(formatter.string(from: self.date)),"
        buffer += "\(self.pitTag),"
        buffer += "\(self.lat),"
        buffer += "\(self.lon),"
        buffer += "\(self.species),"
        buffer += "\(self.fwpSpecies),"
        buffer += "\(self.weight),"
        buffer += "\(self.length),"
        buffer += "\(self.gender),"
        buffer += "\(self.mort),"
        buffer += "\(self.mc),"
        buffer += "\(self.count),"
        buffer += "\"\(self.comment)\""
                
        return buffer
    
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
