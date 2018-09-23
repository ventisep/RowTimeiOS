//
//  CDStage+CoreDataProperties.swift
//  
//
//  Created by Paul Ventisei on 23/09/2018.
//
//

import Foundation
import CoreData


extension CDStage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDStage> {
        return NSFetchRequest<CDStage>(entityName: "CDStage")
    }

    @NSManaged public var label: String?
    @NSManaged public var stageIndex: NSNumber?
    @NSManaged public var event: CDEvent?

}
