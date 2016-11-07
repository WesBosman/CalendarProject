//
//  JournalCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 9/1/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class JournalCell: UITableViewCell {
    
    @IBOutlet weak var journalCellTitle: UILabel!
    @IBOutlet weak var journalCellSubtitle: UILabel!
    @IBOutlet weak var journalCellImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let title = UILabel.init(frame: CGRect(x: 10.0, y: 10.0, width: self.frame.width, height: 20))
        self.contentView.addSubview(title)
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
