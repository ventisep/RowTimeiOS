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
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        //        if let context = UIGraphicsGetCurrentContext(){
        //            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY),
        //                           radius: 100.0,
        //                           startAngle: 0,
        //                           endAngle: 2*CGFloat.pi,
        //                           clockwise: true)
        //            context.setLineWidth(5.0)
        //            UIColor.green.setFill()
        //            UIColor.red.setStroke()
        //            context.strokePath()
        //            context.fillPath()
        //
        //        }
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        //        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY),
        //                    radius: 100.0,
        //                    startAngle: 0,
        //                    endAngle: 2*CGFloat.pi,
        //                    clockwise: true)
        //        path.lineWidth = 5.0
        //        UIColor.green.setFill()
        //        UIColor.red.setStroke()
        //        path.stroke()
        //        path.fill()
        
    }

}
