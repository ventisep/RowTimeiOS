//
//  EventTableViewController.swift
//  RowTime
//
//  Created by Paul Ventisei on 11/05/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {

    // MARK: Properties
    
    var events: [Event] = [Event]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        let eventData = EventData()
        eventData.loadEvents(self)
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //PV: updated to 1 section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        // PV: updated to count of rows in the events array
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        
        let cellIdentifier = "EventTableViewCell"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! EventTableViewCell

        // Fetches the appropriate crew for the data source layout.
        let event = events[(indexPath as NSIndexPath).row]
        
        cell.event_id = event.eventId
        cell.eventName.text = event.eventName
        cell.eventImage.image = nil
        cell.eventDate.text = String(event.eventDate)
        cell.eventShortDescription.text = event.eventDesc

        return cell
    }
    
    // MARK: Add Button

    @IBAction func pressedAddButton(_ sender: AnyObject) {
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowCrews" {
            
            let crewTableViewController = segue.destination as! CrewTableViewController
            
            // Get the cell that generated this segue.
            if let selectedEventCell = sender as? EventTableViewCell {
                
                let indexPath = tableView.indexPath(for: selectedEventCell)!
                let selectedEvent = events[(indexPath as NSIndexPath).row].eventId
            
            crewTableViewController.eventId = selectedEvent
            crewTableViewController.event = events[(indexPath as NSIndexPath).row]

            }
        }
        else if segue.identifier == "AddItem" {
            
            print("Adding new event.")
        }
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
