//
//  LocationsManager.swift
//  PITPal
//
//  Created by Doug Haacke on 6/11/25.
//

import os
import SwiftUI
import CoreLocation

let globalAuthDeniedError = "Please enable Location Services by going to Settings -> Privacy & Security"
let authDeniedError = "Please authorize AnglerVox to access Location Services"
let authRestrictedError = "AnglerVox can't access your location. Do you have Parental Controls enabled?"
let accuracyLimitedError = "AnglerVox can't access your precise location. Displaying your approximate location instead."

@MainActor

@Observable
class LocationsHandler {
    let logger = Logger(subsystem: "doughaacke.app.PITPal", category: "LocationsHandler")
    
    static let shared = LocationsHandler()  // Create a single, shared instance of the object.

    //private let manager: CLLocationManager
    @ObservationIgnored private var backgroundActivitySession: CLBackgroundActivitySession?

    // var locationManager = CLLocationManager()
    
    var isReceivingUpdates: Bool = false
    var lastLocation = CLLocation()
    var lastLocation2D = CLLocationCoordinate2D()
    var isAuthorized: Bool = false
    var lastUpdate: CLLocationUpdate? = nil
    var isStationary = false
    var hasShownAlert = false
    var count = 0

    var updatesStarted: Bool = UserDefaults.standard.bool(forKey: "liveUpdatesStarted") {
        didSet {
            updatesStarted ? self.startLocationUpdates() : self.stopLocationUpdates()
            UserDefaults.standard.set(updatesStarted, forKey: "liveUpdatesStarted")
        }
    }
    
    var backgroundUpdates: Bool = UserDefaults.standard.bool(forKey: "BGActivitySessionStarted") {
        didSet {
            backgroundUpdates ? self.backgroundActivitySession = CLBackgroundActivitySession() : self.backgroundActivitySession?.invalidate()
            UserDefaults.standard.set(backgroundUpdates, forKey: "BGActivitySessionStarted")
            // print("Background updates: \(backgroundUpdates)")
        }
    }
    
    @ObservationIgnored private let notificationCenter = UNUserNotificationCenter.current()
    @ObservationIgnored private var notificationContent = UNMutableNotificationContent()
    
    init() {  // was private
        // UserDefaults.standard.set(false, forKey: "BGActivitySessionStarted")
        print("Initializing LocationsHandler.  Background updates: \(backgroundUpdates)")
        //self.manager = CLLocationManager()  // Creating a location manager instance is safe to call here in `MainActor`.
        notificationContent.title = "Location updates inactive."
        notificationContent.body = "You may not receive accurate location updates when AnglerVox is in the background."
        Task {
            try await notificationCenter.requestAuthorization(options: [.badge])
        }
    }
    
    func startLocationUpdates() {
        //if self.manager.authorizationStatus == .notDetermined {
        //    self.manager.requestWhenInUseAuthorization()
        //}
        Task {
            do {
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    if !self.updatesStarted {
                        print("Breaking out of location updates")
                        break
                    }  // End location updates by breaking out of the loop.
                    self.lastUpdate = update
                    if let loc = update.location {
                        self.isReceivingUpdates = true
                        self.lastLocation = loc
                        self.lastLocation2D = loc.coordinate
                        self.isStationary = update.stationary
                        self.count += 1
                        // self.logger.info("Location \(self.count): \(self.lastLocation),  Heading: \(self.lastHeading),  Stationary: \(self.isStationary)")
                    }
                    if lastUpdate!.insufficientlyInUse {
                        print("insufficientlyInUse")
                        if self.hasShownAlert == false {
                            self.hasShownAlert = true
                            let notification = UNNotificationRequest(identifier: "doughaacke.app.mynotification", content: notificationContent, trigger: nil)
                            try await notificationCenter.add(notification)
                        }
                    } else {
                        if lastUpdate!.authorizationDeniedGlobally ||
                            lastUpdate!.authorizationDenied ||
                            lastUpdate!.authorizationRestricted ||
                            lastUpdate!.accuracyLimited
                        {
                            isAuthorized = false
                                print(" * * Location updates stopped due to authorization error")
                        } else {
                            isAuthorized = true
                        }
                    }
                }
            } catch {
                self.logger.error("Could not start location updates")
            }
        }
    }
    
    func stopLocationUpdates() {
        self.logger.info("Stopping location updates")
        backgroundUpdates = false
    }
    
    func getLocationName(for location: CLLocation) async -> String {
        let name = try? await CLGeocoder().reverseGeocodeLocation(location).first?.locality
        return name ?? ""
    }
}

// ============================================================================

@Observable
class HeadingManager: NSObject, CLLocationManagerDelegate {
    static let shared = HeadingManager()
    var lastHeading: Double = 0
    var isAuthorized = false
    @ObservationIgnored let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func startLocationServices() {
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse {
            isAuthorized = true
            manager.startUpdatingHeading()
            manager.activityType = .otherNavigation
        } else {
            isAuthorized = false
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.lastHeading = newHeading.magneticHeading
        // print("*Heading: \(lastHeading)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) { }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                // print("Location Authorized. Starting Location Services")
                isAuthorized = true
                manager.requestLocation()
            case .notDetermined:
                // print("Location not Determined")
                isAuthorized = true
                manager.requestWhenInUseAuthorization()
            case .denied:
                // print("Location Denied")
                isAuthorized = false
            default:
                print("Location Default. Starting Location Services")
                startLocationServices()
        }
    }
    
   
}

