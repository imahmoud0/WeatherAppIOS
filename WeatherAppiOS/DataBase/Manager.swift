//
//  Manager.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 14/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 13.0, *)
class Manager {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    // MARK: - Get Cities
    func getCity() -> [Town] {
        let repo = Repository(database: appDelegate.database)
        let cities = repo.fetchCity()

        return cities
    }

    // MARK: - Delete all Cities
    func clearAllCity() {
        let responseFetchRequest: NSFetchRequest<Town> = Town.fetchRequest()
        let responses = try! appDelegate.database.context.fetch(responseFetchRequest)
        for obj in responses {
            appDelegate.database.context.delete(obj)
        }
        appDelegate.database.saveContext()
    }

    // MARK: - Delete city
       func deleteCity(name: String) {
           let responseFetchRequest: NSFetchRequest<Town> = Town.fetchRequest()
           responseFetchRequest.predicate = NSPredicate(format: "name== %@", "\(name)")
        let cities = try! appDelegate.database.context.fetch(responseFetchRequest)
           for city in cities {
            appDelegate.database.context.delete(city)
           }
           do {
            try appDelegate.database.context.save() // save
           } catch {
               // Do something... fatalerror
           }

       }

    // MARK: - add City
    func addCity(_ town: City) {
        
        let cities = getCity()
        var cityNames = [String]()
        var exists: Bool = false
        if cities.count > 0 {
            for index in 0...cities.count - 1 {
                cityNames.append(cities[index].name!)
            }
        }
        if let town = town.name, cityNames.contains(town) {
            print("already exist")
            exists = true
        }
        if  !exists {
            let city = Town(context: appDelegate.database.context)
            city.name = town.name
            city.latitude = town.latitude!
            city.longitude = town.longitude!
        }
        do {
            try appDelegate.database.context.save()
        }
        catch let error as NSError {
            print(error)
        }
    }
}
