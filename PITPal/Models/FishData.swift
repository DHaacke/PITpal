//
//  FishData.swift
//  PITPal
//
//  Created by Doug Haacke on 6/30/25.
//

import SwiftUI

final class FishData: Equatable, Identifiable {
    var id: UUID = UUID()
    var trip: TripData?
    var date: Date
    var pitTag: String
    var lat: Double
    var lon: Double
    var species: String
    var fwpSpecies: String
    var weight: Int
    var length: Int
    var gender: String
    var mort: String = "N"
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
        mort: String = "N",
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
    
    static func ==(lhs: FishData, rhs: FishData) -> Bool {
        return lhs.id == rhs.id
    }
}


