//
//  CLLocationCoordinate2D+Extensions.swift
//  FlightWatch for iPad
//
//  Created by Doug Haacke on 1/6/25.
//

import CoreLocation

extension CLLocationCoordinate2D: @retroactive Equatable {}
extension CLLocationCoordinate2D: @retroactive Identifiable, @retroactive Hashable {
    
    func bearingTo(to: CLLocationCoordinate2D) -> Int {
        let lat1 = degreesToRadians(degrees: self.latitude)
        let lon1 = degreesToRadians(degrees: self.longitude)

        let lat2 = degreesToRadians(degrees: to.latitude)
        let lon2 = degreesToRadians(degrees: to.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        
        var bearing = Int(radiansToDegrees(radians: radiansBearing))
        if bearing < 0 {
            bearing += 360
        } else if bearing > 360 {
            bearing -= 360
        }
        return bearing
    }
    
    func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180.0
    }
    func radiansToDegrees(radians: Double) -> Double {
        return radians * 180.0 / .pi
    }
    
    func distance(to: CLLocationCoordinate2D) -> CLLocationDistance {
        let home   = CLLocation(latitude: self.latitude, longitude: self.longitude)
        let target = CLLocation(latitude: to.latitude, longitude: to.longitude)
        return home.distance(from: target)
    }
    /// Get coordinate moved from current to `distanceMeters` meters with azimuth `azimuth` [0, Double.pi)
    ///
    /// - Parameters:
    ///   - distanceMeters: the distance in meters
    ///   - azimuth: the azimuth (bearing)
    /// - Returns: new coordinate
    func shift(byDistance distanceMeters: Double, azimuth: Double) -> CLLocationCoordinate2D {
        let bearing = azimuth
        let origin = self
        let distRadians = distanceMeters / (6372797.6) // earth radius in meters

        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180

        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(bearing))
        let lon2 = lon1 + atan2(sin(bearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
    func toLocation() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
    func midLocation(to: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let lat1 = Double.pi * self.latitude / 180.0
        let long1 = Double.pi * self.longitude / 180.0
        let lat2 = Double.pi * to.latitude / 180.0
        let long2 = Double.pi * to.longitude / 180.0
        // Source: http://www.movable-type.co.uk/scripts/latlong.html
        let bxLoc = cos(lat2) * cos(long2 - long1)
        let byLoc = cos(lat2) * sin(long2 - long1)
        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bxLoc) * (cos(lat1) + bxLoc) + (byLoc * byLoc)))
        let mlong = long1 + atan2(byLoc, cos(lat1) + bxLoc)
        
        return CLLocationCoordinate2D(latitude: mlat * 180 / Double.pi, longitude: mlong * 180 / Double.pi)
    }
    
//    func midLocation(start: CLLocationCoordinate2D, end: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
//        let lat1 = Double.pi * start.latitude / 180.0
//        let long1 = Double.pi * start.longitude / 180.0
//        let lat2 = Double.pi * end.latitude / 180.0
//        let long2 = Double.pi * end.longitude / 180.0
//        // Source: http://www.movable-type.co.uk/scripts/latlong.html
//        let bxLoc = cos(lat2) * cos(long2 - long1)
//        let byLoc = cos(lat2) * sin(long2 - long1)
//        let mlat = atan2(sin(lat1) + sin(lat2), sqrt((cos(lat1) + bxLoc) * (cos(lat1) + bxLoc) + (byLoc * byLoc)))
//        let mlong = long1 + atan2(byLoc, cos(lat1) + bxLoc)
//
//        return CLLocationCoordinate2D(latitude: mlat * 180 / Double.pi, longitude: mlong * 180 / Double.pi)
//    }
    
    
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
        
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
        
    public var id: String {
        String(self.latitude) + ", " + String(self.longitude)
    }
    
//    public func isPointInPolygon(polygon: [CLLocationCoordinate2D]) -> Bool {
//        let x = self.longitude
//        let y = self.latitude
//        
//        var inside = false
//        for i in 0..<polygon.count {
//            let j = (i + 1) % polygon.count
//            
//            let xi = polygon[i].longitude
//            let yi = polygon[i].latitude
//            let xj = polygon[j].longitude
//            let yj = polygon[j].latitude
//            
//            let intersect = ((yi > y) != (yj > y)) &&
//                            (x < (xj - xi) * (y - yi) / (yj - yi) + xi)
//            if intersect {
//                inside = !inside
//            }
//        }
//        return inside
//    }
    
    func isPointInPolygon(polygon: [CLLocationCoordinate2D]) -> Bool {
        guard polygon.count >= 3 else { return false } // Need at least 3 points for a polygon
        
        var inside = false
        
        for i in 0..<polygon.count  {
            let j = (i + 1) % polygon.count
            let vertexI = polygon[i]
            let vertexJ = polygon[j]
            
            // Check if point is exactly on vertex
            if vertexI.latitude == self.latitude && vertexI.longitude == self.longitude {
                return true
            }
            
            // Ray-casting check
            let intersect = ((vertexI.latitude > self.latitude) != (vertexJ.latitude > self.latitude)) &&
                (self.longitude < (vertexJ.longitude - vertexI.longitude) *
                 (self.latitude - vertexI.latitude) /
                 (vertexJ.latitude - vertexI.latitude) + vertexI.longitude)
            
            if intersect {
                inside.toggle()
            }
        }
        return inside
    }
    
    
}


/*
 
 import Foundation

 // Define the elevations and distance
 let elevationA: Double = 10.0  // Elevation of point A in feet
 let elevationB: Double = 50.0  // Elevation of point B in feet
 let horizontalDistance: Double = 150.0  // Distance between A and B in feet

 // Calculate the vertical difference
 let verticalDifference = elevationB - elevationA

 // Calculate the angle in radians using arctan
 let angleInRadians = atan(verticalDifference / horizontalDistance)

 // Convert radians to degrees
 let angleInDegrees = angleInRadians * (180.0 / .pi)

 // Print the result
 print("The angle from point B to A is \(angleInDegrees) degrees.")

 // Optional: If you want to round to a specific number of decimal places
 let roundedAngle = round(angleInDegrees * 100) / 100
 print("Rounded to two decimal places, the angle is \(roundedAngle) degrees.")
 

*/
