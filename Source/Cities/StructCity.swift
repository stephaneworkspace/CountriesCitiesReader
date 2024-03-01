//
//  StructCity.swift
//  
//
//  Created by Stéphane Bressani on 01.03.2024.
//

import Foundation

public struct City {
    public let id: Int
    public let cca2: String // Country code cca2
    public let name: String
    public let nameFra: String // Name french
    public let lat: Double
    public let lng: Double
    
    public init(id: Int, cca2: String, name: String, nameFra: String, lat: Double, lng: Double) {
        self.id = id
        self.cca2 = cca2
        self.name = name
        self.nameFra = nameFra
        self.lat = lat
        self.lng = lng
    }
}
