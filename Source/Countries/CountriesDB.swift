//
//  CountriesDB.swift
//  
//
//  Created by Stéphane Bressani on 28.02.2024.
//

import Foundation

let SW_MSG = false // Show message in this file

public class CountriesDB {
    public var swDebug: Bool
    public var jsonFile: String
    var countries: [Country]?
    
    public init(jsonFile: String) {
        self.swDebug = SW_MSG // Console info
        self.jsonFile = jsonFile
        self.countries = nil
    }
    
    public func loadCountries() {
        guard let fileURL = URL(string: self.jsonFile) else {
            if swDebug {
                print("Invalid URL.")
            }
            return
        }
        
        do {
            // Loading json file
            let data = try Data(contentsOf: fileURL)
            
            // Decoding JSON content in instances of Country
            let decoder = JSONDecoder()
            self.countries = try decoder.decode([Country].self, from: data)
            
            if swDebug {
                print("Country loaded successly.")
            }
        } catch {
            if swDebug {
                print("Parse json error : \(error)")
            }
        }
    }
}
