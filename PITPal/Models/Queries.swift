//
//  Queries.swift
//  PITPal
//
//  Created by Doug Haacke on 6/27/25.
//


import SwiftUI
import SwiftData

final class Queries {
    
    func fetchNameFromCode(context: ModelContext, model: String, code: String) -> String {
        switch(model) {
            case "SurveySection":
                let descriptor = FetchDescriptor<SurveySection>(
                    predicate: #Predicate { section in
                        section.code == code
                    }
                )
                do {
                    let sections : [SurveySection] = try context.fetch(descriptor)
                    var section: SurveySection? { sections.first }
                    return section?.name ?? "All Sections"
                } catch {
                    print("Error fetching SurveySection name: \(error)")
                    return "N/A" // Handle the error appropriately
                }
            case "Species":
                let descriptor = FetchDescriptor<Species>(
                    predicate: #Predicate { species in
                        species.code == code
                    }
                )
                do {
                    let species : [Species] = try context.fetch(descriptor)
                    var specie: Species? { species.first }
                    return specie?.name ?? "All Species"
                } catch {
                    print("Error fetching Species name: \(error)")
                    return "N/A" // Handle the error appropriately
                }
            case "TripType":
                let descriptor = FetchDescriptor<TripType>(
                    predicate: #Predicate { type in
                        type.code == code
                    }
                )
                do {
                    let types : [TripType] = try context.fetch(descriptor)
                    var type: TripType? { types.first }
                    return type?.name ?? "All Trip Types"
                } catch {
                    print("Error fetching TripType name: \(error)")
                    return "N/A" // Handle the error appropriately
                }
            case "Watershed":
                let descriptor = FetchDescriptor<Watershed>(
                    predicate: #Predicate { watershed in
                        watershed.code == code
                    }
                )
                do {
                    let watersheds : [Watershed] = try context.fetch(descriptor)
                    var watershed: Watershed? { watersheds.first }
                    return watershed?.name ?? "All Watersheds"
                } catch {
                    print("Error fetching Watershed name: \(error)")
                    return "N/A" // Handle the error appropriately
                }
            default:
                return ""
        }
    }
    
    func fetchFWPCodeFromCode(context: ModelContext, code: String) -> String {
        let descriptor = FetchDescriptor<Species>(
            predicate: #Predicate { species in
                species.code == code
            }
        )
        do {
            let speciesList : [Species] = try context.fetch(descriptor)
            var s: Species? { speciesList.first }
            return s?.fwpCode ?? "N/A"
        } catch {
            print("Error fetching FWP Species code: \(error)")
            return "N/A" // Handle the error appropriately
        }
    }
}
