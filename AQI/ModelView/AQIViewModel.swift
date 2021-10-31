//
//  AQIViewModel.swift
//  AQI
//
//  Created by Jai Mataji on 30/10/21.
//

import Foundation
import UIKit

class AQIViewModel: Codable {
    let city: String?
    let aqi: Double?
    let timestamp: Double?
    let aqiColor: String?
    let titleStr: String?
    let imageStr: String?

    init(aqiData: AQIModel, timestamp:Double, aqiColor:String, titleStr: String, imageStr: String ) {
        self.city = aqiData.city
        self.aqi = aqiData.aqi
        self.timestamp = timestamp
        self.aqiColor = aqiColor
        self.titleStr = titleStr
        self.imageStr = imageStr
    }
}
