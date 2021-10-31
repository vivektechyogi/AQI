//
//  AQITableViewCell.swift
//  AQI
//
//  Created by Jai Mataji on 30/10/21.
//

import UIKit

class AQITableViewCell: UITableViewCell {

    @IBOutlet weak var indexStatusLabel: UILabel!
    @IBOutlet weak var indexStatusImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var currentAQILabel: UILabel!
    
    @IBOutlet weak var mainBackView: UIView!
    @IBOutlet weak var indexBackView: UIView!
    @IBOutlet weak var infoBackView: UIView!
    
    @IBOutlet weak var lastUpdateOnLabel: UILabel!
}
