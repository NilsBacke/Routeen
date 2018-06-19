//
//  CoreDataHandler.swift
//  Routeen
//
//  Created by Nils Backe on 6/15/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
    
    private class func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    class func saveObject(name:String, date:String, isCompleted:Bool) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Task", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        manageObject.setValue(name, forKey: "name")
        manageObject.setValue(date, forKey: "date")
        manageObject.setValue(isCompleted, forKey: "isCompleted")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchObject() -> [Task] {
        let context = getContext()
        var tasks:[Task] = []
        do {
            tasks = try context.fetch(Task.fetchRequest())
            return tasks
        } catch {
            return tasks
        }
    }
    
    class func completeObject(task: Task) -> Bool {
        let context = getContext()
        if task.isCompleted {
            task.setValue(false, forKey: "isCompleted")
        } else {
            task.setValue(true, forKey: "isCompleted")
        }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteObject(task: Task) -> Bool {
        let context = getContext()
        context.delete(task)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
}
