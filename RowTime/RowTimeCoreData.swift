//
//  RowTimeCoreData.swift
//  RowTime
//
//  Created by Paul Ventisei on 28/08/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
//

import Foundation
import CoreData


class RowTimeCoreData: NSObject {
    
    var status: String = "error"
    var errorNumber: Int = 0
    
    func initialLoad(_ viewController: CrewTableViewController, eventId: String) {
        
        //PV: This method will get all data from the server and refresh the CoreData
        // data store from scratch
        
        // first get the managed object context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext
        
        // Create the Entity record in Core Data and the Stages connected to it
        
        let event =  NSEntityDescription.entity(forEntityName: "CDEvent",
                                                        in:managedContext)
        let cdEvent = NSManagedObject(entity: event!,
                                      insertInto: managedContext) as! CDEvent
        
        cdEvent.eventId = viewController.eventId
        cdEvent.eventDesc = viewController.event.eventDesc
        cdEvent.eventImage = viewController.event.eventImage!
        cdEvent.eventName = viewController.event.eventName
        
        // read all the crews from the backend and load them into the CoreData
        // space.
        
        // read all the times from the backend and load them into the CoreData space.
        
        //PV: create a new Rowing Event in Core Data Storage


        
        //PV: fill the new Rowing Event with data

        
        let userDefaults = UserDefaults.standard
        
        // load previously saved data if it is there
        
        userDefaults.removeObject(forKey: (eventId)) //delete becasue it is corrupted
        
        let data = userDefaults.object(forKey: eventId) as? Data
        
        if data != nil {
            viewController.crews = NSKeyedUnarchiver.unarchiveObject(with: data!) as! [Crew]}
        
        
        viewController.tableView.reloadData()
    }
    
    //PV: a method for loading Crews and times from the Backend.  This refresh is a delta refresh.  If the crews and times
    // have already been loaded once (we know this if crewsFetched is set
    // if it is unset then we get crews
    // if it is set then we get the times and put a lastTimestamp on the crew table.
    
    func refresh(_ viewController: CrewTableViewController, eventId: String, sender: UIRefreshControl) {
        
        sender.beginRefreshing()
    
        let service = GTLRObservedtimesService()
        service.isRetryEnabled = true
        service.allowInsecureQueries = true
        var crewsFetched : Bool?
        let userDefaults = UserDefaults.standard
        var crews = [Crew]()
        
        if crewsFetched != nil {
            crews = viewController.crews  //set crews to current list
        } else {  //get crews
        
            let query = GTLRObservedtimesQuery_CrewList.query()
            query.eventId = viewController.eventId
            _ = service.executeQuery(query, completionHandler:
            {(ticket: GTLRServiceTicket, object: AnyObject!, error: NSError!)-> Void in
                    print("Analytics: \(object) or \(error)")
                    let resp = object as! GTLRObservedtimes_RowTimePackageCrewList
                print ("resp.crews: \(String(describing: resp.crews))")
                    if (error == nil && resp.crews != nil) {
                        //got the list now create array of Crew objects
                        
                        for GTLCrew in resp.crews! {
                            print("Crew as GTL: \(GTLCrew)")
                            let crew = Crew(fromServerCrew: GTLCrew, eventId: eventId)
                            crews.append(crew)
                        }
                        crewsFetched = true
                    }
                } as? GTLRServiceCompletionHandler)
        }// now we have set the callback to get the crews we can get the times when the callback is completed
     
        if crewsFetched != nil {

            let timesquery = GTLRObservedtimesQuery_TimesListtimes.query()
            timesquery.eventId = viewController.eventId
            timesquery.lastTimestamp = viewController.lastTimestamp
            
            _ = service.executeQuery(timesquery, completionHandler: {(ticket: GTLRServiceTicket, object: AnyObject, error: NSError!)-> Void in
                print("Analytics: \(object) or \(error)")
                let resp2 = object as! GTLRObservedtimes_RowTimePackageObservedTimeList
                print ("resp2.times: \(String(describing: resp2.times))")
                if (resp2.lastTimestamp != nil){ viewController.lastTimestamp = resp2.lastTimestamp!.stringValue}
                if (error == nil && resp2.times != nil) {
                    //now we have the times we can process each one against the crews they belong to
                    
                    self.processTimes(resp2, crews: crews)
                    viewController.crews = crews
                    
                    // create an Object to save to NSUserDefaults.  This has to be an NSData objects so convert my Crew object array to NSData
                    let data : Data = NSKeyedArchiver.archivedData(withRootObject: crews)
                    // save to NSUserDefaults with a key of the eventId, this is unique
                    userDefaults.set(data, forKey: eventId)
                    userDefaults.synchronize()
                }
                viewController.tableView.reloadData()
                } as? GTLRServiceCompletionHandler)
        }
        sender.endRefreshing()
    }
    
    func processTimes(_ times: GTLRObservedtimes_RowTimePackageObservedTimeList, crews: [Crew]) {
        
        for time in times.times! {
            
            // find the crewnumber that matches time.crewNumber and process the time
            
            for crew in crews where crew.crewNumber == Int(time.crew!) {
                crew.processTime(time)
            }
        }
}
}
