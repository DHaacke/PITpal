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
    
    func fetchFishWithLengthAndWeight(context: ModelContext) -> [FishData] {
        let descriptor = FetchDescriptor<Fish>(
            predicate: #Predicate { fish in
                fish.length > 0 && fish.weight > 0
            }
        )
        do {
            let list : [Fish] = try context.fetch(descriptor)
            var fishList : [FishData] = []
            for f in list {
                fishList.append(f.deepCopy())
            }
            return fishList
        } catch {
            print("Error fetching Fish with length and weight: \(error)")
            return []
        }
    }
    
    func fetchFishWithLengthAndWeight(context: ModelContext, tripType: String = "", watershed: String = "", surveySection: String = "") -> [FishData] {
        let descriptor = FetchDescriptor<Trip>(
            predicate: #Predicate<Trip> { trip in
                (tripType == "" || trip.tripType == tripType) && (surveySection == "" || trip.surveySection == surveySection)  //  (watershed == "" || trip.watershed == watershed)
            }
        )
        do {
            let trips : [Trip] = try context.fetch(descriptor)
            var fishList : [FishData] = []
            
            for trip in trips {
                for fish in trip.fish {
                    if fish.length > 0 && fish.weight > 0 {
                        fishList.append(fish.deepCopy())
                    }
                }
            }
            return fishList
        } catch {
            print("Error fetching Fish with length, weight and other parameters: \(error)")
            return []
        }
    }
    
   
    func fetchTripsByDateRange(context: ModelContext, startDate: Date, endDate: Date) -> [TripData] {
        let descriptor = FetchDescriptor<Trip>(
            predicate: #Predicate<Trip> { trip in
                trip.date >= startDate && trip.date <= endDate
            },
            sortBy: [SortDescriptor(\.date)]
        )
        do {
            let trips : [Trip] = try context.fetch(descriptor)
            var tripDataList : [TripData] = []
            for trip in trips {
                tripDataList.append(trip.deepCopy())
            }
            return tripDataList
        } catch {
            print("Error fetching Trips by date range: \(error)")
            return []
        }
    }
    
    func fetchFishByDateRange(context: ModelContext, startDate: Date, endDate: Date) -> [FishData] {
        let descriptor = FetchDescriptor<Trip>(
            predicate: #Predicate<Trip> { trip in
                trip.date >= startDate && trip.date <= endDate
            },
            sortBy: [SortDescriptor(\.date)]
        )
        do {
            let trips : [Trip] = try context.fetch(descriptor)
            var fishList : [FishData] = []
            
            for trip in trips {
                for fish in trip.fish {
                    fishList.append(fish.deepCopy())
                }
            }
            return fishList
        } catch {
            print("Error fetching Fish by date range: \(error)")
            return []
        }
    }
    
    func fetchSurveySectionFromCode(context: ModelContext, code: String) -> SurveySection {
        let descriptor = FetchDescriptor<SurveySection>(
            predicate: #Predicate { section in
                section.code == code
            }
        )
        do {
            let sections : [SurveySection] = try context.fetch(descriptor)
            var section: SurveySection? { sections.first }
            if let section = section {
                return section
            } else {
                return SurveySection(code: "", name: "", color: "", latDown: 0.0, lonDown: 0.0, latUp: 0.0, lonUp: 0.0, radius: 0.0, active: "N")
            }
        } catch {
            print("Error fetching SurveySection name: \(error)")
            return SurveySection(code: "", name: "", color: "", latDown: 0.0, lonDown: 0.0, latUp: 0.0, lonUp: 0.0, radius: 0.0, active: "N")
        }
        
    }

        
}
