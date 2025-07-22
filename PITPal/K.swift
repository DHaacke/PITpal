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
    static let MAINMENU: String                     = "MAINMENU"
    static let SETTINGS: String                     = "SETTINGS"
    static let TAG: String                          = "TAG"
    static let EXPORT: String                       = "EXPORT"
    static let SINGLE_SPECIES_SIZE_CHART: String    = "SINGLE_SPECIES_SIZE_CHART"
    static let DUAL_SPECIES_SIZE_CHART: String      = "DUAL_SPECIES_SIZE_CHART"
    static let SIZE_WEIGHT_MODEL_CHART: String      = "SIZE_WEIGHT_MODEL_CHART"
    static let TESTVIEW: String                     = "TESTVIEW"
    static let SURVEY_SUMMARY: String               = "SURVEY_SUMMARY"
    static let POPULATION_ESTIMATE: String          = "POPULATION_ESTIMATE"
    static let ARCHIVE: String                      = "ARCHIVE"
    
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
    static let EXPORT_MYSQL: String          = "MYSQL"
    
    // PDFs
    static let dotsPerInch: CGFloat         = 72.0
    static let pageWidth: CGFloat           = 8.5
    static let pageHeight: CGFloat          = 11.0
    
}

