//
//  WeatherCell.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 12/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var weatherState: UILabel!
    @IBOutlet weak var weatherTemperature: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
