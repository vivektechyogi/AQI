//
//  ViewController.swift
//  AQI
//
//  Created by Jai Mataji on 30/10/21.
//

import UIKit

class ViewController: UIViewController {

    var aqiData = [String:AQIViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    func getAQIData(){
        Service.sharedInstance.startAQISocket { aqis, error in
            if error == nil{
                print("received text: \(aqis?.count) \(aqis?.last?.city)")
                if let aqisData = aqis{
                    for aqi in aqisData{
                        self.aqiData.updateValue(AQIViewModel(aqi: aqi, timestamp: Date().timeIntervalSince1970), forKey: aqi.city ?? "")
                    }
                }
                DispatchQueue.main.async {
                    
                }
            }
        }
    }

}

