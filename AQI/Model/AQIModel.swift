//
//  AQIModel.swift
//  AQI
//
//  Created by Jai Mataji on 30/10/21.
//

import Foundation

class AQIModel: Codable {
    let city: String?
    let aqi: Double?

    init(city: String, aqi: Double) {
        self.city = city
        self.aqi = aqi
    }
}
