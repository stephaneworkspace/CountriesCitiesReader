//
//  StructSimplifiedCountry.swift
//
//
//  Created by Stéphane Bressani on 28.02.2024.
//

import Foundation

public struct SimplifiedCountry {
    public let cca2: String
    public let cca3: String
    public let translations: Translations
    public let pngFlag: String
    
    public init(cca2: String, cca3: String, translations: Translations, pngFlag: String) {
        self.cca2 = cca2
        self.cca3 = cca3
        self.translations = translations
        self.pngFlag = pngFlag
    }
}

public struct Translations {
    public let fra: String
    public let deu: String
    public let eng: String
    let kFra: String
    let kDeu: String
    let kEng: String
    
    public init(fra: String, deu: String, eng: String) {
        self.fra = fra
        self.deu = deu
        self.eng = eng
        // Sorting
        self.kFra = fra.folding(options: .diacriticInsensitive, locale: .current).uppercased()
        self.kDeu = deu.folding(options: .diacriticInsensitive, locale: .current).uppercased()
        self.kEng = eng.folding(options: .diacriticInsensitive, locale: .current).uppercased()
    }
}

extension CountriesDB {
    public var simplifiedCountries: [SimplifiedCountry] {
        // Make sure that countries is initialized and contains the loaded data.
        guard let countries = self.countries else { return [] }
        
        return countries.map { country in
            let fra = country.translations["fra"]?.common ?? ""
            let deu = country.translations["deu"]?.common ?? ""
            let eng = country.translations["eng"]?.common ?? ""
            let pngFlag = "\(country.cca3.lowercased()).png"
            
            return SimplifiedCountry(
                cca2: country.cca2,
                cca3: country.cca3,
                translations: Translations(fra: fra, deu: deu, eng: eng),
                pngFlag: pngFlag
            )
        }.sorted { $0.translations.kFra < $1.translations.kFra }
    }
}
