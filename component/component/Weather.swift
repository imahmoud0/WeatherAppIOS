//
//  Weather.swift
//  component
//
//  Created by Mahmoud Ibrahmi on 18/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

// MARK: - Weather Data
public class WeatherData: Decodable {
    
    public let lat, lon: Double?
    public let timezone: String?
    public let timezoneOffset: Int?
    public let current: Current?
    public let hourly: [Current]?
    public let daily: [Daily]?
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, hourly, daily
    }
}

// MARK: - Current
public struct Current: Decodable {
    public let dt, sunrise, sunset: Int?
    public let temp, feelsLike: Double?
    public let pressure, humidity: Int?
    public let dewPoint, uvi: Double?
    public let clouds, visibility: Int?
    public let windSpeed: Double?
    public let windDeg: Int?
    public let weather: [Weather]?
    public let pop: Double?
    public let rain: Rain?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, pop, rain
    }
}

// MARK: - Rain
public struct Rain: Decodable {
    public let the1H: Double?
    
    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
}


// MARK: - Daily
public struct Daily: Decodable {
    public let dt, sunrise, sunset: Int?
    public let temp: Temp?
    public let feelsLike: FeelsLike?
    public let pressure, humidity: Int?
    public let dewPoint, windSpeed: Double?
    public let windDeg: Int?
    public let weather: [Weather]?
    public let clouds: Int?
    public let pop, uvi, rain: Double?
    
    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, pop, uvi, rain
    }
}

// MARK: - Weather
public struct Weather: Decodable {
    public let id: Int?
    public let main: String?
    public let weatherDescription: String?
    public let icon: String?
    
    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}


// MARK: - FeelsLike
public struct FeelsLike: Decodable {
    public let day, night, eve, morn: Double?
}

// MARK: - Temp
public struct Temp: Decodable {
    public let day, min, max, night: Double?
    public let eve, morn: Double?
}

