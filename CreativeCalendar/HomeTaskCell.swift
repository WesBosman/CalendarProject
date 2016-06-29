//
//  HomeTaskCell.swift
//  CreativeCalendar
//
//  Created by Wes on 5/16/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class HomeTaskCell: UITableViewCell {
    @IBOutlet weak var uncheckedTaskImage: UIImageView!
    @IBOutlet weak var homeTaskTitle: UILabel!
    @IBOutlet weak var homeTaskInfo: UILabel!
//    var taskArray = DatabaseFunctions.sharedInstance.getAllTasks()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        homeTaskTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        homeTaskTitle.numberOfLines = 0
        homeTaskInfo.lineBreakMode = NSLineBreakMode.ByWordWrapping
        homeTaskInfo.numberOfLines = 0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func taskCompleted(t: TaskItem){
        uncheckedTaskImage.image = UIImage(named: "checkbox")
        homeTaskTitle.text = t.taskTitle
        homeTaskInfo.text = t.taskInfo
        
//        let strikeThroughLabel: NSMutableAttributedString = NSMutableAttributedString(string: t.taskTitle)
//        strikeThroughLabel.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, strikeThroughLabel.length))
//        homeTaskTitle.attributedText = strikeThroughLabel
    }
    
    func taskNotCompleted(t: TaskItem){
        uncheckedTaskImage.image = UIImage(named: "uncheckbox")
        homeTaskTitle.text = t.taskTitle
        homeTaskInfo.text = t.taskInfo
    }

}
