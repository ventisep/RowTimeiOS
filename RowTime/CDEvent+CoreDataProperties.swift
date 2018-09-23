//
//  CDEvent+CoreDataProperties.swift
//  
//
//  Created by Paul Ventisei on 23/09/2018.
//
//

import Foundation
import CoreData


extension CDEvent {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDEvent> {
        return NSFetchRequest<CDEvent>(entityName: "CDEvent")
    }

    @NSManaged public var eventDate: String?
    @NSManaged public var eventDesc: String?
    @NSManaged public var eventId: String?
    @NSManaged public var eventImage: NSObject?
    @NSManaged public var eventName: String?
    @NSManaged public var crews: NSSet?
    @NSManaged public var stages: NSSet?

}

// MARK: Generated accessors for crews
extension CDEvent {

    @objc(addCrewsObject:)
    @NSManaged public func addToCrews(_ value: CDCrew)

    @objc(removeCrewsObject:)
    @NSManaged public func removeFromCrews(_ value: CDCrew)

    @objc(addCrews:)
    @NSManaged public func addToCrews(_ values: NSSet)

    @objc(removeCrews:)
    @NSManaged public func removeFromCrews(_ values: NSSet)

}

// MARK: Generated accessors for stages
extension CDEvent {

    @objc(addStagesObject:)
    @NSManaged public func addToStages(_ value: CDStage)

    @objc(removeStagesObject:)
    @NSManaged public func removeFromStages(_ value: CDStage)

    @objc(addStages:)
    @NSManaged public func addToStages(_ values: NSSet)

    @objc(removeStages:)
    @NSManaged public func removeFromStages(_ values: NSSet)

}
