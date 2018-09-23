//
//  TableViewCell.swift
//  RowTime
//
//  Created by Paul Ventisei on 23/05/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
//

import UIKit

class TimeTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    // MARK: Properties
    
    var delegate: InCellTextfieldProtocol?
    
    @IBOutlet weak var crewStage: UILabel!
    @IBOutlet weak var crewTime: UILabel!
    @IBOutlet weak var crewNumberLabel: UILabel!
    @IBOutlet weak var crewNumberInput: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        crewNumberInput.delegate = self
        print (" print: \(times)")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        // MARK: do not allow editing but we could enable slide to edit functionality here
        
        if crewNumberInput.text == "" {
            return true
        } else {
            return false
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if crewNumberInput.text != "" {
            crewNumberLabel.text = "Crew Number"
            crewNumberLabel.textColor = UIColor.black
            crewNumberInput.borderStyle = .none
            
            
        } else {
            
            crewNumberLabel.text = "Add Crew -->"
            crewNumberLabel.textColor = UIColor.red
            crewNumberInput.borderStyle = .roundedRect
            
        }
        
        // MARK: pass the data captured to the right part of the times array
        if let delegate = delegate { delegate.didEndEditingCellTextfield(self)}

        
    }


}
