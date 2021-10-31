//
//  Extension.swift
//  AQI
//
//  Created by Jai Mataji on 30/10/21.
//

import Foundation
import UIKit

//MARK: Decodable Extension

extension Decodable {
    static func map(JSONString:String) -> Self? {
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            return try decoder.decode(Self.self, from: Data(JSONString.utf8))
        } catch let error {
            print(error)
            return nil
        }
    }
}

//MARK: Double Extension

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

//MARK: UIColor Extension

extension UIColor {
    convenience init(hex: String) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:1.0)
    }
}

//MARK: UIView Extension

extension UIView {
    
    func addRadius(brRadius: CGFloat = 5.0) -> Void {
        layer.masksToBounds = false
        layer.cornerRadius = brRadius
    }
    
    func dropShadow(shadowRadius: CGFloat = 1) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero//CGSize(width: 1, height: 1)
        layer.shadowRadius = shadowRadius
    }
}

//MARK: Date Extension

extension Date {

    func timeAgoSinceDate() -> String {

        // From Time
        let fromDate = self

        // To Time
        let toDate = Date()

        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "year ago" : "\(interval)" + " " + "years ago"
        }

        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "month ago" : "\(interval)" + " " + "months ago"
        }

        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {

            return interval == 1 ? "\(interval)" + " " + "day ago" : "\(interval)" + " " + "days ago"
        }

        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "hour ago" : "\(interval)" + " " + "hours ago"
        }
        
        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "minute ago" : "\(interval)" + " " + "minutes ago"
        }
        
        // Seconds
        if let interval = Calendar.current.dateComponents([.second], from: fromDate, to: toDate).second, interval > 0 {

            return interval == 1 ? "\(interval)" + " " + "second ago" : "\(interval)" + " " + "seconds ago"
        }

        return "a moment ago"
    }
}
