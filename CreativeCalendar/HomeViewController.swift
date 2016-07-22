//
//  HomeViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/11/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//
//  Using Icon Beast Lite for images for this application
//  Link to their information
//  Author: Charlene
//  Website: http://www.iconbeast.com
//  Email: thebeast@iconbeast.com
//

import UIKit

// Dates are getting formatted so much I might as well make my own extension
extension NSDateFormatter{
    func universalFormatter() -> NSDateFormatter{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        return dateFormatter
    }
}

// This extension is for making a background gradient
extension CAGradientLayer{
    func makeGradientBackground() -> CAGradientLayer{
        let gradientBackground = CAGradientLayer()
        let lightTopColor = UIColor(red: (102/255.0), green: (204/255.0), blue: (255/255.0), alpha: 1.0).CGColor
        let darkBottomColor = UIColor(red: (0/255.0), green: (128/255.0), blue: (200/255.0), alpha: 1.0).CGColor
        gradientBackground.colors = [lightTopColor, darkBottomColor]
        gradientBackground.locations = [0.0, 1.0]
//        gradientBackground.zPosition = -1
        return gradientBackground
    }
}

class HomeViewController: UIViewController , UITableViewDataSource, UITableViewDelegate{
    @IBOutlet weak var appointmentLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var daysOfTheWeekText: UILabel!
    @IBOutlet weak var homeDateLabel: UILabel!
    @IBOutlet weak var journalLabel: UILabel!
    @IBOutlet weak var appointmentViewTable: UITableView!
    @IBOutlet weak var taskViewTable: UITableView!
    @IBOutlet weak var journalViewBox: UITextView!
    let db = DatabaseFunctions.sharedInstance
    let appointmentCellID = "AppointmentHomeCell"
    let taskCellID = "TaskHomeCell"
    private var taskCell: HomeTaskCell = HomeTaskCell()
    private var appointmentCell: HomeAppointmentCell = HomeAppointmentCell()
    var appointmentArray: [AppointmentItem] = []
    var taskArray: [TaskItem] = []
    var journalArray: [JournalItem] = []
    var todaysDate: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set color and text of the text labels
        //clearAllUserDefaults()
        appointmentLabel.text = "Appointments"
        appointmentLabel.textColor = UIColor.whiteColor()
        taskLabel.text = "To-Do List"
        taskLabel.textColor = UIColor.whiteColor()
        journalLabel.text = "Journal"
        journalLabel.textColor = UIColor.whiteColor()
        
        // Current Date
        let dateFormat = NSDateFormatter()
        let date = NSDate()
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        todaysDate = dateFormat.stringFromDate(date)
        homeDateLabel.text = todaysDate
        homeDateLabel.textColor = UIColor.whiteColor()
        
        // Make the gradient background
        let background = CAGradientLayer().makeGradientBackground()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        // Set this class up to be the delegate for the two different table views
        self.taskViewTable.delegate = self
        self.taskViewTable.dataSource = self
        self.appointmentViewTable.delegate = self
        self.appointmentViewTable.dataSource = self
        
        // Make it so the journal is uneditable from the home screen.
        journalViewBox.editable = false
        
        daysOfTheWeekText.text = setUpDaysOfTheWeekLabel()
        
        
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "Home"), tag: 1)
    }
    
    func setUpDaysOfTheWeekLabel() -> String{

        var todaysSubString = todaysDate as NSString
        todaysSubString = todaysSubString.substringWithRange(NSRange(location: 0, length: 3))
        let checkmark = "✅"
        let newSubstring = (todaysSubString as String) + " __"
        let newStringPlusCheck = (todaysSubString as String) + " " + checkmark
        let newText = daysOfTheWeekText.text?.stringByReplacingOccurrencesOfString(newSubstring, withString: newStringPlusCheck, options: .LiteralSearch, range: nil)
//        print("NEW STRING PLUS CHECK \(newStringPlusCheck)")
//        print("New Text : \(newText)")
        return newText! as String

    }
    
    // Clear all NSUser Defaults
