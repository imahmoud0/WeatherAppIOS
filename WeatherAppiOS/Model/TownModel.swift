//
//  TownModel.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 13/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

// MARK: - TownModel
struct TownModel {
    let town: Town
    let weather: WeatherData
    init(town: Town, weather: WeatherData) {
        self.town = town
        self.weather = weather
    }
}

// MARK: - City
struct City {
    let name: String?
    let longitude: Double?
    let latitude: Double?
}
