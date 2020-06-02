//
//  CoreDataManager.swift
//  Gyrus
//
//  Created by Robert Choe on 5/26/20.
//  Copyright © 2020 Robert Choe. All rights reserved.
//

import CoreData

class CoreDataManager: NSObject {
   
    // The Container we are going to be using consisting of our entities
    let container: NSPersistentContainer!
    
    override init() {
        container = NSPersistentContainer(name: "Gyrus")
        container.loadPersistentStores(completionHandler: {
            (storeDesc, error) in
            guard error == nil else {
                print(error?.localizedDescription as Any)
                return
            }
        })
        
        super.init()
    }
    
    fileprivate func save() {
        do {
            if self.container.viewContext.hasChanges {
                try self.container.viewContext.save()
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Dream-
    /**
        Adds a dream to core data
        - Parameters:
            - title: name of the dream
            - content: the content of the dream
            - relatedCategories: the categories this dream is related to
     */
    func addDream(title: String, content: String, relatedCategories: NSSet?) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Dream", in: self.container.viewContext) else  {
            fatalError("Could not find entity named Dream");
        }
        let dream = Dream(entity: entity, insertInto: self.container.viewContext)
        dream.title = title
        dream.content = content
        dream.relatedCategories = relatedCategories
        dream.date = Date()
        dream.id = UUID()
        save()
    }
    
    /**
        Fetches and returns all the dreams the user has had
        - Returns: all the dreams the user has had
     */
    func fetchAllDreams() -> [Dream] {
        let context = self.container.viewContext
        let request: NSFetchRequest<Dream> = Dream.fetchRequest()
        let sortByDate = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortByDate]
        var dreams: [Dream] = []
        
        do {
            for dream in try context.fetch(request) {
                dreams.append(dream)
            }
        } catch {
            fatalError("Failed to fetch all dreams")
        }
        
        return dreams
    }
   
    /**
        fetches a dream by id
        - Parameters:
            - id: UUID of the dream
        - Returns: the dream associated with that UUID
     */
    func fetchDream(byID id: UUID) -> Dream? {
        let context = self.container.viewContext
        let request: NSFetchRequest<Dream> = Dream.fetchRequest()
        let predicate = NSPredicate(format: "id= %@", id as CVarArg)
        request.predicate = predicate
        var dream: Dream? = nil
        
        do   {
            for result in try context.fetch(request) {
                dream = result
            }
        } catch {
            fatalError("could not find a dream with that ID")
        }
        
        return dream
    }
   
    /**
        deletes a dream
        - Parameters :
            - id: UUID of the dream
        - Returns: boolean value indicating success of delete
     */
    func deleteDream(byID id: UUID) -> Bool{
        let context = self.container.viewContext
        if let dream = self.fetchDream(byID: id) {
            context.delete(dream)
            return true
        } else {
           return false
        }
        save()
    }
    
   /**
        deletes all the dreams stored in the context
     */
    func deleteAllDreams() {
        let context = self.container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Dream.fetchRequest()
        let batchDeleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(batchDeleteRequest)
        } catch  {
            fatalError("Could not execute batch delete request")
        }
        save()
    }
    
    // MARK: Category-
    /**
        Adds a category to core data
        - Parameters:
            - name: the name of the category
     */
    func addCategory(name: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: "Category", in: self.container.viewContext) else  {
            fatalError("Could not find entity named Category");
        }
        
        let category = Category(entity: entity, insertInto: self.container.viewContext)
        category.name = name
        category.id = UUID()
        save()
    }
    
    /**
       Fetches and returns all the categories the user has had
       - Returns: all the categories the user has had
    */
    func fetchAllCategories() -> [Category] {
        let context = self.container.viewContext
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        var categories: [Category] = []
        
        do {
            for category in try context.fetch(request) {
                categories.append(category)
            }
        } catch {
            fatalError("Could not fetch all categories")
        }
        return categories
    }
    
    /**
        deletes a category
        - Parameters :
            - id: UUID of the category
        - Returns: boolean value indicating success of delete
     */
    func deleteCategory(byID id: UUID) -> Bool{
        let context = self.container.viewContext
        if let category = self.fetchCategory(byID: id) {
            context.delete(category)
            return true
        } else {
           return false
        }
        save()
    }
    
    /**
        fetches a category by id
        - Parameters:
            - id: UUID of the category
        - Returns: the category associated with that UUID
     */
    func fetchCategory(byID id: UUID) -> Category? {
        let context = self.container.viewContext
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        let predicate = NSPredicate(format: "id= %@", id as CVarArg)
        request.predicate = predicate
        var category: Category? = nil
        
        do   {
            for result in try context.fetch(request) {
                category = result
            }
        } catch {
            fatalError("could not find a dream with that ID")
        }
        return category
    }
    
    /**
         deletes all the categories stored in the context
    */
     func deleteAllCategories() {
         let context = self.container.viewContext
         let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
         let batchDeleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
         
         do {
             try context.execute(batchDeleteRequest)
         } catch  {
             fatalError("Could not execute batch delete request")
         }
        save()
     }
    
    // MARK: Alarm-
    /**
        Adds an alarm to core data
        - Parameters:
            - time: the time the alarm is set to
            - name: the name of the alarm
    */
    func addAlarm(time: Date, name: String) -> Alarm {
        guard let entity = NSEntityDescription.entity(forEntityName: "Alarm", in: self.container.viewContext) else  {
            fatalError("Could not find entity named Alarm");
        }
        
        let alarm = Alarm(entity: entity, insertInto: self.container.viewContext)
        alarm.time = time
        alarm.name = name
        alarm.id = UUID()
        save()
        return alarm
    }
    
    /**
       Fetches and returns the most recently added alarm
       - Returns: the most recently added alarm
    */
    func fetchAlarm() -> Alarm? {
        let context = self.container.viewContext
        let request: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        var alarms: [Alarm] = []
        do {
            for alarm in try context.fetch(request) {
                alarms.append(alarm)
            }
        } catch {
            fatalError("Failed to fetch all dreams")
        }
        // There should only be one alarm at a time
        return alarms[0]
    }
    
    /**
        deletes an alarm
        - Parameters :
            - id: UUID of the alarm
        - Returns: boolean value indicating success of delete
     */
    func deleteAlarm(byID id: UUID) -> Bool{
        let context = self.container.viewContext
        if let alarm = self.fetchAlarm() {
            context.delete(alarm)
            return true
        } else {
           return false
        }
        save()
    }
    
    /**
         deletes all the alarms stored in the context
    */
     func deleteAllAlarms() {
         let context = self.container.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Alarm")
         let batchDeleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
         
         do {
             try context.execute(batchDeleteRequest)
         } catch  {
             fatalError("Could not execute batch delete request")
         }
        save()
     }
        
}
