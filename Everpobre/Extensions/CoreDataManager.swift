//
//  CoreDataManager.swift
//  Everpobre
//
//  Created by Javi on 1/4/18.
//  Copyright © 2018 Javi. All rights reserved.
//

import CoreData

struct CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: EVERPOBRE_CD)
        
        container.loadPersistentStores{ (storeDescription, err) in
            if let err = err {
                fatalError("Loading of store failed \(err)")
            }
        }
        return container
    }()
}
