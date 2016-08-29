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
    @IBOutlet weak var appointmentAlert: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Wrap the text from the additional information section as it could easily fit on more than one line.
        appointmentAdditionalInfo.lineBreakMode = NSLineBreakMode.ByWordWrapping
        appointmentAdditionalInfo.numberOfLines = 0
    }
    
    func appointmentCompleted(appointment: AppointmentItem){
        if appointment.completed == true{
            appointmentCompletedImage.image = UIImage(named: "CircleTickedGreen")
        }
        else if appointment.completed == false && appointment.canceled == false && appointment.deleted == false{
            appointmentCompletedImage.image = UIImage(named: "EmptyCircle")
        }
        else{
            appointmentCompletedImage.image = UIImage(named: "CircleUntickedRed")
        }
    }
}
