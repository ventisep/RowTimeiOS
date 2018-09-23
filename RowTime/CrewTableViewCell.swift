//
//  CrewTableViewCell.swift
//  RowTime
//
//  Created by Paul Ventisei on 06/05/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
//

import UIKit

class CrewTableViewCell: UITableViewCell {

    // MARK: Properties
    

    @IBOutlet weak var crewNumber: UILabel!
    @IBOutlet weak var crewName: UILabel!
    @IBOutlet weak var crewOarImage: UIImageView!
    @IBOutlet weak var crewCategory: UILabel!
    @IBOutlet weak var crewTime: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
