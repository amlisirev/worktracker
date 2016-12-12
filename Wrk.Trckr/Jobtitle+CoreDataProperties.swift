//
//  Jobtitle+CoreDataProperties.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 12/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Jobtitle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Jobtitle> {
        return NSFetchRequest<Jobtitle>(entityName: "Jobtitle");
    }

    @NSManaged public var name: String?
    @NSManaged public var worktimes: NSOrderedSet?

}

// MARK: Generated accessors for worktimes
extension Jobtitle {

    @objc(insertObject:inWorktimesAtIndex:)
    @NSManaged public func insertIntoWorktimes(_ value: Worktime, at idx: Int)

    @objc(removeObjectFromWorktimesAtIndex:)
    @NSManaged public func removeFromWorktimes(at idx: Int)

    @objc(insertWorktimes:atIndexes:)
    @NSManaged public func insertIntoWorktimes(_ values: [Worktime], at indexes: NSIndexSet)

    @objc(removeWorktimesAtIndexes:)
    @NSManaged public func removeFromWorktimes(at indexes: NSIndexSet)

    @objc(replaceObjectInWorktimesAtIndex:withObject:)
    @NSManaged public func replaceWorktimes(at idx: Int, with value: Worktime)

    @objc(replaceWorktimesAtIndexes:withWorktimes:)
    @NSManaged public func replaceWorktimes(at indexes: NSIndexSet, with values: [Worktime])

    @objc(addWorktimesObject:)
    @NSManaged public func addToWorktimes(_ value: Worktime)

    @objc(removeWorktimesObject:)
    @NSManaged public func removeFromWorktimes(_ value: Worktime)

    @objc(addWorktimes:)
    @NSManaged public func addToWorktimes(_ values: NSOrderedSet)

    @objc(removeWorktimes:)
    @NSManaged public func removeFromWorktimes(_ values: NSOrderedSet)

}
