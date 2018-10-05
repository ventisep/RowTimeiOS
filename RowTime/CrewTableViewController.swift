//
//  CrewTableViewController.swift
//  RowTime
//
//  Created by Paul Ventisei on 08/05/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
//

import UIKit
import CoreData

class CrewTableViewController: UITableViewController, UISearchResultsUpdating, UpdateableFromModel{

    
    
    // MARK: Properties
    
    var event: Event  = Event(fromNil: nil)!
   // var crews = [Crew]() //TODO - not sure I need this
    var filteredCrews = [Crew]()
    var times = GTLRObservedtimes_RowTimePackageObservedTimeList()
    var eventId = ""
    var filterOn: Bool = false

    var searchController = UISearchController.init(searchResultsController: nil)
    
    let crewData: CrewData = CrewData()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        crewData.delegate = self
        
        // Set up the search controller

        searchController.dimsBackgroundDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false;
        searchController.searchBar.sizeToFit()
        searchController.delegate = self as? UISearchControllerDelegate
        
        tableView.tableHeaderView = searchController.searchBar;
        tableView.delegate = self
        
        definesPresentationContext = true

        crewData.initialLoad(eventId: self.eventId)
    }



    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UISearchResultsUpdating protocol conformance
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let searchString = self.searchController.searchBar.text
        //let buttonIndex = searchController.searchBar.selectedScopeButtonIndex
        
        if searchString != "" {
            filterOn = true
            filteredCrews.removeAll(keepingCapacity: true)
            
            let searchFilter: (Crew) -> Bool = { crew in
                if crew.crewName.contains(searchString!) {
                    return true
                } else {
                    return false
                }
            }
            
            filteredCrews = crewData.crews.filter(searchFilter)
            
        } else {
            filterOn = false
        }

        
        self.tableView.reloadData()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        // PV: updated to 1 section
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // PV: updated to count of rows in the crews array
        if filterOn{
            return filteredCrews.count
        } else {
            return crewData.crews.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "CrewTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CrewTableViewCell
        
        // Fetches the appropriate crew for the data source layout.
        var crew = crewData.crews[(indexPath as NSIndexPath).row]
        if filterOn {
            crew = filteredCrews[(indexPath as NSIndexPath).row]
        }
        cell.crewName.text = crew.crewName
        cell.crewOarImage.image = UIImage(named: crew.picFile!)
        cell.crewCategory.text = crew.category
        cell.crewNumber.text = String(crew.crewNumber)
        cell.crewTime.text = crew.elapsedTime

        return cell
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowTimes" {
        
            let timerViewController = segue.destination as! TimerViewController
            
            // Get the cell that generated this segue.
            if let selectedCrewCell = sender as? CrewTableViewCell {
            
                let indexPath = tableView.indexPath(for: selectedCrewCell)!
                if filterOn {
                    timerViewController.crew = filteredCrews[(indexPath as NSIndexPath).row]
                } else {
                    timerViewController.crew = crewData.crews[(indexPath as NSIndexPath).row]
                }

                timerViewController.readOnly = true
                timerViewController.eventId = eventId
            }
        }
    }
    
    @IBAction func unwindToCrewList(_ sender: UIStoryboardSegue){
        if sender.identifier == "addCrew" {
            if let sourceViewController = sender.source as?CrewViewController, let crew = sourceViewController.crew{
                
                // Add a new crew.
                let newIndexPath = IndexPath(row: crewData.crews.count, section: 0)
                crewData.crews.append(crew)
                tableView.insertRows(at: [newIndexPath], with: .bottom)
            }
        }
    }
    
    @IBAction func RefreshControl(_ sender: UIRefreshControl, forEvent event: UIEvent) {
        
        //refresh the crew data by using the crewData object and calling its refresh method
        
        UpdateFromModel()
    }
    
    private func UpdateFromModel(){
        //a method to update the data on the screen from the model crewdata model.
        crewData.refreshTimes(eventId: self.eventId)
    }
    
    @IBAction func Sort(_ sender: UIBarButtonItem) {
        // var menustyle = UIAlertActionStyle(rawValue: 1)
        // let menu = UIAlertAction(title: "menu", style: menustyle!, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
    }
    
    func didUpdateModel() {
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    func willUpdateModel() {
        refreshControl?.beginRefreshing()
    }
}

