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
    @IBOutlet weak var homeAppointmentSubtitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        homeAppointmentTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        homeAppointmentTitle.numberOfLines = 0
        homeAppointmentSubtitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        homeAppointmentSubtitle.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
