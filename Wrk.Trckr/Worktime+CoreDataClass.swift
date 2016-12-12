//
//  Worktime+CoreDataClass.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 12/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import Foundation
import CoreData

@objc(Worktime)
public class Worktime: NSManagedObject {

    class func openWorktimes(context: NSManagedObjectContext) -> [Worktime] {
        let sortByStart = NSSortDescriptor(key: "start", ascending: false)
        let searchByOngoing = NSPredicate(format: "end == nil")
        let requestForBatch: NSFetchRequest<Worktime> = Worktime.fetchRequest()
        
        requestForBatch.predicate = searchByOngoing
        requestForBatch.sortDescriptors = [sortByStart]
        var results: [Worktime] = []
        
        do {
            results = try context.fetch(requestForBatch)
        } catch {
            print("fetch failed")
        }
        return results
    }
    
    func duration() -> TimeInterval {
        var elapsed = 0.00
        if end != nil {
            elapsed = end!.timeIntervalSince(start! as Date)
        }
        return elapsed
    }
}
