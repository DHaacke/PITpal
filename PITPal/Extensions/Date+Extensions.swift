//
//  Date+Extensions.swift
//  FlightWatch for Mac
//
//  Created by Doug Haacke on 12/20/24.
//

import Foundation

extension Date {

    func formatLarge(dt: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM y, HH:mm"
        formatter.timeZone = .current // TimeZone(abbreviation: "UTC")
        let result = formatter.string(from: dt)
        return result
    }
    func currentTimeStamp() -> Int64 {
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
    
    func format(format: String) -> String {
        let formatter = DateFormatter()
        // formatter.dateFormat = "MMMM dd, yyyy 'at' hh:mm:ss a 'UTC'Z" //If you dont want static "UTC" you can go for ZZZZ instead of 'UTC'Z.
        formatter.dateFormat = format
        formatter.timeZone = .current // TimeZone(abbreviation: "UTC")
        let result = formatter.string(from: self)
        return result
    }
    
    func mysqlDateMinusOneYear() -> String {
        let calendar = Calendar.current
        if let oneYearAgo = calendar.date(byAdding: .year, value: -1, to: self) {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd" // You can change this format as needed
            let dateString = formatter.string(from: oneYearAgo)
            return dateString
        }
        return "2024-01-01"
    }
    
    var millisecondsSince1970:Int64 {
        return Int64(self.timeIntervalSince1970)
    }
    
    var evening8pm: Date {
        Calendar.current.date(bySettingHour: 20, minute: 15, second: 0, of: self)!
    }
    
    var evening9pm: Date {
        Calendar.current.date(bySettingHour: 21, minute: 30, second: 10, of: self)!
    }
    
    var midnight: Date {
        Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: self)!
    }
    
    func timeToInt() -> Int {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minute = calendar.component(.minute, from: self)
        return hour * 100 + minute
    }
    
//    var millisecondsSince1970:Int64 {
//        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
//    }
//
//    init(milliseconds:Int) {
//        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
//    }
}
