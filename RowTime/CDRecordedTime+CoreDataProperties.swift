//
//  CDRecordedTime+CoreDataProperties.swift
//  
//
//  Created by Paul Ventisei on 23/09/2018.
//
//

import Foundation
import CoreData


extension CDRecordedTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDRecordedTime> {
        return NSFetchRequest<CDRecordedTime>(entityName: "CDRecordedTime")
    }

    @NSManaged public var crewNumber: NSNumber?
    @NSManaged public var eventId: String?
    @NSManaged public var obsType: NSNumber?
    @NSManaged public var stage: NSNumber?
    @NSManaged public var time: NSDate?
    @NSManaged public var timeId: String?
    @NSManaged public var timestamp: String?
    @NSManaged public var crew: CDCrew?

}
