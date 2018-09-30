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

class EventData: NSObject {
    
    var events : [Event] = [Event]()

    func loadEvents(delegate: EventTableViewController) {
        //PV: a method for loading Events from the internet server if available
        // if not successful it will set the status to .
        // get user defaults to store the event list in
        let userDefaults = UserDefaults.standard
        
        // connect to the backend service for rowtime-26 using the Google App Engine Library
        
        let service = GTLRObservedtimesService()
        service.isRetryEnabled = true
        service.allowInsecureQueries = true
        
        let query = GTLRObservedtimesQuery_EventList.query()

        service.executeQuery(query, completionHandler: {[weak self] (ticket: GTLRServiceTicket?, object: Any?, error: Error?) -> Void in
            print("Analytics: \(object ?? String(describing:error))")
            if object != nil, error == nil {
                let resp = object as! GTLRObservedtimes_RowTimePackageEventList
                if resp.events != nil {
                    for event in resp.events! {
                        self?.events.append(Event(fromServerEvent: event ))
                    }
                    print ("resp.events: \(String(describing: resp.events))")
                    
                    // Archive it to NSData
                    let data = NSKeyedArchiver.archivedData(withRootObject: self!.events)
                    userDefaults.set(data, forKey: "Events")
                    userDefaults.synchronize()
                } else { //there were no events so take from local data
                    let data = userDefaults.object(forKey: "Events") as! Data
                    self?.events = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Event]
                }
            } else { //object returned is nil - no events returned from the server but no error so take from local data
                let data = userDefaults.object(forKey: "Events") as! Data
                self?.events = NSKeyedUnarchiver.unarchiveObject(with: data) as! [Event]
            }
            delegate.refreshFromModel()
        })
        
    }
    
}
