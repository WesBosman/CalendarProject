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
import ResearchKit


// Dates for Calendar starting and ending dates. 
extension NSDate{
    private struct CalendarDates{
        private static let calendarStartDate:NSDate = {
            let startDate = NSDateFormatter().calendarFormat.dateFromString("7/01/2016")
            print("Calendar Dates StartDate: \(startDate!)")
            return startDate!
        }()
        
        private static let calendarEndDate:NSDate = {
            let calendarComponents = NSDateComponents()
            let calendar = NSCalendar.currentCalendar()
            // Gets the last day of the month
            calendarComponents.month = 3
            calendarComponents.day = -1
            let endDate = calendar.dateByAddingComponents(calendarComponents, toDate: CalendarDates.calendarStartDate, options: .MatchStrictly)
            print("Calendar Dates EndDate: \(endDate!)")
            return endDate!
        }()
    }
    
        var calendarStartDate:NSDate {
            get{
                return CalendarDates.calendarStartDate
            }
        }
        
        var calendarEndDate:NSDate {
            get{
                return CalendarDates.calendarEndDate
            }
        }
}

// Dates are getting formatted so much I might as well an extension
extension NSDateFormatter{
    private struct Formatters{
        private static let fullFormat:NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE M/dd/yyyy hh:mm:ss a"
            return dateFormatter
        }()
        
        private static let fullDateFormat:NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            return dateFormatter
        }()

    
        private static let monthDayYearFormat:NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "MMMM dd yyyy"
            return dateFormatter
        }()
        
        private static let monthDayYearHourMinuteFormat: NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE M/dd/yyyy h:mm a"
            return dateFormatter
        }()
        
        private static let monthDayYearWithoutTime: NSDateFormatter = {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "M/dd/yyyy"
            return dateFormatter
        }()
    }
    
    var universalFormatter: NSDateFormatter {
        get{
            return Formatters.fullFormat
        }
    }
    var dateWithoutTime:NSDateFormatter {
        get{
            return Formatters.monthDayYearFormat
        }
    }
    
    var dateWithTime: NSDateFormatter {
        get{
            return Formatters.monthDayYearHourMinuteFormat
        }
    }
    
    var calendarFormat: NSDateFormatter{
        get{
            return Formatters.monthDayYearWithoutTime
        }
    }
    
    var journalFormat: NSDateFormatter{
        get{
            return Formatters.fullDateFormat
        }
    }
}

// The color of the buttons set to the default text color of ios buttons
extension UIColor{
    var defaultButtonColor: UIColor { return UIColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0)}
    var navigationBarColor: UIColor { return UIColor(red:0.90, green:0.93, blue:0.98, alpha:1.00)}
    var appointmentColor: UIColor { return UIColor.redColor()}
    var taskColor: UIColor { return UIColor.greenColor()}
    var journalColor: UIColor { return UIColor.yellowColor()}
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
    weak var actionToEnable : UIAlertAction?
    let db = DatabaseFunctions.sharedInstance
    let appointmentCellID = "AppointmentHomeCell"
    let taskCellID = "TaskHomeCell"
    private var taskCell: HomeTaskCell = HomeTaskCell()
    private var appointmentCell: HomeAppointmentCell = HomeAppointmentCell()
    var appointmentArray: [AppointmentItem] = []
    var taskArray: [TaskItem] = []
    var journalArray: [JournalItem] = []
    var todaysDate: String = String()
    var consentGiven = false
    let dateFormat = NSDateFormatter()
    let currentDate = NSDate()
    
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
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        todaysDate = dateFormat.stringFromDate(currentDate)
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
        
        // Make the day label with the checkmark.
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
        return newText! as String
    }
    
    // Clear all NSUser Defaults
