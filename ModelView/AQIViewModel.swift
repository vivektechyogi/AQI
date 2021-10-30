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

    init(aqi: AQIModel) {
        self.city = aqi.city
        self.aqi = aqi.aqi
    }
}
