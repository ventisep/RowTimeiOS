//
//  CrewViewController.swift
//  RowTime
//
//  Created by Paul Ventisei on 02/05/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
//

import UIKit

class CrewViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //MARK: Properties
    
    
    /* This value is either passed by `CrewTableViewController` in `prepareForSegue(_:sender:)`
    or constructed as part of adding a new crew.
    */
    
    
    @IBOutlet weak var crewNameTextField: UITextField!
    @IBOutlet weak var crewOarImageField: UIImageView!
    @IBOutlet weak var crewNumberTextField: UITextField!
    @IBOutlet weak var crewScheduledTimeTextField: UITextField!
 

    @IBOutlet weak var crewCategoryPicker: UIPickerView!
    @IBOutlet var crewCategoryCollection: [UIPickerView]!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var crew: Crew?
    var pickerCategoryData: [[String]]?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field's user input through delegate callbacks
        
        crewNameTextField.delegate = self
        crewNumberTextField.delegate = self

        crewCategoryPicker?.delegate = self
        crewCategoryPicker?.dataSource = self
        
        pickerCategoryData = [[" ","W"],["NOV","IM1","IM2","IM3","J14","J15","J16","J18","ELI"],["1","2","3","4","8"],["X+","X-","+","-"]]
        
        
    }
  
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the Keyboard
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === crewNameTextField {
        crewNameTextField.text = "hello, it worked"
        } else if textField === crewNumberTextField {
            crewNumberTextField.text! = "105"
        }
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        //dismiss the picker if the user canceled
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary contains multiple representations of the image and this uses the original.
        let selectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //set the photoImageView to display the selcted image
        
        crewOarImageField.image = selectedImage
        
        dismiss(animated: true, completion: nil)

    }
    
    // MARK: UIPickerViewDelegate
    
    // The number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 4
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerCategoryData![component].count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        return pickerCategoryData![component][row]
    }
    
    // MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    /* this section stopped working after upgrade and migration to swift 3 - need to fix PV
        
        if saveButton === sender {

            let crewName = crewNameTextField.text
            let picFile = "bms.gif"
            let crewNumber = Int(crewNumberTextField.text!)
            let category = crewCategoryTextField.text
            let crewScheduledTime = crewScheduledTimeTextField.text
 
            //prepare the crew details to be passed to the CrewTableViewController after the unwind seque TODO: because these are not validated then the programme can crash here
         /*
            crew = Crew(eventId: "event", crewNumber: crewNumber!, division: 1, crewScheduledTime: crewScheduledTime!, crewName: crewName!, picFile: picFile, category: category!, rowerCount: 4, cox: false, rowerIds: ["Crew 104 rower 1", "Crew 104 rower 2", "Crew 104 rower 3", "Crew 104 rower 4"])
        */
        }
    */
    }
    
    // MARK: Actions
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        //Hide the Keyboard
        
        crewNameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        
        let imagePickerController = UIImagePickerController()
        
        //Only allow photos to be picked not taken
        imagePickerController.sourceType = .photoLibrary
        
        imagePickerController.delegate = self
        
        present(imagePickerController, animated: true, completion: nil)

    }
    
}

