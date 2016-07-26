//
//  HomeAppointmentCell.swift
//  CreativeCalendar
//
//  Created by Wes on 5/16/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class HomeAppointmentCell: UITableViewCell {
    @IBOutlet weak var homeAppointmentTitle: UILabel!
    @IBOutlet weak var homeAppointmentImage: UIImageView!
    @IBOutlet weak var homeAppointmentStart: UILabel!
    @IBOutlet weak var homeAppointmentEnd: UILabel!
    @IBOutlet weak var homeAppointmentLocation: UILabel!
    @IBOutlet weak var homeAppointmentAdditional: UILabel!
    @IBOutlet weak var homeAppointmentCompletedImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        homeAppointmentTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        homeAppointmentTitle.numberOfLines = 0
        homeAppointmentAdditional.lineBreakMode = NSLineBreakMode.ByWordWrapping
        homeAppointmentAdditional.numberOfLines = 0
    }
    
    func appointmentCompleted(){
        homeAppointmentCompletedImage.image = UIImage(named:"CircleTickedGreen")
    }
    func appointmentNotCompleted(){
        homeAppointmentCompletedImage.image = UIImage(named:"CircleUntickedRed")
    }
}
