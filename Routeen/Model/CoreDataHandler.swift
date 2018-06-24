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
    
    class func saveTask(name:String, date:String, isCompleted:Bool) -> Bool {
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
    
    class func fetchTask() -> [Task] {
        let context = getContext()
        var tasks:[Task] = []
        do {
            tasks = try context.fetch(Task.fetchRequest())
            return tasks
        } catch {
            return tasks
        }
    }
    
    class func completeTask(task: Task) -> Bool {
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
    
    class func completeAllTasks() -> Bool {
        let context = getContext()
        let tasks:[Task] = fetchTask()
        
        for task in tasks {
            if task.isCompleted {
                task.setValue(false, forKey: "isCompleted")
            } else {
                task.setValue(true, forKey: "isCompleted")
            }
        }
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteTask(task: Task) -> Bool {
        let context = getContext()
        context.delete(task)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func saveStreak(streak:Int, dateLastCompleted:String) -> Bool {
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "Streak", in: context)
        let manageObject = NSManagedObject(entity: entity!, insertInto: context)
        manageObject.setValue(streak, forKey: "streak")
        manageObject.setValue(dateLastCompleted, forKey: "dateLastCompleted")
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func deleteStreak(streak: Streak) -> Bool {
        let context = getContext()
        context.delete(streak)
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    class func fetchStreak() -> [Streak] {
        let context = getContext()
        var streaks:[Streak] = []
        do {
            streaks = try context.fetch(Streak.fetchRequest())
            return streaks
        } catch {
            return streaks
        }
    }
    
    class func alterStreak(streakObj: Streak, streak: Int, dateLastCompleted: String) -> Bool {
        if deleteStreak(streak: streakObj) && saveStreak(streak: streak, dateLastCompleted: dateLastCompleted) {
            return true
        } else {
            return false
        }
    }
}
