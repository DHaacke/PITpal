//
//  ChartToPDF.swift
//  PITPal
//
//  Created by Doug Haacke on 7/1/25.
//

import SwiftUI
import Charts
import UIKit
import UniformTypeIdentifiers

//struct ChartToPDF {
//    // Function to create and export the chart to PDF
//    static func exportChartToPDF(filteredFish: [FishData], fishChartData: [FishChartData], title: String, species: String, filename: String) {
//        
//        let chartView = LengthBarChartView(filteredFish: filteredFish, fishChartData: fishChartData, title: title, species: species)
//
//        // Create a UIHostingController to render SwiftUI view
//        let hostingController = UIHostingController(rootView: chartView)
//        
//        // Set up view size
//        let size = CGSize(width: 595, height: 842) // A4 size in points
//        hostingController.view.frame = CGRect(origin: .zero, size: size)
//        
//        // Ensure the view is laid out
//        hostingController.view.setNeedsLayout()
//        hostingController.view.layoutIfNeeded()
//        
//        // Create PDF context
//        let pdfData = NSMutableData()
//        UIGraphicsBeginPDFContextToData(pdfData, CGRect(origin: .zero, size: size), nil)
//        
//        // Begin PDF page
//        UIGraphicsBeginPDFPage()
//        
//        // Get the current graphics context
//        guard let context = UIGraphicsGetCurrentContext() else {
//            UIGraphicsEndPDFContext()
//            return
//        }
//        
//        // Render the chart view into the PDF context
//        hostingController.view.layer.render(in: context)
//        
//        // End PDF context
//        UIGraphicsEndPDFContext()
//        
//        // Save PDF to file
//        do {
//            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//            let fileURL = documentsDirectory.appendingPathComponent("\(fileName).pdf")
//            try pdfData.write(to: fileURL)
//            print("PDF saved to: \(fileURL)")
//        } catch {
//            print("Error saving PDF: \(error)")
//        }
//    }
//}
