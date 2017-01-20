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
    @IBOutlet weak var homeRepeatLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        homeAppointmentTitle.lineBreakMode = NSLineBreakMode.byWordWrapping
        homeAppointmentAdditional.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        homeAppointmentAdditional.numberOfLines = 0
        homeAppointmentTitle.numberOfLines = 0
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
    
    func setTitle(title: String){
        homeAppointmentTitle.text = "Appointment: \(title)"
    }
    
    func setType(type: String){
        homeAppointmentType.text = "Type: \(type)"
    }
    
    func setStart(start: String){
        homeAppointmentStart.text = "Start: Today at \(start)"
    }
    
    func setEnd(end: String){
        homeAppointmentEnd.text = "End: Today at \(end)"
    }
    
    func setLocation(location: String){
        homeAppointmentLocation.text = "Location: \(location)"
    }
    
    func setAdditional(additional: String){
        homeAppointmentAdditional.numberOfLines = 0
        homeAppointmentAdditional.lineBreakMode = .byWordWrapping
        homeAppointmentAdditional.text = "Additional info: \(additional)"
    }
    
    func setAlert(alert: String){
        homeAppointmentAlert.text = "Alert: \(alert)"
    }
    
    func setRepeat(repeating: String){
        homeRepeatLabel.text = "Repeat: \(repeating)"
    }
}
