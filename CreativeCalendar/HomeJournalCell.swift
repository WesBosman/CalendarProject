//
//  HomeJournalCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 1/12/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit

class HomeJournalCell: UITableViewCell {
    
    @IBOutlet weak var journalImageView: UIImageView!
    @IBOutlet weak var journalTitle: UILabel!
    @IBOutlet weak var journalEntry: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTitle(title: String){
        journalTitle.text = "Journal Title: \(title)"
    }
    
    func setEntry(entry: String){
        journalEntry.lineBreakMode = .byWordWrapping
        journalEntry.text = "Journal Entry: \(entry)"
    }
    
    func setJournalImage(image: UIImage){
        journalImageView.image = image
    }

}
