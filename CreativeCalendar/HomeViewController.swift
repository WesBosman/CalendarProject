//
//  HomeViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/11/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var appointmentLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var journalLabel: UILabel!
    @IBOutlet weak var appointmentViewTable: UITableView!
    @IBOutlet weak var taskViewTable: UITableView!
    @IBOutlet weak var journalViewBox: UITextView!
    var appointmentArray: [AppointmentItem] = []
    var taskArray: [TaskItem] = []
    let appointmentCellID = "AppointmentHomeCell"
    let taskCellID = "TaskHomeCell"
    private var taskCell: HomeTaskCell = HomeTaskCell()
    private var appointmentCell: HomeAppointmentCell = HomeAppointmentCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set color and text of the text labels
        appointmentLabel.text = "Appointments"
        appointmentLabel.textColor = UIColor.whiteColor()
        taskLabel.text = "To-Do List"
        taskLabel.textColor = UIColor.whiteColor()
        journalLabel.text = "Journal"
        journalLabel.textColor = UIColor.whiteColor()
        
        // Get all appointments and tasks.
        appointmentArray = AppointmentItemList.sharedInstance.allItems()
        taskArray = TaskItemList.sharedInstance.allTasks()
        
        // Set this class up to be the delegate for the two different table views
        self.taskViewTable.delegate = self
        self.taskViewTable.dataSource = self
        self.appointmentViewTable.delegate = self
        self.appointmentViewTable.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == appointmentViewTable{
            return appointmentArray.count
        }
        else{
            return taskArray.count
        }
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        // If the user deselects the row what do we do?
        if tableView == taskViewTable{
            //taskCell.uncheckedTaskImage.image = UIImage(named: "uncheckbox")
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Need an alert dialog box so the user can specify that they have completed the task.
        // When you select a task on the home screen change the picture to a green checkbox
        
        if tableView == taskViewTable{
            let task = taskArray[indexPath.row] as TaskItem
            let newTaskCell = taskViewTable.dequeueReusableCellWithIdentifier(taskCellID, forIndexPath: indexPath) as! HomeTaskCell
            newTaskCell.homeTaskTitle.text = task.taskTitle
            newTaskCell.homeTaskInfo.text = task.taskInfo
            
            // This does not seem to reset the values unless you get it right on the first try??????
            var alert = UIAlertController(title: "Hello", message: "Have you completed this task?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Destructive action
            alert.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                
                newTaskCell.uncheckedTaskImage.image = UIImage(named: "checkbox")
                let strikeThroughLabel: NSMutableAttributedString = NSMutableAttributedString(string: task.taskTitle)
                strikeThroughLabel.addAttribute(NSStrikethroughStyleAttributeName, value: 1, range: NSMakeRange(0, strikeThroughLabel.length))
                newTaskCell.homeTaskTitle.attributedText = strikeThroughLabel
                newTaskCell.homeTaskInfo.text = task.taskInfo
                
            } ))
            
            // Non Destructive action
            alert.addAction(UIAlertAction(title: "no", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction!) in
                newTaskCell.uncheckedTaskImage.image = UIImage(named: "uncheckbox")
                newTaskCell.homeTaskTitle.text = task.taskTitle
                newTaskCell.homeTaskInfo.text = task.taskInfo
            } ))
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // fill the appointment table view cell and return it
        if tableView == appointmentViewTable{
            let appointment = appointmentArray[indexPath.row] as AppointmentItem
            appointmentCell = appointmentViewTable.dequeueReusableCellWithIdentifier(appointmentCellID, forIndexPath: indexPath) as! HomeAppointmentCell
            print("\nAppointment Title: \(appointment.title)\n")
            print("Appointment Start: \(appointment.startingTime)\n")
            print("Appointment End: \(appointment.endingTime)\n")
            print("Appointment Location: \(appointment.appLocation)\n")
            print("Appointment Additional Info: \(appointment.additionalInfo)\n")
            let startFormatter = NSDateFormatter()
            let endFormatter = NSDateFormatter()
            startFormatter.dateFormat = "MMM dd ',' h:mm a"
            endFormatter.dateFormat = " MMM dd ',' h:mm a"
            
            appointmentCell.homeAppointmentTitle.text = appointment.title
            appointmentCell.homeAppointmentSubtitle.text = "start: \(startFormatter.stringFromDate(appointment.startingTime)) \nend: \(endFormatter.stringFromDate(appointment.endingTime)) \nlocation: \(appointment.appLocation)"
            return appointmentCell
        }
        
        // Other wise fill the task table view cell and return it
        let task = taskArray[indexPath.row] as TaskItem
        taskCell = taskViewTable.dequeueReusableCellWithIdentifier(taskCellID, forIndexPath: indexPath) as! HomeTaskCell
        print("\nTask Title: \(task.taskTitle)\n")
        print("Task Info: \(task.taskInfo)\n")
        taskCell.homeTaskTitle.text = task.taskTitle
        taskCell.homeTaskInfo.text = task.taskInfo
        
        return taskCell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
