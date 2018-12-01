//
//  Unsplash.swift
//  MediaFrenzy
//
//  Created by Ian Keen on 2018-11-30.
//  Copyright © 2018 Ian Keen. All rights reserved.
//

import Foundation
import ImageIO
import CoreLocation

final class Unsplash: ImageSource {
    // MARK: - Properties
    private let urlSession: URLSession
    private var locations: [String: Int] = [:]
    private var currentLocation: CLLocation?

    // MARK: - Lifeycle
    init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    // MARK: - Public
    func retrieveImage(sized size: CGSize) -> EventualResult<Data> {
        let url = URL(string: "https://unsplash.it/\(size.width)/\(size.height)/?random")!
        var request = URLRequest(
            url: url,
            cachePolicy: .useProtocolCachePolicy,
            timeoutInterval: 10.0
        )
        request.httpMethod = "GET"
        request.addValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        request.addValue("image/jpeg", forHTTPHeaderField: "Accept")

        return urlSession
            .response(from: request)
            .map(applyMetadata) // images don't have meta data so we add some dummy data
    }

    // MARK: - Private
    private func applyMetadata(to imageData: Data) throws -> Data {
        guard
            let source = CGImageSourceCreateWithData(imageData as CFData, nil),
            let imageType = CGImageSourceGetType(source)
            else { throw ImageSourceError.invalidImage }

        let finalData = NSMutableData()

        guard let destination = CGImageDestinationCreateWithData(finalData, imageType, 1, nil)
            else { throw ImageSourceError.invalidImage }

        var location = currentLocation ?? CLLocation.random
        var count = locations[location.description] ?? 0
        if count >= 10 { location = CLLocation.random; count = 0 }
        currentLocation = location
        locations[location.description] = count + 1

        CGImageDestinationAddImageFromSource(destination, source, 0, location.exifMetadata() as CFDictionary)

        guard CGImageDestinationFinalize(destination) else { throw ImageSourceError.invalidImage }
        
        return finalData as Data
    }
}
