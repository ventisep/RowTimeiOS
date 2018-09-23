//
//  CDCrew+CoreDataProperties.swift
//  
//
//  Created by Paul Ventisei on 23/09/2018.
//
//

import Foundation
import CoreData


extension CDCrew {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDCrew> {
        return NSFetchRequest<CDCrew>(entityName: "CDCrew")
    }

    @NSManaged public var category: String?
    @NSManaged public var cox: NSNumber?
    @NSManaged public var crewName: String?
    @NSManaged public var crewNumber: NSNumber?
    @NSManaged public var crewScheduledTime: String?
    @NSManaged public var division: NSNumber?
    @NSManaged public var elapsedTime: NSDate?
    @NSManaged public var endTimeLocal: NSDate?
    @NSManaged public var inProgress: NSNumber?
    @NSManaged public var picFile: String?
    @NSManaged public var rowerCount: NSNumber?
    @NSManaged public var stage: NSNumber?
    @NSManaged public var event: CDEvent?
    @NSManaged public var rowers: NSSet?
    @NSManaged public var times: NSOrderedSet?

}

// MARK: Generated accessors for rowers
extension CDCrew {

    @objc(addRowersObject:)
    @NSManaged public func addToRowers(_ value: CDRower)

    @objc(removeRowersObject:)
    @NSManaged public func removeFromRowers(_ value: CDRower)

    @objc(addRowers:)
    @NSManaged public func addToRowers(_ values: NSSet)

    @objc(removeRowers:)
    @NSManaged public func removeFromRowers(_ values: NSSet)

}

// MARK: Generated accessors for times
extension CDCrew {

    @objc(insertObject:inTimesAtIndex:)
    @NSManaged public func insertIntoTimes(_ value: CDRecordedTime, at idx: Int)

    @objc(removeObjectFromTimesAtIndex:)
    @NSManaged public func removeFromTimes(at idx: Int)

    @objc(insertTimes:atIndexes:)
    @NSManaged public func insertIntoTimes(_ values: [CDRecordedTime], at indexes: NSIndexSet)

    @objc(removeTimesAtIndexes:)
    @NSManaged public func removeFromTimes(at indexes: NSIndexSet)

    @objc(replaceObjectInTimesAtIndex:withObject:)
    @NSManaged public func replaceTimes(at idx: Int, with value: CDRecordedTime)

    @objc(replaceTimesAtIndexes:withTimes:)
    @NSManaged public func replaceTimes(at indexes: NSIndexSet, with values: [CDRecordedTime])

    @objc(addTimesObject:)
    @NSManaged public func addToTimes(_ value: CDRecordedTime)

    @objc(removeTimesObject:)
    @NSManaged public func removeFromTimes(_ value: CDRecordedTime)

    @objc(addTimes:)
    @NSManaged public func addToTimes(_ values: NSOrderedSet)

    @objc(removeTimes:)
    @NSManaged public func removeFromTimes(_ values: NSOrderedSet)

}
