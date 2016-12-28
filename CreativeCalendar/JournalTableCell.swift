//
//  JournalTableCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 12/27/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class JournalTableCell: UITableViewCell {
    @IBOutlet weak var journalImage: UIImageView!
    @IBOutlet weak var journalTitle: UILabel!
    @IBOutlet weak var journalEntry: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // Make the journal expandable
        journalEntry.lineBreakMode = .byWordWrapping
        journalEntry.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
