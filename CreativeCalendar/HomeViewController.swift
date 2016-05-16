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
    
    @IBOutlet weak var uncheckedTask: UIImageView!
    @IBOutlet weak var labelTask: UILabel!
    @IBOutlet weak var labelTaskInfo: UILabel!
    
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
        //self.tasks = TaskItemList.sharedInstance.allTasks()
        
        
        
        // Do any additional setup after loading the view.
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // fill the appointment table view cell and return it
        if tableView == appointmentViewTable{
            let appointment = appointmentArray[indexPath.row] as AppointmentItem
            let appCell = appointmentViewTable.dequeueReusableCellWithIdentifier(appointmentCellID, forIndexPath: indexPath) as! HomeAppointmentCell
            print("\nAppointment Title: \(appointment.title)\n")
            print("Appointment Start: \(appointment.startingTime)\n")
            print("Appointment End: \(appointment.endingTime)\n")
            print("Appointment Location: \(appointment.appLocation)\n")
            print("Appointment Additional Info: \(appointment.additionalInfo)\n")
            appCell.homeAppointmentTitle.text = appointment.title
            appCell.homeAppointmentSubtitle.text = "start: \(appointment.startingTime) end: \(appointment.endingTime) location: \(appointment.appLocation)"
            return appCell
        }
        
        // Other wise fill the task table view cell and return it
        let task = taskArray[indexPath.row] as TaskItem
        let taskCell = taskViewTable.dequeueReusableCellWithIdentifier(taskCellID, forIndexPath: indexPath) as! HomeTaskCell
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
