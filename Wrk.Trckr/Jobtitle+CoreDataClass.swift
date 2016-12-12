//
//  Jobtitle+CoreDataClass.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 12/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData

@objc(Jobtitle)
public class Jobtitle: NSManagedObject {

    
    func finishedWorktimes() -> [Worktime] {
        let context = managedObjectContext
        let searchBy = NSSortDescriptor(key: "start", ascending: false)
        let predicate = NSPredicate(format: "(job == %@) AND (end != nil)", self)
        let request = NSFetchRequest<Worktime>(entityName: "Worktime")
        request.sortDescriptors = [searchBy]
        request.predicate = predicate
        var results:[Worktime] = []
        do {
            results = try context!.fetch(request)
        } catch {
            print("fetch failed")
        }
        return results
    }
    
    func openWorktimes() -> [Worktime] {
        let context = managedObjectContext
        let searchBy = NSSortDescriptor(key: "start", ascending: false)
        let predicate = NSPredicate(format: "(job == %@) AND (end == nil)", self)
        let request = NSFetchRequest<Worktime>(entityName: "Worktime")
        request.sortDescriptors = [searchBy]
        request.predicate = predicate
        var results:[Worktime] = []
        do {
            results = try context!.fetch(request)
        } catch {
            print("fetch failed")
        }
        return results
    }
}