//    func clearAllUserDefaults(){
//        //The below two lines of code can clear out NSUser Defaults
//        let appDomain = NSBundle.mainBundle().bundleIdentifier!
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
//    }
    
    // This function is used for printing journals to the home screen 
    func printJournals(){
        //print("Journal code for view will appear method.")
        var journalText: String = ""
        var journalCount: Int = 0
        journalArray = DatabaseFunctions.sharedInstance.getAllJournals()
        for journal in journalArray{
            if !journalArray.isEmpty && (journal.getSimplifiedDate().hasPrefix(todaysDate)){
                print("Journal Entry: \(journal.journalEntry)")
                journalCount += 1
                print("Number of journals \(journalCount)")
                journalText += journal.journalEntry + "\n"
            }
        }
        let firstString = "You have (\(journalCount)) journal entries for today.\n"
        journalViewBox.text = firstString + journalText
    }
    
    // When the home screen appears we set the appointment and task arrays based on the data stored there
    // We then reload the tables so that the changes from the other tabs are reflected here.
    override func viewWillAppear(animated: Bool) {

        appointmentArray = db.getAllAppointments()
        taskArray = db.getAllTasks()
        taskViewTable.reloadData()
        appointmentViewTable.reloadData()
        printJournals()
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
        
        if tableView == taskViewTable{
            var task = taskArray[indexPath.row] as TaskItem
            let taskCell = taskViewTable.cellForRowAtIndexPath(indexPath) as! HomeTaskCell
            
            // Create an Alert to ask the user if they have completed the task.
            let alert = UIAlertController(title: "Hello", message: "Have you completed the task: \n\(task.taskTitle)?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // If the user confirms that a task was completed then update the image to a green checkbox
            alert.addAction(UIAlertAction(title: "yes", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                
                // Update the cell image and labels with strikethroughs and the green checkbox
                taskCell.taskCompleted(task)
                task.completed = true
                self.db.updateTask(task)
            } ))
            
            alert.addAction(UIAlertAction(title: "no", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction) in
                
                // Update the cell image to an uncompleted task
                taskCell.taskNotCompleted(task)
                task.completed = false
                self.db.updateTask(task)
                
            } ))
            // Show the alert to the user
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
        // Set up Appointment Table on the Home Screen
        else if tableView == appointmentViewTable{
            var appointment = appointmentArray[indexPath.row] as AppointmentItem
            let appointmentCell = appointmentViewTable.cellForRowAtIndexPath(indexPath) as! HomeAppointmentCell
            
            // Create an Alert to ask the user if they have completed the task.
            let alert = UIAlertController(title: "Hello", message: "Have you finished the appointment: \n\(appointment.title)?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // If the user confirms that a task was completed then update the image to a green checkbox
            alert.addAction(UIAlertAction(title: "Completed", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                
                // Update the cell image and labels with strikethroughs and the green checkbox
                appointmentCell.appointmentCompleted(appointment)
                appointment.completed = true
                self.db.updateAppointment(appointment)
            } ))
            
            // Cancelled Action
            alert.addAction(UIAlertAction(title: "Canceled", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                
                // Update the cell image to an uncompleted task
                appointmentCell.appointmentNotCompleted(appointment)
                appointment.canceled = true
                self.db.updateAppointment(appointment)
                
            } ))
            // Delete action
            alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction) in
                
                // Update the cell image to an uncompleted task
                appointmentCell.appointmentNotCompleted(appointment)
                appointment.deleted = true
                self.db.updateAppointment(appointment)
                
            } ))
            alert.addAction(UIAlertAction(title: "Do Nothing", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction) in
                // Essentially do nothing.
            }))
            // Show the alert to the user
            self.presentViewController(alert, animated: true, completion: nil)

        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // fill the appointment table view cell and return it
        if tableView == appointmentViewTable{
            let appointment = appointmentArray[indexPath.row] as AppointmentItem
            appointmentCell = appointmentViewTable.dequeueReusableCellWithIdentifier(appointmentCellID, forIndexPath: indexPath) as! HomeAppointmentCell
            let startFormatter = NSDateFormatter()
            let endFormatter = NSDateFormatter()
            startFormatter.dateFormat = "MMM dd ',' h:mm a"
            endFormatter.dateFormat = " MMM dd ',' h:mm a"
            
            // If the appointment is overdue then the starting date text color is red
            if appointment.isOverdue == true{
                appointmentCell.homeAppointmentStart.textColor = UIColor.redColor()
            }
            else{
                appointmentCell.homeAppointmentStart.textColor = UIColor.blackColor()
            }
            
            // If the appointment has been completed then we need to mark it with a check
            if appointment.completed == true{
                appointmentCell.appointmentCompleted(appointment)
            }
            else{
                appointmentCell.appointmentNotCompleted(appointment)
            }
            
            // Set the other images and labels.
            appointmentCell.homeAppointmentImage.image = UIImage(named: "Calendar")
            appointmentCell.homeAppointmentTitle.text = appointment.title
//            appointmentCell.homeAppointmentType.text = "type: \(appointment.type)"
            appointmentCell.homeAppointmentStart.text = "start: \(startFormatter.stringFromDate(appointment.startingTime))"
            appointmentCell.homeAppointmentEnd.text = "end: \(endFormatter.stringFromDate(appointment.endingTime))"
            appointmentCell.homeAppointmentLocation.text = "location: \(appointment.appLocation)"
            appointmentCell.homeAppointmentAdditional.text = "info: \(appointment.additionalInfo)"
            
            return appointmentCell
        }
        // Otherwise fill the task table cell and return it
        else{
            let task = taskArray[indexPath.row] as TaskItem
            taskCell = taskViewTable.dequeueReusableCellWithIdentifier(taskCellID, forIndexPath: indexPath) as! HomeTaskCell

            // If the task is completed it should have a green checkbox
            if task.completed == true{
                taskCell.taskCompleted(task)
            }
            // Otherwise the checkbox should not be green
            else{
                taskCell.taskNotCompleted(task)
            }
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
