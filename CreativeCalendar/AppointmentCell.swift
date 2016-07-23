//
//  AppointmentCellTableViewCell.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AppointmentCell: UITableViewCell {
    @IBOutlet weak var appointmentTitle: UILabel!
    @IBOutlet weak var appointmentType: UILabel!
    @IBOutlet weak var appointmentStart: UILabel!
    @IBOutlet weak var appointmentEnd: UILabel!
    @IBOutlet weak var appointmentLocation: UILabel!
    @IBOutlet weak var appointmentAdditionalInfo: UILabel!
    @IBOutlet weak var appointmentCompletedImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Wrap the text from the additional information section as it could easily fit on more than one line.
        appointmentAdditionalInfo.lineBreakMode = NSLineBreakMode.ByWordWrapping
        appointmentAdditionalInfo.numberOfLines = 0
        
    }
    
    func appointmentCompleted(item: AppointmentItem){
        if item.completed == true{
            appointmentCompletedImage.image = UIImage(named:"CircleTickedGreen")
        }
        else{
            appointmentCompletedImage.image = UIImage(named:"CircleUntickedRed")

        }
        
    }
}
