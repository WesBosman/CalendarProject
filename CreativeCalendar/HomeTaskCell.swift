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
    @IBOutlet weak var homeTaskCompletionDate: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        homeTaskTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        homeTaskTitle.numberOfLines = 0
        homeTaskInfo.lineBreakMode = NSLineBreakMode.ByWordWrapping
        homeTaskInfo.numberOfLines = 0
    }
    func homeTaskCompleted(task: TaskItem){
        if task.completed == true{
            uncheckedTaskImage.image = UIImage(named: "checkbox")
        }
        else if task.completed == false && task.canceled == false && task.deleted == false{
            uncheckedTaskImage.image = UIImage(named: "EmptyBox")
        }
        else{
            uncheckedTaskImage.image = UIImage(named: "uncheckbox")
        }
    }
}
