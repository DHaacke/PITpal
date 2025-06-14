//
//  NetworkManager.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import Foundation
import Network

@Observable
class NetworkManager {
    @ObservationIgnored let monitor = NWPathMonitor()
    @ObservationIgnored let queue = DispatchQueue(label: "NetworkMonitor")
    
    var isNetworkAvailable: Bool = false
    
    func checkNetworkConnection() {
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.isNetworkAvailable = true
            } else {
                self.isNetworkAvailable = false
            }
        }
        monitor.start(queue: queue)
    }
}
