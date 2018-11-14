//
//  EventData.swift
//  RowTime
//
//  This object provides a list of events either from the call to the server or 
//  from a previously saved list.  Note this also loads the data into the tableview object
//  of the viewcontroller passed to the loadEvents method. 
//
//  TODO: Update to use CoreData instead of the UserData subsystem
//
//  Created by Paul Ventisei on 06/06/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
// - forcing a change

import Foundation
import CoreData

protocol UpdateableFromModel {
    func didUpdateModel()
    func willUpdateModel()
}

class EventData: NSObject {
    
    var events = [Event]()
    var status: Status? = nil
    enum Status {
        case empty, noLocalData, updatingCrewsFromRemoteServer, usingLocalData, usingRemoteData
    }
    var delegate : UpdateableFromModel? = nil
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    func loadEvents() {
        //PV: a method for loading Events from the local store.  If there is no local data then it will load from the internet and store in the local data store

        
        let managedContext = appDelegate.managedObjectContext
        
        
        // read all the events from CoreData if nil then set status
        // to "no local data"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : "CDEvent")
        
        do {
            if let cdEvents = try managedContext.fetch(fetchRequest) as? [CDEvent] {
                //got events so convert to datamodel format
                //TODO: should not be needed to convert if I use the core data for datamodel
                for event in cdEvents {
                    events.append(Event(fromCoreData: event))
                    self.status = .usingLocalData
                }
                if events.count == 0 {
                    self.status = .noLocalData
                }
            } // else the cdEvents returns nul - what to do here?
            
        } catch {
            self.status = .noLocalData
        }
        if status == .noLocalData {
            refreshEvents()
        }
    }
    
    func refreshEvents() {
        
        //empty the events array
        events = []
        
        // connect to the backend service for rowtime-26 using the Google App Engine Library
        
        let service = GTLRObservedtimesService()
        service.isRetryEnabled = true
        service.allowInsecureQueries = true
        
        let query = GTLRObservedtimesQuery_EventList.query()
        delegate?.willUpdateModel()
        
        service.executeQuery(query,
                             completionHandler: {[weak self]
            (ticket: GTLRServiceTicket?,
                        object: Any?,
                        error: Error?) -> Void in
                
            print("Analytics: \(object ?? String(describing:error))")

            if object != nil, error == nil {
                let resp = object as! GTLRObservedtimes_RowTimePackageEventList
                if resp.events != nil {
                    for event in resp.events! {
                        self!.events.append(Event(fromServerEvent: event ))
                        self!.updateCoreData(fromServerEvent: event)
                    }
                    print ("resp.events: \(String(describing: resp.events))")
                    
            } else { //object returned successfully but there are no events
                }
            }//object returned was nil or an error in the call
            
            self!.delegate?.didUpdateModel()
        })
        
    }
    
    func updateCoreData(fromServerEvent event: GTLRObservedtimes_RowTimePackageEvent) {
        //if the event provided is already in Core Data then replace it with the new version retrieved from the server.
        let managedContext = appDelegate.managedObjectContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : "CDEvent")
        let sortorder = NSSortDescriptor(key: "eventDate", ascending: false)
        let querystring = "eventId ='"+event.eventId!+"'"
        fetchRequest.predicate = NSPredicate(format: querystring)
        fetchRequest.sortDescriptors = [sortorder]
        do {
            if let cdEvents = try managedContext.fetch(fetchRequest) as? [CDEvent] {
                //check to see if any events were found
                if cdEvents.count >= 1 {
                    //found one so no need to replace
                    if cdEvents.count == 1 {
                        print("event already in database")
                        
                    }else{
                        print("error 20")
                    }
                } else {
                    //none there so insert
                    print("can insert here")
                    let eventRecordDef = NSEntityDescription.entity(forEntityName: "CDEvent", in: managedContext)
                    let newEvent = NSManagedObject(entity: eventRecordDef!, insertInto: managedContext) as! CDEvent
                    //newEvent.setValue(event.eventId, forKey: "eventId")
                    newEvent.eventId = event.eventId
                    newEvent.eventDesc = event.eventDesc
                    newEvent.eventDate = event.eventDate
                    newEvent.eventName = event.eventName
                    do {
                        try managedContext.save()
                    } catch {
                        print("Failed saving")
                    }
                }
            }
        } catch {
            //catch error
            print("error 10")
        }

        //TODO: if the server had deleted an event then consider how to deal with this.. there is no way to delete at the moment.
        
    }
    
}
