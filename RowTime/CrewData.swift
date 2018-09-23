//
//  CrewDataGetter.swift
//  RowTime
//
//  Created by Paul Ventisei on 07/06/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
//

import Foundation
import CoreData


class CrewData: NSObject {
    
    var status: String = "error"
    var errorNumber: Int = 0
    var cdCrews: [CDCrew] = []
    
    func initialLoad(_ viewController: CrewTableViewController, eventId: String) {
        
        //PV: This method will get data from CoreData store if available and then
        // update it with data from the backend if there is a connection
        
        // first get the managed object context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

 
        // read all the crews for the selected event from CoreData if nil then set status
        // to "no local data"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : "CDCrew")
        let querystring = "event.eventId ='"+viewController.eventId+"'"
        fetchRequest.predicate = NSPredicate(format: querystring)
        do {
            cdCrews = try managedContext.fetch(fetchRequest) as! [CDCrew]
        } catch {
            self.status = "no local data"
        }

        if cdCrews == [] {

            let rc: UIRefreshControl = viewController.refreshControl!
            self.refresh(viewController, eventId: eventId, sender: rc)
        }
        

        viewController.tableView.reloadData()
    }
    
    //PV: a method for loading Crews from the Backend.  This refresh is a delta refresh.  If the crews and times
    // have already been loaded once (we know this if viewController.lastTimestamp is not nil) then we only load
    // times since the last request.  Crew are only retrieved the first time (this means we cannot add crews
    // half way through the race.  To change this we would have to put a lastTimestamp on the crew table.
    
    func refresh(_ viewController: CrewTableViewController, eventId: String, sender: UIRefreshControl) {
        
        sender.beginRefreshing()
        let userDefaults = UserDefaults.standard
        var crews: [Crew] = [Crew]()
        var firstTime: Bool = false
        if viewController.lastTimestamp == "1990-01-01T00:00:00.000" {firstTime = true} else {firstTime = false}
        
        if !firstTime {
            crews = viewController.crews  //set crews to current list
        }

        
        var service : GTLRObservedtimesService? = nil
        if service == nil {
            service = GTLRObservedtimesService()
            service?.isRetryEnabled = true
            service?.allowInsecureQueries = true
        }
        
        let query = GTLRObservedtimesQuery_CrewList.query()
        query.eventId = viewController.eventId
    
        _ = service!.executeQuery(query, completionHandler: {(ticket: GTLRServiceTicket?, object: Any?, error: Error?)-> Void in
            print("Analytics: \(String(describing: object)) or \(String(describing: error))")
            if object != nil { //the object has a return value
                let resp = object as! GTLRObservedtimes_RowTimePackageCrewList
                print ("resp.crews: \(String(describing: resp.crews))")
                if (error == nil && resp.crews != nil) {
                    //got the list now create array of Crew objects

                    for GLTCrew in resp.crews! {
                        print("Crew as GTL: \(GLTCrew)")
                        let crew = Crew(fromServerCrew: GLTCrew , eventId: eventId)
                        crews.append(crew)
                    }

                    // now we have the crews we can get the times
                    let timesquery = GTLRObservedtimesQuery_TimesListtimes.query()
                    timesquery.eventId = viewController.eventId
                    timesquery.lastTimestamp = viewController.lastTimestamp
                    
                    _ = service!.executeQuery(timesquery, completionHandler: {(ticket: GTLRServiceTicket?, object: Any?, error: Error?)-> Void in
                        print("Analytics: \(String(describing: object)) or \(String(describing: error))")
                        let resp2 : GTLRObservedtimes_RowTimePackageObservedTimeList = object as! GTLRObservedtimes_RowTimePackageObservedTimeList
                        print ("resp2.times: \(String(describing: resp2.times))")
                        if (resp2.lastTimestamp != nil){ viewController.lastTimestamp = (resp2.lastTimestamp?.stringValue)!}
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
                    } )
                }
            } else { //object received was 'nil' and so no data returned
                
            }

        } )
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

