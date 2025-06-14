//
//  Bundle-Decodable.swift
//  FlightWatch for Mac
//
//  Created by Doug Haacke on 12/20/24.
//

import Foundation

extension Bundle {
    func decodeJson <T:Decodable> (_ type : T.Type , file : String,
                                   dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                                   keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) -> T {
        
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to load file ")
        }
        
        do {
            let jsonData = try Data(contentsOf: url)
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            let result = try decoder.decode(type, from: jsonData)
            return result
        }
        catch let DecodingError.dataCorrupted(context) {
            fatalError("\(file) JSON: \(context)")
        }
        catch let DecodingError.keyNotFound(key, context) {
            fatalError("\(file) JSON Key '\(key)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
        }
        catch let DecodingError.valueNotFound(value, context) {
            fatalError("\(file) JSON Value '\(value)' not found: \(context.debugDescription), codingPath: \(context.codingPath)")
        }
        catch let DecodingError.typeMismatch(type, context)  {
            fatalError("\(file) JSON Type '\(type)' not found, mismatch: \(context.debugDescription), codingPath: \(context.codingPath)")
        }
        catch {
            fatalError("\(file) Error decoding JSON: \(error.localizedDescription)")
        }
    }
}