//    func clearAllUserDefaults(){
//        //The below two lines of code can clear out NSUser Defaults
//        let appDomain = NSBundle.mainBundle().bundleIdentifier!
//        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
//    }
    
    // When the home screen appears we set the appointment and task arrays based on the data stored there
    // We then reload the tables so that the changes from the other tabs are reflected here.
    override func viewWillAppear(animated: Bool) {
        let currentDateAsString = NSDateFormatter().dateWithoutTime.stringFromDate(currentDate)
        appointmentArray = db.getAppointmentByDate(currentDateAsString, formatter: NSDateFormatter().dateWithoutTime)
        taskArray = db.getTaskByDate(currentDateAsString, formatter: NSDateFormatter().dateWithoutTime)
        taskViewTable.reloadData()
        appointmentViewTable.reloadData()
        printJournals()
    }

    
    // This function is used for printing journals to the home screen
    func printJournals(){
        //print("Journal code for view will appear method.")
        var journalText: String = ""
        var journalCount: Int = 0
        let today = NSDateFormatter().dateWithoutTime.stringFromDate(currentDate)
        journalArray = DatabaseFunctions.sharedInstance.getJournalByDate(today, formatter: NSDateFormatter().dateWithoutTime)
        for journal in journalArray{
            if !journalArray.isEmpty{
                print("Journal Entry: \(journal.journalEntry)")
                journalCount += 1
                print("Number of journals \(journalCount)")
                journalText += journal.journalEntry + "\n"
            }
        }
        let firstString = "You have (\(journalCount)) journal entries for today.\n"
        journalViewBox.text = firstString + journalText
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
        let exitMenu = UIAlertAction(title: "Exit Menu", style: .Cancel, handler: nil)
        
        if tableView == taskViewTable{
            // Get the task item and task cell
            var task = taskArray[indexPath.row] as TaskItem
            let taskCell = taskViewTable.cellForRowAtIndexPath(indexPath) as! HomeTaskCell
            
            // Create an Alert to ask the user if they have completed the task.
            let alert = (UIAlertController(title: "Hello", message: "Have you completed the task: \n\(task.taskTitle)?", preferredStyle: UIAlertControllerStyle.Alert))
            
            // Add the option to complete a task or exit the menu
            let completeTaskAction = (UIAlertAction(title: "Complete Task", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction) in
                
                let completeTask = UIAlertController(title: "Confirmation", message: "Are you sure you want to Complete the task: \n\(task.taskTitle)?", preferredStyle: UIAlertControllerStyle.Alert)
                
                // Add complete action to the complete task controller
                let complete = UIAlertAction(title: "Complete", style: .Destructive, handler: {(action: UIAlertAction) in
                    task.completed = true
                    task.canceled = false
                    task.deleted = false
                    taskCell.homeTaskCompleted(task)
                    self.db.updateTask(task)
                })
//                let exitMenu = UIAlertAction(title: "Exit Menu", style: .Default, handler: nil)
                
                completeTask.addAction(complete)
                completeTask.addAction(exitMenu)
                self.presentViewController(completeTask, animated: true, completion: nil)

            }))
            // Add the option to cancel a task and a confirmation menu
            let cancelTaskAction = (UIAlertAction(title: "Cancel Task", style: UIAlertActionStyle.Default, handler: {(action: UIAlertAction) in
                let confirmationMenu = self.confirmationMenu("Tasks", typeOfAction: "Cancel", indexPath: indexPath)
                // Why is the user canceling the task
                confirmationMenu.addTextFieldWithConfigurationHandler({(textField) in
                    textField.placeholder = "Reason for cancel"
                    textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
                })
                self.presentViewController(confirmationMenu, animated: true, completion: nil)

            }))
            // Add the option to delete a task and a confirmation menu
            let deleteTaskAction = (UIAlertAction(title: "Delete Task", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction) in
                
                let confirmationMenu = self.confirmationMenu("Tasks", typeOfAction: "Delete", indexPath: indexPath)
                // Why is the user deleting the task
                confirmationMenu.addTextFieldWithConfigurationHandler({(textField) in
                    textField.placeholder = "Reason for delete"
                    textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
                })

                self.presentViewController(confirmationMenu, animated: true, completion: nil)
            } ))
            
            alert.addAction(completeTaskAction)
            alert.addAction(cancelTaskAction)
            alert.addAction(deleteTaskAction)
            alert.addAction(exitMenu)
            
            // Show the alert to the user
            self.presentViewController(alert, animated: true, completion: nil)
        }
            
        // Set up Appointment Table on the Home Screen
        else if tableView == appointmentViewTable{
            // Get the appointment item
            var appointment = appointmentArray[indexPath.row] as AppointmentItem
            let appointmentCell = appointmentViewTable.cellForRowAtIndexPath(indexPath) as! HomeAppointmentCell
            
            // Create an Alert to ask the user if they have completed the task.
            let alert = UIAlertController(title: "Hello", message: "Have you finished the appointment: \n\(appointment.title)?", preferredStyle: UIAlertControllerStyle.Alert)
            
            // Add the option to complete an appointment and a confirmation menu
            let completeAppointmentAction = (UIAlertAction(title: "Complete Appointment", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in

                let completeAppointment = UIAlertController(title: "Confirmation", message: "Are you sure you want to Complete the appointment: \n\(appointment.title)?", preferredStyle: UIAlertControllerStyle.Alert)
                let complete = (UIAlertAction(title: "Complete", style: .Destructive, handler: {(action: UIAlertAction) in
                    
                    appointment.completed = true
                    appointment.canceled = false
                    appointment.deleted = false
                    appointmentCell.homeAppointmentCompleted(appointment)
                    self.db.updateAppointment(appointment)
                    
                }))
//                let exitMenu = (UIAlertAction(title: "Exit Menu", style: .Default, handler: nil))
                
                completeAppointment.addAction(complete)
                completeAppointment.addAction(exitMenu)
                self.presentViewController(completeAppointment, animated: true, completion: nil)
            } ))
            
            // Add the option to cancel an appointment and a confirmation menu
            let cancelAppointmentAction = (UIAlertAction(title: "Cancel Appointment", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction) in
                
                // Present the confirmation menu
                let confirmationAlert = self.confirmationMenu("Appointments", typeOfAction: "Cancel", indexPath: indexPath)
                
                // Why is the user canceling the appointment
                confirmationAlert.addTextFieldWithConfigurationHandler({(textField) in
                    textField.placeholder = "Reason for cancel"
                    textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
                })
                self.presentViewController(confirmationAlert, animated: true, completion: nil)
                
            } ))
            // Add the option to delete an appointment and a confirmation menu
            let deleteAppointmentAction = (UIAlertAction(title: "Delete Appointment", style: UIAlertActionStyle.Destructive, handler: { (action: UIAlertAction) in
                
                // Present the confirmation menu
                let confirmationAlert = self.confirmationMenu("Appointments", typeOfAction: "Delete", indexPath: indexPath)
                
                // Why is the user deleting the appointment
                confirmationAlert.addTextFieldWithConfigurationHandler({(textField) in
                    textField.placeholder = "Reason for delete"
                    textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
                })
                self.presentViewController(confirmationAlert, animated: true, completion: nil)
                
            } ))
            
            alert.addAction(completeAppointmentAction)
            alert.addAction(cancelAppointmentAction)
            alert.addAction(deleteAppointmentAction)
            alert.addAction(exitMenu)
            
            // Show the alert to the user
            self.presentViewController(alert, animated: true, completion: nil)

        }
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // The confirmation menu checks that a user is preforming their desired action for the item
    func confirmationMenu(tableName:String, typeOfAction: String, indexPath: NSIndexPath) -> UIAlertController{
        // Create exit menu action to reuse
        let exitMenu = UIAlertAction(title: "Exit Menu", style: .Cancel, handler: nil)

        if tableName == "Appointments"{
            var appointment = appointmentArray[indexPath.row] as AppointmentItem
            let appointmentCell = appointmentViewTable.cellForRowAtIndexPath(indexPath) as! HomeAppointmentCell
            
        
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to \(typeOfAction) the appointment: \n\(appointment.title)?", preferredStyle: UIAlertControllerStyle.Alert)
            
                let action = (UIAlertAction(title: "\(typeOfAction)", style: .Destructive, handler: {(action: UIAlertAction) in
                    
                switch(typeOfAction){
                    case "Cancel":
                        // Give the appointment Cell a red x and mark it as canceled in Database
                        appointment.completed = false
                        appointment.canceled = true
                        appointment.deleted = false
                        
                        // Get the reason the user is deleting the appointment
                        appointment.canceledReason = alert.textFields![0].text ?? ""
                        appointmentCell.homeAppointmentCompleted(appointment)
                        self.db.updateAppointment(appointment)
                        
                    case "Delete":
                        // Delete the appointment Cell from the homeViewController and set deleted to 
                        // true in the database
                        appointment.completed = false
                        appointment.canceled = false
                        appointment.deleted = true
                        
                        // Get the reason the user is deleting the appointment
                        appointment.deletedReason = alert.textFields![0].text ?? ""
                        self.db.updateAppointment(appointment)
                        self.appointmentArray.removeAtIndex(indexPath.row)
                        self.appointmentViewTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    
                    default:
                        break
                        
                    }
                
                }))
                self.actionToEnable = action
                action.enabled = false
                alert.addAction(action)
                alert.addAction(exitMenu)
                return alert
        }
        else{
            var task = taskArray[indexPath.row] as TaskItem
            let taskCell = taskViewTable.cellForRowAtIndexPath(indexPath) as! HomeTaskCell
            
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to \(typeOfAction) the task: \n\(task.taskTitle)?", preferredStyle: UIAlertControllerStyle.Alert)
            let action = (UIAlertAction(title: "\(typeOfAction)", style: .Destructive, handler: {(action: UIAlertAction) in
                
                switch(typeOfAction){
                    // Give the task a red x mark and mark it as canceled in database
                    case "Cancel":
                        task.completed = false
                        task.canceled = true
                        task.deleted = false
                        
                        // Get the reason the user is canceling the task
                        task.canceledReason = alert.textFields![0].text ?? ""
                        taskCell.homeTaskCompleted(task)
                        self.db.updateTask(task)
                    
                    // Mark task as deleted in database and remove it from the tableView
                    case "Delete":
                        task.completed = false
                        task.canceled = false
                        task.deleted = true
                        
                        // Get the reason the user is deleting the task
                        task.deletedReason = alert.textFields![0].text ?? ""
                        self.db.updateTask(task)
                        self.taskArray.removeAtIndex(indexPath.row)
                        self.taskViewTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                    
                    default:
                        break
                }
                
            }))
            self.actionToEnable = action
            action.enabled = false
            alert.addAction(action)
            alert.addAction(exitMenu)
            return alert
        }
    }
    
    // If the text field is empty when the user cancels or deletes an appointment or task do not let
    // them cancel or delete the item
    func textChanged(sender:UITextField) {
        self.actionToEnable?.enabled = (sender.text!.isEmpty == false)
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // fill the appointment table view cell and return it
        if tableView == appointmentViewTable{
            let appointment = appointmentArray[indexPath.row] as AppointmentItem
            let appointmentCell = appointmentViewTable.dequeueReusableCellWithIdentifier(appointmentCellID, forIndexPath: indexPath) as! HomeAppointmentCell
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
            appointmentCell.homeAppointmentCompleted(appointment)
            
            // Set the other images and labels.
            appointmentCell.homeAppointmentImage.image = UIImage(named: "Calendar")
            appointmentCell.homeAppointmentTitle.text = appointment.title
            appointmentCell.homeAppointmentType.text = "type: \(appointment.type)"
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
            taskCell.homeTaskCompleted(task)
            taskCell.homeTaskCompletionDate.text = NSDateFormatter().dateWithTime.stringFromDate(task.estimateCompletionDate)
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
