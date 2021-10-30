//
//  AQIViewModel.swift
//  AQI
//
//  Created by Jai Mataji on 30/10/21.
//

import Foundation

class AQIViewModel: Codable {
    let city: String?
    let aqi: Double?
    let timestamp: Double?

    init(aqi: AQIModel, timestamp:Double) {
        self.city = aqi.city
        self.aqi = aqi.aqi
        self.timestamp = timestamp
    }
}
