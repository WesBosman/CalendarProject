//
//  TaskTableCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 12/27/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class TaskTableCell: UITableViewCell {

    @IBOutlet weak var taskCompletedImage: UIImageView!
    @IBOutlet weak var taskImage: UIImageView!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var taskEstimatedCompleteDate: UILabel!
    @IBOutlet weak var taskAlert: UILabel!
    @IBOutlet weak var taskAdditionalInfo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func taskCompleted(_ task: TaskItem){
        if task.completed == true{
            taskCompletedImage.image = UIImage(named: "checkbox")
        }
        else if task.completed == false && task.canceled == false && task.deleted == false{
            taskCompletedImage.image = UIImage(named: "EmptyBox")
        }
        else{
            taskCompletedImage.image = UIImage(named: "uncheckbox")
        }
    }


}
