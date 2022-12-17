//
//  CoreDataStack.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 04.12.2022.
//

import Foundation
import CoreData

// MARK: - Core Data stack
class CoreDataStack {

    static var shared = CoreDataStack()

    lazy var context: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()

    var persistentContainer: NSPersistentContainer

    private init() {
        let container = NSPersistentContainer(name: "RecordTeamModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        self.persistentContainer = container
    }

    func saveContext () {

        guard context.hasChanges else { return }

        do {
            try context.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }

}
