//
//  CitiesDB.swift
//  
//
//  Created by Stéphane Bressani on 01.03.2024.
//

import Foundation

public class CitiesDB {
    var cities: [City]
    
    public init(cities: [City]) {
        self.cities = cities
    }
    
    /// Get the cities of a country
    public func getCities(cca2: String, date: Date?) -> [SimplifiedCity] {
        var resFinal : [SimplifiedCity] = []
        for x in self.cities {
            if String(cString: x.cca2) == cca2 {
                resFinal.append(SimplifiedCity(id: x.id, name: x.name, nameFra: x.nameFra, lat: x.lat, lng: x.lng, date: date))
            }
        }
        return resFinal.sorted { $0.kFra < $1.kFra }
    }
}
