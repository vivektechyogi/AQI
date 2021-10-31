//
//  XAxisNameFormater.swift
//  AQI
//
//  Created by Jai Mataji on 31/10/21.
//

import Foundation
import  Charts

final class XAxisNameFormater: NSObject, IAxisValueFormatter {
    
    func stringForValue( _ value: Double, axis _: AxisBase?) -> String {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM \n hh:mm"
        
        return formatter.string(from: Date(timeIntervalSince1970: value))
    }
    
}
