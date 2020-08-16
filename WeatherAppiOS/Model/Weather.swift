//
//  Weather.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 11/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: String?
    let weatherDescription: String?
    let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}
