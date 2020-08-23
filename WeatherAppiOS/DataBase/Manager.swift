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

    // MARK: - Get towns
    func getTown() -> [Town] {
        let repo = Repository(database: appDelegate.database)
        let towns = repo.fetchTown()

        return towns
    }

    // MARK: - Delete all towns
    func clearAllTown() {
        let responseFetchRequest: NSFetchRequest<Town> = Town.fetchRequest()
        let responses = try! appDelegate.database.context.fetch(responseFetchRequest)
        for obj in responses {
            appDelegate.database.context.delete(obj)
        }
        appDelegate.database.saveContext()
    }

    // MARK: - Delete town
       func deleteTown(name: String) {
           let responseFetchRequest: NSFetchRequest<Town> = Town.fetchRequest()
           responseFetchRequest.predicate = NSPredicate(format: "name== %@", "\(name)")
        let towns = try! appDelegate.database.context.fetch(responseFetchRequest)
           for town in towns {
            appDelegate.database.context.delete(town)
           }
           do {
            try appDelegate.database.context.save() // save
           } catch {
               // Do something... fatalerror
           }

       }

    // MARK: - add town
    func addTown() -> Town {
        let town = NSEntityDescription.insertNewObject(forEntityName: "Town", into: appDelegate.database.context) as! Town
        do {
            try appDelegate.database.context.save()
        } catch let error as NSError {
            print(error)
        }
        return town
    }
}
