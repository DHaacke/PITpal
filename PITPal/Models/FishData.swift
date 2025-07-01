//
//  FishData.swift
//  PITPal
//
//  Created by Doug Haacke on 6/30/25.
//

import SwiftUI

final class FishData {
    var trip: TripData?
    var date: Date
    var pitTag: String
    var lat: Double
    var lon: Double
    var species: String
    var fwpSpecies: String
    var weight: Double
    var length: Double
    var gender: String
    var doa: String = "N"
    var hookScar: String = "N"
    var comment: String = ""
    
    init(
        date: Date = Date(),
        pitTag: String = "",
        lat: Double = 0.0,
        lon: Double = 0.0,
        species: String = "",
        fwpSpecies: String = "",
        weight: Double = 0.0,
        length: Double = 0.0,
        gender: String = "",
        doa: String = "N",
        hookScar: String = "N",
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
        self.doa = doa
        self.hookScar = hookScar
        self.comment = comment
    }
}


