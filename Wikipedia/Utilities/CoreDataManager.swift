//
//  CoreDataManager.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 13/05/2023.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    //MARK: Functions used to manage records
    
    //Records page record with given title, if not returns nil
    func returnPageTitled(title: String) -> Page?{
        let fetchRequest: NSFetchRequest<Page> = Page.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        let matchingItems = try? context.fetch(fetchRequest)
        
        guard let result = matchingItems else {
            return nil
        }
        
        return result.first
    }
    
    //Persists data into starage
    func persist() {
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
    
    //Deletes oldest page record in storage
    func deleteOldestRecord() {
        let fetchRequest: NSFetchRequest<Page> = Page.fetchRequest()
        fetchRequest.fetchLimit = 1
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "objectID", ascending: true)]
        
        let result = try? context.fetch(fetchRequest)
        if let result = result?.first {
            context.delete(result)
            persist()
        }
    }
    
    //Deletes all records via batch delete
    func deleteAll() {
        let request: NSFetchRequest<NSFetchRequestResult>
        request = NSFetchRequest(entityName: "Page")
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        let batchDelete = try? context.execute(deleteRequest) as? NSBatchDeleteResult
        
        guard let deleteResult = batchDelete?.result as? [NSManagedObjectID] else { return }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [context]
        )
        
    }
    
    //Fetches 10 (in our case all) records from presistent storage
    func fetchFromStorage() -> Array<Page> {
        let request: NSFetchRequest<Page> = Page.fetchRequest()
        
        request.fetchLimit = 10
        request.sortDescriptors = [NSSortDescriptor(key: "objectID", ascending: false)]
        
        guard let result = try? context.fetch(request) else { return [] }
        return result
    }
    
    //MARK: Initialiser
    private init() {
        persistentContainer = NSPersistentContainer(name: "Wikipedia")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize core data stack \(error)")
            }
        }
    }
}

