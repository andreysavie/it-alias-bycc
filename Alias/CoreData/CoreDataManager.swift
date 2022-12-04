//
//  CoreDataManager.swift
//  Alias
//
//  Created by Андрей Рыбалкин on 04.12.2022.
//

import UIKit
import CoreData

final class CoreDataManager {
        
    // MARK: PROPERTIES
    
    static let shared = CoreDataManager()
        
    var fetchedResultsController: NSFetchedResultsController<RecordTeamsEntity> {

        let fetchRequest: NSFetchRequest<RecordTeamsEntity> = RecordTeamsEntity.fetchRequest()

        let sortDescriptor = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.context, sectionNameKeyPath: nil, cacheName: "Master")

        do {
            try fetchedResultsController.performFetch()
        } catch let error{
            print(error.localizedDescription)
        }
        return fetchedResultsController
    }
    
    
        
    // MARK: METHODS
    
    public func saveRecord (winner: Team, looser: Team) {
        
        let context = self.fetchedResultsController.managedObjectContext
        let winnerTeam = TeamEntity(context: context)
        winnerTeam.name = winner.name
        winnerTeam.score = Int16(winner.score)
        winnerTeam.avatar = winner.avatar
        
        let looserTeam = TeamEntity(context: context)
        looserTeam.name = looser.name
        looserTeam.score = Int16(looser.score)
        looserTeam.avatar = looser.avatar
        
        let newRecord = RecordTeamsEntity(context: context)
        newRecord.winner = winnerTeam
        newRecord.looser = looserTeam
        newRecord.date = Date()
        
        CoreDataStack.shared.saveContext()
        
    }
}
