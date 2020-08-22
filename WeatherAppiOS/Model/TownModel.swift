//
//  TownModel.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 13/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import  component

// MARK: - TownModel
struct TownModel {
    let town: Town
    let weather: WeatherData
    init(town: Town, weather: WeatherData) {
        self.town = town
        self.weather = weather
    }
}
