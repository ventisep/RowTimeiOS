//
//  TimerViewController.swift
//  RowTime
//
//  Created by Paul Ventisei on 23/05/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
//

import UIKit

protocol InCellTextfieldProtocol {
    func didEndEditingCellTextfield(_ cell: TimeTableViewCell)
}

class TimerViewController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, InCellTextfieldProtocol {

    @IBOutlet weak var DigitalReadout: UILabel!
    @IBOutlet weak var CrewNumber: UITextField!
    @IBOutlet weak var CrewName: UILabel!
    

    @IBOutlet weak var TimeTable: UITableView!
    @IBOutlet weak var RecordButton: UIButton!
    
    let notificationCenter = NotificationCenter.default
    
    var eventId: String = ""
    var crew: Crew?
    var readOnly: Bool = false //passed from crew list view if crew selected
    
    var timeNow: String = "00:00:00.00" //String for the DigitalReadout
    var times = [RecordedTime]() //data for the TimeTableView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //handle the text fields through delegates
        
        CrewNumber.delegate = self
        
        if !readOnly {
            //set the readout to the curent time
            //set interval to keep Digital Readout up to date with current time
            updateTime()
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        
        } else {
            DigitalReadout.text = crew!.elapsedTime
            times = (crew!.recordedTimes!)
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @objc func updateTime(){
        //set the readout to the curent time
        let timeFormatForReadout = DateFormatter()
        timeFormatForReadout.dateFormat = "HH:mm:ss"
        timeNow = timeFormatForReadout.string(from: Date())
        DigitalReadout.text = timeNow
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view delegate and data source function protocols
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        //PV: updated to 1 section
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return times.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "TimeTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TimeTableViewCell
        
        //get the time record assigned to this cell
        let time = times[(indexPath as NSIndexPath).row]
        //print (" print: \(String(describing: time))")
        
        //update the cell properties using the times array
        
        if crew!.stages != nil{
            cell.crewStage.text = (crew!.stages![time.stage] as AnyObject).label
        }else {
            cell.crewStage.text = String(time.stage)
        }

        
        // if the crew number field is empty set up the highlight the textfield to be completed
        if time.crewNumber == nil {
            cell.crewNumberLabel.text = "Add Crew -->"
            cell.crewNumberInput.text = ""
            cell.crewNumberLabel.textColor = UIColor.red
            cell.crewNumberInput.borderStyle = UITextBorderStyle.roundedRect
        } else {
            cell.crewNumberInput.borderStyle = UITextBorderStyle.none
            cell.crewNumberInput.text = String(time.crewNumber!)
        }
        
        let timeFormat = DateFormatter()
        timeFormat.dateFormat = "HH:mm:ss.SSS"
        timeNow = timeFormat.string(from: time.time as Date)

        cell.crewTime.text = timeNow
        
        //update cell properties if observation type is 2 which means it is a cencelled time
        if time.obsType == 2{
            cell.backgroundColor = UIColor.gray
            cell.crewNumberLabel.text = "cancelled time"
        }else if time.obsType == 1{
            cell.backgroundColor = UIColor.white
            cell.crewNumberLabel.text = "cancel request"
        }else{
            cell.backgroundColor = UIColor.white
        }
        
        
        // Set a cell delegate for the fieldtext input
        if cell.delegate == nil {
            cell.delegate = self
        }
        return cell
    }
    
    //MARK: UITextFieldDelegate methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Hide the keyboard
        
        textField.resignFirstResponder()
        return true
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        notificationCenter.addObserver(
            self,
            selector: #selector(TimerViewController.textFieldTextChanged(_:)),
            name:NSNotification.Name.UITextFieldTextDidChange,
            object: textField)

        
    }
    
    @objc func textFieldTextChanged (_ notification: Notification) {
        
        let textField = notification.object as! UITextField
        
        if textField === CrewNumber {
            CrewName.text = "You chose crew \(String(describing: CrewNumber.text))"
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        notificationCenter.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
        
    }
    
    //MARK: InCellTextfieldProtocol functions.  called when the textfield inside one of the cells has been updated
    
    func didEndEditingCellTextfield(_ cell: TimeTableViewCell) {
        
        //get the index path for the cell updated and update the times array
        // MARK: TODO here is where to add the code to record the time if not already recorded. (add a status field to the RecordedTime class 
        let indexPathAtTap = TimeTable.indexPath(for: cell)
        if cell.crewNumberInput.text != "" {
            times[(indexPathAtTap! as NSIndexPath).row].crewNumber = Int(cell.crewNumberInput.text!)
        }else{
            times[(indexPathAtTap! as NSIndexPath).row].crewNumber = nil
        }
        print("got to cell delegate with index \(String(describing: indexPathAtTap))")
    }
    //MARK: Actions
    
    @IBAction func RecordTime(_ sender: UIButton) {
        // hide any keyboard
        CrewNumber.resignFirstResponder()
        
        //get the time the button was pressed for showing it in the readout
        let timeButtonPressed = Date()
        let timeFormatForReadout = DateFormatter()
        timeFormatForReadout.dateFormat = "HH:mm:ss.SSS"
        timeNow = timeFormatForReadout.string(from: timeButtonPressed)
        
        //Stop the clock counting and show the time just recorded, restart the Clock in 3 seconds after the freezing of it
        //MARK:  TODO put in the stop of the clock and set interval to restart it
        
        DigitalReadout.text = timeNow

    
        //Add a time to the times array and refresh the timeTableView
        
        recordTimeInTableAndServer(timeButtonPressed)
        
        //clear the crewNumber field to prevent accidental re-entry of same crew
        
        CrewNumber.text = ""
        
    }
    
    func recordTimeInTableAndServer(_ time: Date) {
        
        let recordedTime1 = RecordedTime(crewNumber: Int(CrewNumber.text!), eventId: eventId,  obsType: 0, stage: 0, time: time, timeId: "RC1", timestamp: "tis")
        
        times.insert(recordedTime1!, at: 0)
        
        let newIndexPath = IndexPath(row: 0, section: 0)
        TimeTable.insertRows(at: [newIndexPath], with: .bottom)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
