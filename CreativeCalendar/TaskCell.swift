//
//  TaskTableViewCell.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }
    
    func taskCompleted(task: TaskItem){
        if task.completed == true{
            taskImage.image = UIImage(named: "checkbox")
        }
        else{
            taskImage.image = UIImage(named: "uncheckbox")
        }
    }
}
