//
//  NetworkManager.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import Foundation
import Network

@Observable
class NetworkMonitor: ObservableObject {
    @ObservationIgnored private let monitor = NWPathMonitor()
    @ObservationIgnored private let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected = false
    var isExpensive = false
    var isConstrained = false

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.isExpensive = path.isExpensive
                self?.isConstrained = path.isConstrained
            }
        }
        monitor.start(queue: queue)
    }

    deinit {
        monitor.cancel()
    }
}
