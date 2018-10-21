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
    
    var status = ""
    var crews: [Crew] = []
    var eventId: String? = nil
    var delegate: UpdateableFromModel?
    var lastTimestamp: String = "1990-01-01T00:00:00.000"  //first time set to old date to get everything
    var service : GTLRObservedtimesService? = nil
    
    func initialLoad(newEventId: String) {
        
        //set the eventId to the newEventId and then process an update of the model
        
        eventId = newEventId
        
        //PV: This method will get data from CoreData store if available and then
        // update it with data from the backend if there is a connection
        
        // first get the managed object context
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.managedObjectContext

 
        // read all the crews for the selected event from CoreData if nil then set status
        // to "no local data"
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName : "CDCrew")
        let querystring = "event.eventId ='"+eventId!+"'"
        fetchRequest.predicate = NSPredicate(format: querystring)
        do {
            crews = try managedContext.fetch(fetchRequest) as! [Crew]
        } catch {
            self.status = "no local data"
        }

        if crews == [] {
            status = "no local data"
            refreshCrews()
        }
    
    }
    
    //PV: a method for loading Crews from the Backend.  This refresh is a delta refresh.  If the crews and times
    // have already been loaded once (we know this if viewController.lastTimestamp is not nil) then we only load
    // times since the last request.  Crew are only retrieved the first time (this means we cannot add crews
    // half way through the race.  To change this we would have to put a lastTimestamp on the crew table.
    
    func refreshCrews() {
        
        delegate?.willUpdateModel()
        status = "updating crews"
        if service == nil {
            service = GTLRObservedtimesService()
            service?.isRetryEnabled = true
            service?.allowInsecureQueries = true
        }
        
        let query = GTLRObservedtimesQuery_CrewList.query()
        query.eventId = eventId
    
        _ = service!.executeQuery(query,
                                  completionHandler: {(ticket: GTLRServiceTicket?,
                                    object: Any?,
                                    error: Error?)-> Void in
            print("Analytics: \(String(describing: object)) or \(String(describing: error))")
            if object != nil { //the object has a return value
                let resp = object as! GTLRObservedtimes_RowTimePackageCrewList
                print ("resp.crews: \(String(describing: resp.crews))")
                if (error == nil && resp.crews != nil) {
                    //got the list now create array of Crew objects

                    for GLTCrew in resp.crews! {
                        print("Crew as GTL: \(GLTCrew)")
                        let crew = Crew(fromServerCrew: GLTCrew , eventId: resp.eventId!)
                        self.crews.append(crew)
                    }
                    self.delegate?.didUpdateModel()
                    self.refreshTimes()
            } else { //object received was 'nil' and so no data returned
                
            }
          }
        })
    }
    
    func refreshTimes() {
            
        // now we have the crews we can get the times
        delegate?.willUpdateModel()
        let timesquery = GTLRObservedtimesQuery_TimesListtimes.query()
        timesquery.eventId = eventId!
        timesquery.lastTimestamp = lastTimestamp
        
        if service == nil {
            service = GTLRObservedtimesService()
            service?.isRetryEnabled = true
            service?.allowInsecureQueries = true
        }
        _ = service!.executeQuery(timesquery,
                                  completionHandler:{
                                    (ticket: GTLRServiceTicket?, object: Any?, error: Error?)-> Void in
            print("Analytics: \(String(describing: object)) or \(String(describing: error))")
            if object != nil { //the object has a return value
                let resp2 : GTLRObservedtimes_RowTimePackageObservedTimeList = object as! GTLRObservedtimes_RowTimePackageObservedTimeList
                print ("resp2.times: \(String(describing: resp2.times))")
                //get the last timestamp.  to ensure we preserve the full 6 digit accuracy we get this from the original JSON message rather than the GTLDateTime contruct which both rounds to 3 decimal places and puts a "z" at the end which is not the string format the API needs
                if (resp2.lastTimestamp != nil){ self.lastTimestamp = resp2.jsonValue(forKey: "last_timestamp") as! String
                }
                if (error == nil && resp2.times != nil) {
                    //now we have the times we can process each one against the crews they belong to
                    
                    self.processTimes(resp2, crews: self.crews)
                    
                }
            }
            self.delegate?.didUpdateModel()
        } )
    }


    func processTimes(_ times: GTLRObservedtimes_RowTimePackageObservedTimeList, crews: [Crew]) {
        
        for time in times.times! {
            
            // find the crewnumber that matches time.crewNumber and process the time
            
            for crew in crews where crew.crewNumber == Int(truncating: time.crew!) {
                crew.processTime(time)
            }
        }
    }
}

