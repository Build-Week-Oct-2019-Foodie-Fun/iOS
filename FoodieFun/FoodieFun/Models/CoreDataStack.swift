//
//  CoreDataStack.swift
//  FoodieFun
//
//  Created by Jesse Ruiz on 10/22/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    lazy var foodieContainer: NSPersistentContainer = {
        
        let foodieContainer = NSPersistentContainer(name: "Foodie")
        foodieContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        foodieContainer.viewContext.automaticallyMergesChangesFromParent = true
        return foodieContainer
    }()
    
    var foodieMainContext: NSManagedObjectContext {
        foodieContainer.viewContext
    }
    
    lazy var restaurantContainer: NSPersistentContainer = {
        
        let restaurantContainer = NSPersistentContainer(name: "Restaurant")
        restaurantContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        restaurantContainer.viewContext.automaticallyMergesChangesFromParent = true
        return restaurantContainer
    }()
    
    var restaurantMainContext: NSManagedObjectContext {
        restaurantContainer.viewContext
    }
    
    lazy var ReviewContainer: NSPersistentContainer = {
        
        let ReviewContainer = NSPersistentContainer(name: "Review")
        ReviewContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        ReviewContainer.viewContext.automaticallyMergesChangesFromParent = true
        return ReviewContainer
    }()
    
    var reviewMainContext: NSManagedObjectContext {
        ReviewContainer.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        
        context.performAndWait {
            
            do {
                try context.save()
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
}
