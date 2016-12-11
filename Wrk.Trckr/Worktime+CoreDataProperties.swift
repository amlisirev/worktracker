//
//  Worktime+CoreDataProperties.swift
//  Wrk.Trckr
//
//  Created by Sakari Ikonen on 12/12/2016.
//  Copyright © 2016 Sakari Ikonen. All rights reserved.
//

import Foundation
import CoreData


extension Worktime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Worktime> {
        return NSFetchRequest<Worktime>(entityName: "Worktime");
    }

    @NSManaged public var end: NSDate?
    @NSManaged public var start: NSDate?
    @NSManaged public var job: Jobtitle?

}
