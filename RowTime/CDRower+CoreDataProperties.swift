//
//  CDRower+CoreDataProperties.swift
//  
//
//  Created by Paul Ventisei on 23/09/2018.
//
//

import Foundation
import CoreData


extension CDRower {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRower> {
        return NSFetchRequest<CDRower>(entityName: "CDRower")
    }

    @NSManaged public var club: String?
    @NSManaged public var email: String?
    @NSManaged public var pic: NSData?
    @NSManaged public var rowerId: String?
    @NSManaged public var rowerName: String?
    @NSManaged public var crew: NSSet?

}

// MARK: Generated accessors for crew
extension CDRower {

    @objc(addCrewObject:)
    @NSManaged public func addToCrew(_ value: CDCrew)

    @objc(removeCrewObject:)
    @NSManaged public func removeFromCrew(_ value: CDCrew)

    @objc(addCrew:)
    @NSManaged public func addToCrew(_ values: NSSet)

    @objc(removeCrew:)
    @NSManaged public func removeFromCrew(_ values: NSSet)

}
