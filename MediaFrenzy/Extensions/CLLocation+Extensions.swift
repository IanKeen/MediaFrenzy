//
//  CLLocation+Extensions.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import CoreLocation
import ImageIO

extension CLLocation {
    static let adelaide = CLLocation(latitude: -34.929, longitude:138.601)
    static let brisbane = CLLocation(latitude: -27.467778, longitude: 153.027778)
    static let canberra = CLLocation(latitude: -35.308056, longitude: 149.124444)
    static let darwin = CLLocation(latitude: -12.45, longitude: 130.833333)
    static let hobart = CLLocation(latitude: -42.880556, longitude: 147.325)
    static let melbourne = CLLocation(latitude: -37.813611, longitude: 144.963056)
    static let perth = CLLocation(latitude: -31.952222, longitude: 115.858889)
    static let sydney = CLLocation(latitude: -33.859972, longitude: 151.211111)
    
    static var random: CLLocation {
        func random(between first: CLLocationDegrees, and second: CLLocationDegrees) -> CLLocationDegrees {
            return CLLocationDegrees(arc4random()) / CLLocationDegrees(UINT32_MAX) * abs(first - second) + min(first, second)
        }
        
        return CLLocation(
            latitude: random(between: -90, and: 90),
            longitude: random(between: -180, and: 180)
        )
    }
}

extension CLLocation {
    func exifMetadata(heading: CLHeading? = nil) -> [AnyHashable: Any] {
        var metadata: [AnyHashable: Any] = [:]
        let altitudeRef = Int(altitude < 0.0 ? 1 : 0)
        let latitudeRef = coordinate.latitude < 0.0 ? "S" : "N"
        let longitudeRef = coordinate.longitude < 0.0 ? "W" : "E"
        
        // GPS metadata
        metadata[(kCGImagePropertyGPSLatitude as String)] = abs(coordinate.latitude)
        metadata[(kCGImagePropertyGPSLongitude as String)] = abs(coordinate.longitude)
        metadata[(kCGImagePropertyGPSLatitudeRef as String)] = latitudeRef
        metadata[(kCGImagePropertyGPSLongitudeRef as String)] = longitudeRef
        metadata[(kCGImagePropertyGPSAltitude as String)] = Int(abs(altitude))
        metadata[(kCGImagePropertyGPSAltitudeRef as String)] = altitudeRef
        metadata[(kCGImagePropertyGPSTimeStamp as String)] = timestamp.isoTime()
        metadata[(kCGImagePropertyGPSDateStamp as String)] = timestamp.isoDate()
        metadata[(kCGImagePropertyGPSVersion as String)] = "2.2.0.0"
        
        if let heading = heading {
            metadata[(kCGImagePropertyGPSImgDirection as String)] = heading.trueHeading
            metadata[(kCGImagePropertyGPSImgDirectionRef as String)] = "T"
        }
        
        return [(kCGImagePropertyGPSDictionary as String): metadata]
    }
}

private extension Date {
    private static let isoDateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeZone = TimeZone(abbreviation: "UTC")
        f.dateFormat = "yyyy:MM:dd"
        return f
    }()
    
    func isoDate() -> String {
        return Date.isoDateFormatter.string(from: self)
    }
    
    private static let isoTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.timeZone = TimeZone(abbreviation: "UTC")
        f.dateFormat = "HH:mm:ss.SSSSSS"
        return f
    }()

    func isoTime() -> String {
        return Date.isoTimeFormatter.string(from: self)
    }
}
