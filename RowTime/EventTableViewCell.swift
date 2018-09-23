//
//  EventTableViewCell.swift
//  RowTime
//
//  Created by Paul Ventisei on 11/05/2016.
//  Copyright © 2016 Paul Ventisei. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    // MARK: Properties
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventDate: UILabel!
    @IBOutlet weak var eventShortDescription: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    var event_id: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
