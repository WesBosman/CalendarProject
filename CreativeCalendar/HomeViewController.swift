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
    let appointmentCellID = "AppointmentHomeCell"
    let taskCellID = "TaskHomeCell"
    private var taskCell: HomeTaskCell = HomeTaskCell()
    private var appointmentCell: HomeAppointmentCell = HomeAppointmentCell()
    var appointmentArray: [AppointmentItem] = []
    var taskArray: [TaskItem] = []
    var journalArray: [JournalItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set color and text of the text labels
        appointmentLabel.text = "Appointments"
        appointmentLabel.textColor = UIColor.whiteColor()
        taskLabel.text = "To-Do List"
        taskLabel.textColor = UIColor.whiteColor()
        journalLabel.text = "Journal"
        journalLabel.textColor = UIColor.whiteColor()
        
        // Set this class up to be the delegate for the two different table views
        self.taskViewTable.delegate = self
        self.taskViewTable.dataSource = self
        self.appointmentViewTable.delegate = self
        self.appointmentViewTable.dataSource = self
        
    }
    
    // When the home screen appears we set the appointment and task arrays based on the data stored there
    // We then reload the tables so that the changes from the other tabs are reflected here.
    override func viewWillAppear(animated: Bool) {
        println("View will appear animated")
        appointmentArray = AppointmentItemList.sharedInstance.allItems()
        taskArray = TaskItemList.sharedInstance.allTasks()
        taskViewTable.reloadData()
        appointmentViewTable.reloadData()
        
        println("Journal code for view will appear method.")
        journalArray = JournalItemList.sharedInstance.allJournals()
        for journal in journalArray{
            if !journalArray.isEmpty{
                println("Journal Entry: \(journal.journalEntry)")
                journalViewBox.text = journal.journalEntry
            }
            
        }
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Need an alert dialog box so the user can specify that they have completed the task.
        // When you select a task and mark it as complete on the home screen change the picture to a green checkbox
        var task = taskArray[indexPath.row] as TaskItem
        var taskCell = taskViewTable.cellForRowAtIndexPath(indexPath) as! HomeTaskCell
        
        if tableView == taskViewTable{
            // Create an Alert to ask the user if they have completed the task.
            var alert = UIAlertController(title: "Hello", message: "Have you completed the task: \n\(task.taskTitle)?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // If the user confirms that a task was completed then update the image to a green checkbox
            alert.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
                // Update the cell image and labels with strikethroughs and the green checkbox
                taskCell.taskCompleted(task)
            } ))
            
            // If no is clicked make the image a sepia toned image
            alert.addAction(UIAlertAction(title: "no", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction!) in
                // Update the cell image to an uncompleted task
                taskCell.taskNotCompleted(task)
                
            } ))
            // Show the alert to the user
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
    }
    
    
/** NEED A TABLE VIEW CONTROLLER FOR INDEXED LIST
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        var theSections = indexedNumbers as NSArray
        return theSections.indexOfObject(title)
    }
**/
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // fill the appointment table view cell and return it
        if tableView == appointmentViewTable{
            let appointment = appointmentArray[indexPath.row] as AppointmentItem
            appointmentCell = appointmentViewTable.dequeueReusableCellWithIdentifier(appointmentCellID, forIndexPath: indexPath) as! HomeAppointmentCell
            println("Appointment Title: \(appointment.title)")
            println("Appointment Start: \(appointment.startingTime)")
            println("Appointment End: \(appointment.endingTime)")
            println("Appointment Location: \(appointment.appLocation)")
            println("Appointment Additional Info: \(appointment.additionalInfo)")
            let startFormatter = NSDateFormatter()
            let endFormatter = NSDateFormatter()
            startFormatter.dateFormat = "MMM dd ',' h:mm a"
            endFormatter.dateFormat = " MMM dd ',' h:mm a"
            
            appointmentCell.homeAppointmentTitle.text = appointment.title
            appointmentCell.homeAppointmentSubtitle.text = "start: \(startFormatter.stringFromDate(appointment.startingTime)) end: \(endFormatter.stringFromDate(appointment.endingTime)) \nlocation: \(appointment.appLocation)"
            return appointmentCell
        }
        // Otherwise fill the task table cell and return it
        else{
            let task = taskArray[indexPath.row] as TaskItem
            taskCell = taskViewTable.dequeueReusableCellWithIdentifier(taskCellID, forIndexPath: indexPath) as! HomeTaskCell
            println("Task Title: \(task.taskTitle)")
            println("Task Info: \(task.taskInfo)")
            
            taskCell.homeTaskTitle.text = task.taskTitle
            taskCell.homeTaskInfo.text = task.taskInfo
            return taskCell
        }
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
