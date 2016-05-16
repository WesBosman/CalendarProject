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
    var secondArray: [AppointmentItem] = []
    var thirdArray: [TaskItem] = []
    let secondCell = "AppointmentHomeCell"
    let thirdCell = "TaskHomeCell"
    
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
        secondArray = AppointmentItemList.sharedInstance.allItems()
        thirdArray = TaskItemList.sharedInstance.allTasks()
        // Set this class up to be the delegate for the two different table views
        self.taskViewTable.delegate = self
        self.taskViewTable.dataSource = self
        //self.tasks = TaskItemList.sharedInstance.allTasks()
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == taskViewTable{
            return thirdArray.count
        }
        else{
            return secondArray.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == taskViewTable{
            let task = thirdArray[indexPath.row] as TaskItem
            let cell = taskViewTable.dequeueReusableCellWithIdentifier(thirdCell, forIndexPath: indexPath) as! HomeTaskCell
            //let picImage = UIImage(named: "uncheckbox")
            //cell.uncheckedImage = UIImageView(image: picImage)
            print("Task Title: \(task.taskTitle)\n")
            print("Task Info: \(task.taskInfo)\n")
            cell.homeTaskTitle.text = task.taskTitle
            cell.homeTaskInfo.text = task.taskInfo
            return cell
        }
        else{
            let appointment = secondArray[indexPath.row] as AppointmentItem
            let cell = appointmentViewTable.dequeueReusableCellWithIdentifier(secondCell, forIndexPath: indexPath) as! HomeAppointmentCell
            print("Appointment Title: \(appointment.title)\n")
            print("Appointment Start: \(appointment.startingTime)\n")
            print("Appointment End: \(appointment.endingTime)\n")
            print("Appointment Location: \(appointment.appLocation)\n")
            print("Appointment Additional Info: \(appointment.additionalInfo)\n")
            cell.homeAppointmentTitle.text = appointment.title
            cell.homeAppointmentSubtitle.text = "start: \(appointment.startingTime) end: \(appointment.endingTime) location: \(appointment.appLocation)"
            return cell
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
