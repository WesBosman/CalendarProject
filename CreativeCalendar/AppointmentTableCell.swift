//
//  AppointmentTableCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 12/27/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AppointmentTableCell: UITableViewCell {
    
    @IBOutlet weak var appointmentImage: UIImageView!
    @IBOutlet weak var appointmentCompletedImage: UIImageView!
    @IBOutlet weak var appointmentTitle: UILabel!
    @IBOutlet weak var appointmentType: UILabel!
    @IBOutlet weak var appointmentStart: UILabel!
    @IBOutlet weak var appointmentEnd: UILabel!
    @IBOutlet weak var appointmentAlert: UILabel!
    @IBOutlet weak var appointmentLocation: UILabel!
    @IBOutlet weak var appointmentAdditionalInfo: UILabel!
    @IBOutlet weak var appointmentRepeat: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func appointmentCompleted(_ appointment: AppointmentItem){
        if appointment.completed == true{
            appointmentCompletedImage.image = UIImage(named: "checkbox") //"CircleTickedGreen")
        }
        else if appointment.completed == false && appointment.canceled == false && appointment.deleted == false{
            appointmentCompletedImage.image = UIImage(named: "EmptyBox") //"EmptyCircle")
        }
        else{
            appointmentCompletedImage.image = UIImage(named: "uncheckbox") //"CircleUntickedRed")
        }
    }
    
    func setTitle(title: String){
        appointmentTitle.text = "Appointment: \(title)"
    }
    
    func setType(type: String){
        appointmentType.text = "Type: \(type)"
    }
    
    func setStart(start: String){
        appointmentStart.text = "Start: \(start)"
    }
    
    func setEnd(end: String){
        appointmentEnd.text = "End:   \(end)"
    }
    
    func setLocation(location: String){
        appointmentLocation.text = "Location: \(location)"
    }
    
    func setAlert(alert: String){
        appointmentAlert.text = "Alert: \(alert)"
    }
    
    func setRepeat(rep: String){
        appointmentRepeat.text = "Repeat: \(rep)"
    }
    
    func setAdditional(additional: String){
        appointmentAdditionalInfo.text = "Additional Info: \(additional)"
    }

}
