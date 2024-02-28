//
//  MemoRepository.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/28/24.
//

import CoreData

class MemoRepository {
    let persistenceController: PersistenceController
    
    init(persistenceController: PersistenceController = PersistenceController.shared) {
        self.persistenceController = persistenceController
    }
    
    func add(_ memo: Memo) {
        let context = persistenceController.taskContext()
        if let memoInfo = fetch(memo, in: context) {
            memoInfo.date = Date()
        } else {
            create(memo, in: context)
        }
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("addPlace error: \(error)")
            }
        }
    }
    
    func remove(_ memo: Memo) {
        let context = persistenceController.taskContext()
        let fetchRequest: NSFetchRequest<MemoInfo> = MemoInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [memo.id])
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object)
            }
            try context.save()
        } catch {
            print("remove error: \(error)")
        }
    }
    
    func selectedMemoRemove(_ memos: [Memo]) {
        let context = persistenceController.taskContext()
        
        for memo in memos {
            if let memoInfo = fetch(memo, in: context) {
                    context.delete(memoInfo)
                }
            }
            
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
    }
    
    func update(_ memo: Memo) {
        let context = persistenceController.taskContext()
        if let savedPlace = fetch(memo, in: context) {
            savedPlace.date = Date()
            savedPlace.content = memo.content
            savedPlace.title = memo.title
        }
        
        context.performAndWait {
            do {
                try context.save()
            } catch {
                print("addPlace error: \(error)")
            }
        }
    }
    
    fileprivate func fetch(_ memo: Memo, in context: NSManagedObjectContext) -> MemoInfo? {
        let fetchRequest: NSFetchRequest<MemoInfo> = MemoInfo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", argumentArray: [memo.id])
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("fetch for update MmeoInfo error: \(error)")
            return nil
        }
    }
    
    func fetchAll() -> [MemoInfo] {
        let fetchRequest: NSFetchRequest<MemoInfo> = MemoInfo.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            return try persistenceController.viewContext.fetch(fetchRequest)
        } catch {
            print("fetch MemoInfo error: \(error)")
            return []
        }
    }
    
    fileprivate func create(_ memo: Memo, in context: NSManagedObjectContext) {
        let place = MemoInfo(context: context)
        place.id = memo.id
        place.title = memo.title
        place.content = memo.content
        place.date = memo.date
    }
    
    func getMemos() -> [Memo] {
        return fetchAll().map {
            return Memo(memoInfo: $0)
        }
    }
}
