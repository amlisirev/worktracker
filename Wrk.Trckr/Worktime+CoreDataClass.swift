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
    
    class func worktimesForJobAndDates(_ context: NSManagedObjectContext, jobs: [Jobtitle], startDate: NSDate, endDate: NSDate) -> [Worktime] {
        let sortBy = NSSortDescriptor(key: "start", ascending: false)
        let searchByJobs = NSPredicate(format: "(job IN %@)", jobs)
        let searchByStart = NSPredicate(format: "start >= %@", dateAtMidnight(startDate, startOfDay: true))
        let searchByEnd = NSPredicate(format: "end <= %@", dateAtMidnight(endDate, startOfDay: false))
        let compoundSearch = NSCompoundPredicate(andPredicateWithSubpredicates: [searchByJobs,searchByStart, searchByEnd])
        let request: NSFetchRequest<Worktime> = Worktime.fetchRequest()
        request.sortDescriptors = [sortBy]
        request.predicate = compoundSearch
        var work: [Worktime] = []
        do {
            work = try context.fetch(request)
        } catch {
            print("fetching worktimes failed")
        }
        return work
    }
    
    class func dateAtMidnight(_ date: NSDate!, startOfDay: Bool) -> NSDate {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day], from: date as Date)
        
        components.hour = startOfDay ? 00 : 23
        components.minute = startOfDay ? 00 : 59
        components.second = startOfDay ? 00 : 59
        
        let newdate = calendar.date(from: components)! as NSDate
        return newdate
    }
}
