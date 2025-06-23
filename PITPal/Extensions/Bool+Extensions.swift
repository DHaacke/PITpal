//
//  Bool+Extensions.swift
//  PITPal
//
//  Created by Doug Haacke on 6/22/25.
//

import Foundation

extension Bool: @retroactive Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        print("* * * \(lhs), \(rhs)")
        return !lhs && rhs
    }
}
