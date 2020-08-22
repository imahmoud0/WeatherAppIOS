//
//  Service.swift
//  component
//
//  Created by Mahmoud Ibrahmi on 18/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import Foundation

public typealias WeatherCallback = (WeatherData, Error?) -> Void

 public class Service {
        
    public init() {}

    // MARK: - declarate shared propertie(singleton) to access helper functions
    public static let shared = Service()
    
    public func getData(_ url: URL, callback: @escaping WeatherCallback) {
        URLSession.shared.dataTask(with: url) { (result, _, _) in
            guard let result = result else { return }
            
            do {
                let weather = try JSONDecoder().decode(WeatherData.self, from: result)
                callback(weather, nil)
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
        }.resume()
    }
}
