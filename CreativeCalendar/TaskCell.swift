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
    @IBOutlet weak var taskCompletionDate: UILabel!
    @IBOutlet weak var taskAdditional: UILabel!
    @IBOutlet weak var taskRepeating: UILabel!
    
    
    @IBOutlet weak var taskAlert: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
    }
    
    func taskCompleted(_ task: TaskItem){
        if task.completed == true{
            taskImage.image = UIImage(named: "checkbox")
        }
        else if task.completed == false && task.canceled == false && task.deleted == false{
            taskImage.image = UIImage(named: "EmptyBox")
        }
        else{
            taskImage.image = UIImage(named: "uncheckbox")
        }
    }
    
    func setTitle(title: String){
        taskTitle.text = "Task: \(title)"
    }
    
    func setEstimatedCompletedDate(date: String){
        taskCompletionDate.text = "Complete by: \(date)"
    }
    
    func setAlert(alert: String){
        taskAlert.text = "Alert: \(alert)"
    }
    
    func setRepeating(rep: String){
        taskRepeating.text = "Repeat: \(rep)"
    }
    
    func setAdditional(additional: String){
        taskAdditional.text = "Additional Info: \(additional)"
    }
}
