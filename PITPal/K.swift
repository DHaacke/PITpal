//
//  K.swift
//  PITPal
//
//  Created by Doug Haacke on 6/13/25.
//

import Foundation
import SwiftUI

struct K {

    // views
    static let MAINMENU: String     = "MAINMENU"
    static let SETTINGS: String     = "SETTINGS"
    static let TAG: String          = "TAG"
    static let EXPORT: String       = "EXPORT"
    static let OTHER: String        = "OTHER"
    
    // bluetooth
    static let BLUETOOTH_OFF: Int            = 0
    static let BLUETOOTH_UNAUTHORIZED: Int   = 1
    static let CONNECTING: Int               = 2
    static let CONNECTED: Int                = 3
    static let CONNECTION_FAILED: Int        = 4
    static let DISCONNECTED: Int             = 5
    static let SCANNING: Int                 = 6
    static let SCANNING_OFF: Int             = 7
    static let BLUETOOTH_ON: Int             = 8
    
    // export formats
    static let EXPORT_CSV: String            = "CSV"
    static let EXPORT_JSON: String           = "JSON"
    
    
    
}

