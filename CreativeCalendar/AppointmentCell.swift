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
    
    // Variables for programmatically creating this cell in a popover
    var appointmentTitleLabel = UILabel()
    var appointmentTypeLabel  = UILabel()
    var appointmentStartLabel = UILabel()
    var appointmentEndLabel   = UILabel()
    var appointmentLocLabel   = UILabel()
    var appointmentAddLabel   = UILabel()
    var appointmentAlertLabel = UILabel()
    var appointmentCompletedImageView = UIImageView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Wrap the text from the additional information section as it could easily fit on more than one line.
        appointmentAdditionalInfo.lineBreakMode = NSLineBreakMode.byWordWrapping
        appointmentAdditionalInfo.numberOfLines = 0
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
    
    // MARK - For Programmatically Generated Calendar Popover cell
    
    override init(style:UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        appointmentCompletedImageView.backgroundColor = UIColor.yellow
        appointmentTitleLabel.backgroundColor = UIColor.blue
        appointmentTypeLabel.backgroundColor  = UIColor.cyan
        appointmentStartLabel.backgroundColor = UIColor.darkGray
        appointmentEndLabel.backgroundColor   = UIColor.brown
        appointmentLocLabel.backgroundColor   = UIColor.green
        appointmentAddLabel.backgroundColor   = UIColor.magenta
        appointmentAlertLabel.backgroundColor = UIColor.orange
        
        self.contentView.addSubview(appointmentCompletedImageView)
        self.contentView.addSubview(appointmentTitleLabel)
        self.contentView.addSubview(appointmentTypeLabel)
        self.contentView.addSubview(appointmentStartLabel)
        self.contentView.addSubview(appointmentEndLabel)
        self.contentView.addSubview(appointmentLocLabel)
        self.contentView.addSubview(appointmentAddLabel)
        self.contentView.addSubview(appointmentAlertLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        appointmentCompletedImageView.frame = CGRect(x: 5.0, y: 5.0, width: 15.0, height: 20.0)
        appointmentTitleLabel.frame = CGRect(x: 20.0, y: 10.0, width: 250.0, height: 20.0)
        appointmentTypeLabel.frame  = CGRect(x: 20.0, y: 30.0, width: 100.0, height: 15.0)
        appointmentStartLabel.frame = CGRect(x: 20.0, y: 45.0, width: 100.0, height: 15.0)
        appointmentEndLabel.frame   = CGRect(x: 20.0, y: 60.0, width: 100.0, height: 15.0)
        appointmentLocLabel.frame   = CGRect(x: 20.0, y: 75.0, width: 100.0, height: 15.0)
        appointmentAddLabel.frame   = CGRect(x: 20.0, y: 90.0, width: 100.0, height: 15.0)
        appointmentAlertLabel.frame = CGRect(x: 20.0, y: 105.0, width: 100.0, height: 15.0)
        
    }
}
