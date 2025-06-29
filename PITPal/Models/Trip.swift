//
//  Trip.swift
//  PITPal
//
//  Created by Doug Haacke on 6/20/25.
//

import SwiftData
import SwiftUI

@Model
final class Trip: Codable {
    var date: Date
    var tripType: String  // M or R
    var surveySection: String
    var watershed: String
    var equipment: String
    var latDown: Double
    var lonDown: Double
    var latUp: Double
    var lonUp: Double
    var sectionLength: Double  // meters
    var startTime: String      // 08:35
    var endTime: String        // 17:10
    var waterTemperature: Double
    var waterFlow: Double
    @Relationship(deleteRule: .cascade, inverse: \Fish.trip) var fish: [Fish]
    // var fish: [Fish]
    // #Unique<Trip>([\.date], [\.tripType], [\.surveySection], [\.watershed])
    
    init(
        date: Date = Date(),
        tripType: String = "M",
        surveySection: String = "",
        watershed: String = "",
        equipment: String = "",
        latDown: Double = 0.0,
        lonDown: Double = 0.0,
        latUp: Double = 0.0,
        lonUp: Double = 0.0,
        sectionLength: Double = 0.0,
        startTime: String = "",
        endTime: String = "",
        waterTemperature: Double = 0,
        waterFlow: Double = 0,
        fish: [Fish] = []
    ) {
        self.date = date
        self.tripType = tripType
        self.surveySection = surveySection
        self.watershed = watershed
        self.equipment = equipment
        self.latDown = latDown
        self.lonDown = lonDown
        self.latUp = latUp
        self.lonUp = lonUp
        self.sectionLength = sectionLength
        self.startTime = startTime
        self.endTime = endTime
        self.waterTemperature = waterTemperature
        self.waterFlow = waterFlow
        self.fish = fish
    }
    
    enum CodingKeys: String, CodingKey {
        case date
        case tripType
        case surveySection
        case watershed
        case equipment
        case latDown
        case lonDown
        case latUp
        case lonUp
        case sectionLength
        case startTime
        case endTime
        case waterTemperature
        case waterFlow
        case fish
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = try container.decode(String.self, forKey: .date)
        self.date = dateFormatter.date(from: dateString)!
        self.tripType = try container.decode(String.self, forKey: .tripType)
        self.surveySection = try container.decode(String.self, forKey: .surveySection)
        self.watershed = try container.decode(String.self, forKey: .watershed)
        self.equipment = try container.decode(String.self, forKey: .equipment)
        self.latDown = try container.decode(Double.self, forKey: .latDown)
        self.lonDown = try container.decode(Double.self, forKey: .lonDown)
        self.latUp = try container.decode(Double.self, forKey: .latUp)
        self.lonUp = try container.decode(Double.self, forKey: .lonUp)
        self.sectionLength = try container.decode(Double.self, forKey: .sectionLength)
        self.startTime = try container.decode(String.self, forKey: .startTime)
        self.endTime = try container.decode(String.self, forKey: .endTime)
        self.waterTemperature = try container.decode(Double.self, forKey: .waterTemperature)
        self.waterFlow = try container.decode(Double.self, forKey: .waterFlow)
        self.fish = try container.decodeIfPresent([Fish].self, forKey: .fish) ?? []
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(tripType, forKey: .tripType)
        try container.encode(surveySection, forKey: .surveySection)
        try container.encode(watershed, forKey: .watershed)
        try container.encode(equipment, forKey: .equipment)
        try container.encode(latDown, forKey: .latDown)
        try container.encode(lonDown, forKey: .lonDown)
        try container.encode(latUp, forKey: .latUp)
        try container.encode(lonUp, forKey: .lonUp)
        try container.encode(sectionLength, forKey: .sectionLength)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(waterTemperature, forKey: .waterTemperature)
        try container.encode(waterFlow, forKey: .waterFlow)
        try container.encode(fish, forKey: .fish)
    }
    
    func toJSON() -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm"
            formatter.timeZone = TimeZone.current
            encoder.dateEncodingStrategy = .formatted(formatter)
            let jsonData = try! encoder.encode(self)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            } else {
                return "{}"
            }
        }
    }
    
    func getCSVHeader() -> String {
        return "date,type,section,watershed,equipment,lat_down,lon_down,lat_up,long_up,length,start,end,temp,cfs,date,pitTag,lat,lon,species,fwpSpecies,weight,length,gender,doa,hookScar,comment"
    }
    
    func toCSV() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone.current
        
        var buffer = ""
        
        buffer += "\(formatter.string(from: self.date)),"
        buffer += "\(self.tripType),"
        buffer += "\(self.watershed),"
        buffer += "\(self.surveySection),"
        buffer += "\(self.equipment),"
        buffer += "\(self.latDown),"
        buffer += "\(self.lonDown),"
        buffer += "\(self.latUp),"
        buffer += "\(self.lonUp),"
        buffer += "\(self.sectionLength),"
        buffer += "\(self.startTime),"
        buffer += "\(self.endTime),"
        buffer += "\(self.waterTemperature),"
        buffer += "\(self.waterFlow),"

        return buffer
    }

    
    
//    func toJSON(trip: Trip) -> String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd HH:mm"
//        formatter.timeZone = TimeZone.current
//        let json = """
//        {
//            "date" : "\(formatter.string(from: trip.date))",
//            "tripType": "\(trip.tripType)",
//            "watershed": "\(trip.watershed)",
//            "equipment": "\(trip.equipment)",
//            "latDown": \(trip.latDown),
//            "lonDown": \(trip.lonDown),
//            "latUp": \(trip.latUp),
//            "lonUp": \(trip.lonUp),
//            "sectionLength": \(trip.sectionLength),
//            "startTime": "\(trip.startTime)",
//            "endTime": "\(trip.endTime)",
//            "waterTemperature": \(waterTemperature),
//            "waterFlow": \(waterFlow),
//            "fish": \(trip.fish.map {
//                """
//                {
//                    "date" : "\(formatter.string(from: $0.date))",
//                    "pitTag: "\($0.pitTag))",
//                    "lat": \($0.lat)),
//                    "lon": \($0.lon)),
//                    "species": "\($0.species)")",
//                    "fwpSpecies": "\($0.fwpSpecies)")",
//                    "weight": \($0.weight)),
//                    "length": \($0.length)),
//                    "gender": "\($0.gender))",
//                    "doa": "\($0.doa)")",
//                    "hookScar": "\($0.hookScar)")",
//                    "comment": "\($0.comment)")"
//                },
//               """
//            })
//        }
//        """
//        return json
//    }
    
    func getRecordCount(modelContext: ModelContext) -> Int {
        let descriptor = FetchDescriptor<Trip>(predicate: #Predicate { $0.tripType != "" })
        return (try? modelContext.fetchCount(descriptor)) ?? 0
    }

}



