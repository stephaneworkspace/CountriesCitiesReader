//
//  StructCountry.swift
//  
//
//  Created by Stéphane Bressani on 28.02.2024.
//

import Foundation

struct Country: Codable {
    let name: Name
    let tld: [String]
    let cca2, ccn3, cca3, cioc: String
    let independent: Bool?
    let unMember: Bool
    let currencies: [String: Currency]
    let idd: IDD
    let capital, altSpellings: [String]
    let region, subregion: String
    let languages: [String: String]
    let translations: [String: Translation]
    let latlng: [Double]
    let landlocked: Bool
    let borders: [String]
    let area: Double
    let flag: String
    let demonyms: [String: Demonym]
}

struct Name: Codable {
    let common, official: String
    let native: [String: NativeName]
}

struct NativeName: Codable {
    let official, common: String
}

struct Currency: Codable {
    let name, symbol: String
}

struct IDD: Codable {
    let root: String
    let suffixes: [String]
}

struct Translation: Codable {
    let official, common: String
}

struct Demonym: Codable {
    let f, m: String
}
