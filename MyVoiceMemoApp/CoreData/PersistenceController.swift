//
//  PersistenceController.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/27/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Model")
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    fileprivate func setBackgroundContext(_ context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        context.undoManager = nil
    }
    
    func taskContext() -> NSManagedObjectContext {
        let taskContext = container.newBackgroundContext()
        setBackgroundContext(taskContext)
        
        return taskContext
    }
    
    func performBackgroundTask(task: @escaping (NSManagedObjectContext) -> Void) {
        container.performBackgroundTask { (context) in
            self.setBackgroundContext(context)
            task(context)
        }
    }
}
