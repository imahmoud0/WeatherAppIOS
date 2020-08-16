//
//  DataBaseManager.swift
//  WeatherAppiOS
//
//  Created by Mahmoud Ibrahmi on 14/08/2020.
//  Copyright © 2020 brahmi. All rights reserved.
//

import CoreData

protocol DatabaseProtocol {
    var context: NSManagedObjectContext { get }
    func saveContext()
}

class DataBaseManager: DatabaseProtocol {
    var context: NSManagedObjectContext
    
    init() {
        guard let modelURL = Bundle.main.url(forResource: "WeatherDataModel", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // create model
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        // create persitent store coordinator
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        
        // create context
        context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = psc
        context.mergePolicy = NSOverwriteMergePolicy
        
        // add store
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        let storeURL = docURL.appendingPathComponent("Weather.sqlite")
        
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
    }
    
    func saveContext() {
        
        if context.hasChanges {
            
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
