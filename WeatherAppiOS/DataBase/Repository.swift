//
//  Repository.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 14/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import CoreData

class Repository {

    let database: DatabaseProtocol

    init(database: DatabaseProtocol) {
        self.database = database
    }

    // MARK: - Fetch town
    func fetchTown() -> [Town] {
        let fetchRequest: NSFetchRequest<Town> = Town.fetchRequest()
        do {
            let town = try database.context.fetch(fetchRequest)
            return town
        } catch {
            print(error)
            return []
        }
    }
}
