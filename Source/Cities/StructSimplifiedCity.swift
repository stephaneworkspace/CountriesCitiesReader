//
//  StructSimplifiedCity.swift
//
//
//  Created by Stéphane Bressani on 01.03.2024.
//

import Foundation
import CoreLocation

let SW_MSG = false // Show message in this file

public class SimplifiedCity: Codable {
    public let id: Int
    public let name: String
    public let nameFra: String
    public let kFra: String // Sort by French
    public let lat: Double
    public let lng: Double
    public var tz: Double? // GMT
    public var date: Date? // Date for compute the GMT
    public var swDST: Bool = false // Daylight Saving Time
    
    public init(id: Int, name: String, nameFra: String, lat: Double, lng: Double, date: Date?) {
        self.id = id
        self.name = name
        self.nameFra = nameFra
        // Sorting
        self.kFra = nameFra.folding(options: .diacriticInsensitive, locale: .current).uppercased()
        // Localisation
        self.lat = lat
        self.lng = lng
        self.tz = nil
        // Date used to determinate the GMT (with Summer time or not) // TODO Summer Time Bool
        // The date can to be set in setDate(year, month, day)
        self.date = date
    }
    
    /// Set the date
    public func setDate(date: Date?) {
        self.date = date
    }
    
    /// Set time zone
    public func setTimeZone(completion: @escaping () -> Void) {
        guard let date = self.date else { return }
        tzProcess(lat: self.lat, lng: self.lng, at: date) { [weak self] offset, swDST in
            guard let self = self else { return }
            if let offset = offset {
                self.tz = offset
                self.swDST = swDST
            } else {
                if SW_MSG {
                    print("Unable to find the timezone for these coordinates.")
                }
            }
            completion()
        }
    }
}

/// Determinate the time zone and the daylight saving time
public func tzProcess(lat: Double, lng: Double, at date: Date, completion: @escaping (Double?, Bool) -> Void) {
    let location = CLLocation(latitude: lat, longitude: lng)
    let geocoder = CLGeocoder()

    geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
        guard let placemark = placemarks?.first, error == nil else {
            if SW_MSG {
                print("Geocoding error : \(error!.localizedDescription)")
            }
            completion(nil, false)
            return
        }
        
        if let timezone = placemark.timeZone {
            // Obtain the base offset in hours
            let offset = Double(timezone.secondsFromGMT(for: date)) / 3600.0
            let swDST = timezone.isDaylightSavingTime(for: date)
            if SW_MSG {
                print("Time zone: \(timezone.identifier) (GMT \(offset)) for the given date")
            }
            completion(offset, swDST)
        } else {
            if SW_MSG {
                print("Time zone not found")
            }
            completion(nil, false)
        }
    }
}
