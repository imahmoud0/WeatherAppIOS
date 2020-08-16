//
//  HourlyCell.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 13/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import UIKit

class HourlyCell: UICollectionViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var temp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
