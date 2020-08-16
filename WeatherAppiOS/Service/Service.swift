//
//  Service.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 11/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import Foundation

typealias WeatherCallback = (WeatherData) -> Void

class Service {
    
    // MARK: - declarate shared propertie(singleton) to access helper functions
    static let shared = Service()
    
    func getData(_ url: URL, callback: @escaping WeatherCallback) {
        URLSession.shared.dataTask(with: url) { (result, _, _) in
            guard let result = result else { return }
            
            do {
                let weather = try JSONDecoder().decode(WeatherData.self, from: result)
                callback(weather)
            } catch {
//                print("Error serializing json:", jsonErr)
            }
        }.resume()
    }
}
