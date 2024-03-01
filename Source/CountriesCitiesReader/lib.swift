//
//  lib.swift
//  
//
//  Created by Stéphane Bressani on 28.02.2024.
//

import Foundation
import SwiftUI
import Resources
import Countries
import Cities
import cwrapper

public class CountriesCitiesReader {
    var resCountries: Resources
    var resFlags: Resources
    var resCities: Resources
    var countriesDB: CountriesDB?
    var citiesDB: CitiesDB
    var swOK: Bool // if any error
    
    public init() {
        self.resCountries = Resources(zipFile: "mledoze-countries")
        if self.resCountries.load() {
            if self.resCountries.unzip() {
                let jsonFile: String = self.resCountries.getUnzip()!.getString(swFile: true) + "/mledoze-countries/countries.json"
                self.countriesDB = CountriesDB(jsonFile: jsonFile)
                self.swOK = true; // OK
                countriesDB!.loadCountries()
            } else {
                self.countriesDB = nil
                self.swOK = false
            }
        } else {
            self.countriesDB = nil
            self.swOK = false
        }
        self.resFlags = Resources(zipFile: "flags")
        if self.resFlags.load() {
            if self.resFlags.unzip() {
                
            } else {
                self.swOK = false
            }
        } else {
            self.swOK = false
        }
        self.resCities = Resources(zipFile: "ne_10m_populated_places")
        var cities: [City] = []
        if self.resCities.load() {
            if self.resCities.unzip() {
                // call shapelib c wrapper
                let unzipFile = self.resCities.getUnzip()!
                let pathPtr = unzipFile.getPtr()
                var citiesRes = cwrapperDb(pathPtr)
                if citiesRes.codeError == 0 {
                    for i in 0..<citiesRes.size {
                        if let element = citiesRes.records[Int(i)] {
                            cities.append(City(id: Int(element.pointee.id), cca2: String(cString: element.pointee.cca2), name: String(cString: element.pointee.name), nameFra: String(cString: element.pointee.name_fr), lat: element.pointee.lat, lng: element.pointee.lng))
                        }
                    }
                }
                cwrapperFreeResult(&citiesRes)
                unzipFile.freePtr(ptr: pathPtr)
            } else {
                self.swOK = false
            }
        } else {
            self.swOK = false
        }
        self.citiesDB = CitiesDB(cities: cities)
    }
    
    /// Get an array of SimplifiedCountry
    /// This array is the full list of all countries in the world
    public func getCountries() -> [SimplifiedCountry] {
        if self.swOK {
            return self.countriesDB!.simplifiedCountries
        } else {
            return []
        }
    }
    
    /// Get the flag png URL
    /// You need to specify:
    /// pngFlag: String
    /// You can find it in SimplifiedCountry.pngFlag
    public func flagURL(pngFlag: String) -> String {
        if self.swOK {
            let path = self.resCountries.getUnzip()!.getString(swFile: true) + pngFlag
            if let url = URL(string: path) {
                var u = url.absoluteString
                if u.hasPrefix("file://") {
                    u.removeFirst("file://".count)
                }
                return u
            }
        }
        return ""
    }
    
    /// Get cities
    /// You need to specify:
    /// cca2: String
    /// This is the code country code cca2
    /// The date:
    /// date: Date?
    /// The date is for calculate the GMT and Daylight Saving Time
    public func getCities(cca2: String, date: Date?) -> [SimplifiedCity] {
        if self.swOK {
            return self.citiesDB.getCities(cca2: cca2, date: date)
        } else {
            return []
        }
    }
}
