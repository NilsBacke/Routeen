//
//  CoreDataHelper.swift
//  Routeen
//
//  Created by Noah Woodward on 6/10/18.
//  Copyright © 2018 Nils Backe. All rights reserved.
//

import Foundation
import UIKit
import CoreData

struct CoreDataHelper {
    static let context: NSManagedObjectContext = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError()
        }
        
        let persistentContainer = appDelegate.persistentContainer
        let context = persistentContainer.viewContext
        
        return context
    }()
}
