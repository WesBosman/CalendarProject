//
//  HomeAppointmentCell.swift
//  CreativeCalendar
//
//  Created by Wes on 5/16/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class HomeAppointmentCell: UITableViewCell {
    @IBOutlet weak var homeAppointmentAlert: UILabel!
    @IBOutlet weak var homeAppointmentTitle: UILabel!
    @IBOutlet weak var homeAppointmentImage: UIImageView!
    @IBOutlet weak var homeAppointmentStart: UILabel!
    @IBOutlet weak var homeAppointmentEnd: UILabel!
    @IBOutlet weak var homeAppointmentLocation: UILabel!
    @IBOutlet weak var homeAppointmentAdditional: UILabel!
    @IBOutlet weak var homeAppointmentCompletedImage: UIImageView!
    @IBOutlet weak var homeAppointmentType: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        homeAppointmentTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        homeAppointmentTitle.numberOfLines = 0
        homeAppointmentAdditional.lineBreakMode = NSLineBreakMode.byWordWrapping
        homeAppointmentAdditional.numberOfLines = 0
    }
    
    func homeAppointmentCompleted(_ appointment:AppointmentItem){
        if appointment.completed == true{
            homeAppointmentCompletedImage.image = UIImage(named: "checkbox") //"CircleTickedGreen")
        }
        else if appointment.completed == false && appointment.canceled == false && appointment.deleted == false{
            homeAppointmentCompletedImage.image = UIImage(named: "EmptyBox") //"EmptyCircle")
        }
        else{
            homeAppointmentCompletedImage.image = UIImage(named: "uncheckbox") //"CircleUntickedRed")
        }
    }
}
