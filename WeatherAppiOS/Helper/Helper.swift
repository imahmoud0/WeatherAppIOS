//
//  Helper.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 13/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import Foundation

struct Helper {

    // MARK: - declarate shared propertie(singleton) to access helper functions
    static let shared = Helper()

    private init() {}

    // MARK: - Date Formatter

    func getDayFromTime(time: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"

        return dateFormatter.string(from: date)
    }

    func getTimeFromDate(time: Int) -> String {

        let date = Date(timeIntervalSince1970: TimeInterval(time))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"

        return dateFormatter.string(from: date)
    }
}
