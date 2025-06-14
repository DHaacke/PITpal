//
//  Int+Extensions.swift
//  FlightWatch for Mac
//
//  Created by Doug Haacke on 12/20/24.
//

import Foundation

extension Int {
    func format(suffix: String) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.usesGroupingSeparator = true
        let rs = numberFormatter.string(for: self) ?? "0"
        return "\(rs)\(suffix)"
    }
    func flightLevel() -> String {
        return String(format: "%03d", self >= 1000 ? self / 100 : 100)
    }
}
