//
//  TodoRepository.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/29/24.
//

import CoreData

final class TodoRepository {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.persistenceController = persistenceController
    }
}

extension TodoRepository {
    func add(_ todo: Todo) {
        let context = persistenceController.taskContext()
        if let todoInfo = fetch(todo, in: context) {
            todoInfo.day = Date()
            todoInfo.time = Date()
        } else {
            create(todo, in: context)
        }
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("addTodo error: \(error)")
            }
        }
    }
    
    func update(_ todo: Todo) {
        let context = persistenceController.taskContext()
        if let savedPlace = fetch(todo, in: context) {
            savedPlace.seleted = todo.seleted
        }
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("update error: \(error)")
            }
        }
    }
    
    fileprivate func create(_ todo: Todo, in context: NSManagedObjectContext) {
        let place = TodoInfo(context: context)
        place.id = todo.id
        place.title = todo.title
        place.day = todo.day
        place.time = todo.time
        place.seleted = todo.seleted
    }
    
    func getTodos() -> [Todo] {
        return fetchAll().map {
            return Todo(todoInfo: $0)
        }
    }
}

extension TodoRepository {
    func selectedTodoRemove(_ todos: [Todo]) {
        let context = persistenceController.taskContext()
        
        for todo in todos {
            if let todoInfo = fetch(todo, in: context) {
                context.delete(todoInfo)
            }
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

extension TodoRepository {
    fileprivate func fetch(_ todo: Todo, in context: NSManagedObjectContext) -> TodoInfo? {
        let fetchRequest: NSFetchRequest<TodoInfo> = TodoInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [todo.id])
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("fetch TodoInfo error: \(error) ")
            return nil
        }
    }
    
    func fetchAll() -> [TodoInfo] {
        let fetchRequest: NSFetchRequest<TodoInfo> = TodoInfo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        
        do {
            return try persistenceController.viewContext.fetch(fetchRequest)
        } catch {
            print("fetch TodoInfo error: \(error)")
            return []
        }
    }
}
