//
//  FetchManager.swift
//  PITPal
//
//  Created by Doug Haacke on 6/15/25.
//

import Foundation

@Observable
class FetchManager {
    
    private var cacheBighornStatsPath: URL {
        URL.cachesDirectory.appending(path: "bighornStats")
    }
    
    // The cached data
    var cachedBighornStats: Data? {
        guard let bighornStats = try? Data(contentsOf: cacheBighornStatsPath) else {
            return  nil
        }
        return bighornStats
    }
    
    // Is cached image currently available
    var cachedBighornStatsAvailable: Bool {
       cachedBighornStats != nil
    }

    // Write the cached data
    private func cacheBighornStats(_ bighornStats: Data) async throws {
        try bighornStats.write(to: cacheBighornStatsPath)
    }
    
    /// Call the Dog API and then download and cache the dog image
    func fetchBighornStats() async throws -> [BighornStats] {
        
        print("Fetching BighornStats...")
        
        let url = URL(string: "https://data.bighornriver.org/bighornstats")!

        // Fetch JSON data
        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON data
        let decodedData = try JSONDecoder().decode([BighornStats].self, from: data)
        let bighornStats = decodedData
        
        Task {
            try? await cacheBighornStats(data)
        }
        
        return bighornStats
    }

}
