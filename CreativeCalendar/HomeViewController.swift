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
import ChameleonFramework

// Dates for Calendar starting and ending dates. 

/*
    Note that changing the calendar start and end dates here will change them for the entire calendar
    Useful for starting and stopping of the study. 
    Right now it is the start date plus three months.
 */
extension Date{
    fileprivate struct CalendarDates{
        fileprivate static let calendarStartDate:Date = {
            let startDate = RemoteConfigValues
                              .sharedInstance
                              .getCalendarStartDate(forKey: "calendarStartDate")
            
            print("Calendar Dates StartDate: \(startDate)")
            return startDate
        }()
        
        fileprivate static let calendarEndDate:Date = {
            var calendarComponents = DateComponents()
            let calendar = Calendar.current
            // Gets the last day of the month
            calendarComponents.month = 3
            calendarComponents.day = -1
            let endDate = (calendar as NSCalendar).date(byAdding: calendarComponents, to: CalendarDates.calendarStartDate, options: .matchStrictly)
            print("Calendar Dates EndDate: \(endDate!)")
            return endDate!
        }()
    }
        var calendarStartDate:Date {
            get{
                return CalendarDates.calendarStartDate
            }
        }
        
        var calendarEndDate:Date {
            get{
                return CalendarDates.calendarEndDate
            }
        }
}

// Dates are getting formatted so much I might as well an extension
extension DateFormatter{
    fileprivate struct Formatters{
        fileprivate static let fullFormat:DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE M/dd/yyyy hh:mm:ss a"
            return dateFormatter
        }()
        
        fileprivate static let fullDateFormat:DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
            return dateFormatter
        }()

    
        fileprivate static let monthDayYearFormat:DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMM dd yyyy"
            return dateFormatter
        }()
        
        fileprivate static let monthDayYearHourMinuteFormat: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE M/dd/yyyy h:mm a"
            return dateFormatter
        }()
        
        fileprivate static let monthDayYearWithoutTime: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/dd/yyyy"
            return dateFormatter
        }()
        
        fileprivate static let homeDateFormat: DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            return dateFormatter
        }()
    }
    
    var universalFormatter: DateFormatter {
        get{
            return Formatters.fullFormat
        }
    }
    var dateWithoutTime:DateFormatter {
        get{
            return Formatters.monthDayYearFormat
        }
    }
    
    var dateWithTime: DateFormatter {
        get{
            return Formatters.monthDayYearHourMinuteFormat
        }
    }
    
    var calendarFormat: DateFormatter{
        get{
            return Formatters.monthDayYearWithoutTime
        }
    }
    
    var journalFormat: DateFormatter{
        get{
            return Formatters.fullDateFormat
        }
    }
    
    var homeFormat: DateFormatter{
        get{
            return Formatters.homeDateFormat
        }
    }
}

// The color of the buttons set to the default text color of ios buttons
extension UIColor{
    var defaultButtonColor: UIColor { return UIColor(red: 0.0, green: 0.478, blue: 1.0, alpha: 1.0)}
    var appointmentColor: UIColor   { return UIColor.flatRedDark}
    var taskColor: UIColor          { return UIColor.flatGreenDark}
    var journalColor: UIColor       { return UIColor.flatYellowDark}
}

// This extension is for making a background gradient
extension CAGradientLayer{
    func makeGradientBackground() -> CAGradientLayer{
        let gradientBackground = CAGradientLayer()
        let lightTopColor = UIColor(red: (102/255.0), green: (204/255.0), blue: (255/255.0), alpha: 1.0).cgColor
        let darkBottomColor = UIColor(red: (0/255.0), green: (128/255.0), blue: (200/255.0), alpha: 1.0).cgColor
        gradientBackground.colors = [lightTopColor, darkBottomColor]
        gradientBackground.locations = [0.0, 1.0]
        return gradientBackground
    }
}

class HomeViewController: UIViewController , UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate{

    @IBOutlet weak var daysOfTheWeekText: UILabel!
    @IBOutlet weak var homeDateLabel: UILabel!
    @IBOutlet weak var appointmentViewTable: UITableView!
    @IBOutlet weak var taskViewTable: UITableView!
    @IBOutlet weak var journalViewTable: UITableView!
    
    weak var actionToEnable : UIAlertAction?
    let db = DatabaseFunctions.sharedInstance
    let appointmentCellID = "AppointmentHomeCell"
    let taskCellID        = "TaskHomeCell"
    let journalCellID     = "JournalHomeCell"
    
    var appointmentArray: [AppointmentItem] = []
    var taskArray: [TaskItem] = []
    var journalArray: [JournalItem] = []
    
    var todaysDate: String = String()
    var consentGiven       = false
    let dateFormat         = DateFormatter()
    let currentDate        = Date()
    let homeDateFormat     = DateFormatter().homeFormat
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Notification Center updates the text in appointment and task table views
        NotificationCenter.default
            .addObserver(self, selector: #selector(HomeViewController.viewWillAppear(_:)), name: NSNotification.Name(rawValue: "HomeTablesShouldRefresh"), object: nil)
        
        // Current Date
        dateFormat.dateStyle = DateFormatter.Style.full
        todaysDate = dateFormat.string(from: currentDate)
        homeDateLabel.text = todaysDate
        
        // Make the gradient background
        let background = CAGradientLayer().makeGradientBackground()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        // Set this class up to be the delegate for the different table views
        self.appointmentViewTable.delegate = self
        self.appointmentViewTable.dataSource = self
        self.taskViewTable.delegate = self
        self.taskViewTable.dataSource = self
        self.journalViewTable.delegate = self
        self.journalViewTable.dataSource = self
        
        // Round out the table views
        appointmentViewTable.layer.cornerRadius = 5
        taskViewTable.layer.cornerRadius = 5
        journalViewTable.layer.cornerRadius = 5
        
        // Set the empty data sources 
        appointmentViewTable.emptyDataSetSource = self
        appointmentViewTable.emptyDataSetDelegate = self
        taskViewTable.emptyDataSetSource = self
        taskViewTable.emptyDataSetDelegate = self
        journalViewTable.emptyDataSetSource = self
        journalViewTable.emptyDataSetDelegate = self
        
        // Set empty footer to get rid of the lines in empty tables
        appointmentViewTable.tableFooterView = UIView()
        taskViewTable.tableFooterView = UIView()
        journalViewTable.tableFooterView = UIView()
        
        appointmentViewTable.rowHeight = UITableViewAutomaticDimension
        taskViewTable.rowHeight = UITableViewAutomaticDimension
        journalViewTable.rowHeight = UITableViewAutomaticDimension
        
        appointmentViewTable.estimatedRowHeight = 100
        taskViewTable.estimatedRowHeight = 100
        journalViewTable.estimatedRowHeight = 100
        
        // Make the day label with the checkmark.
        daysOfTheWeekText.text = setUpDaysOfTheWeekLabel()
        
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialize Tab Bar Item
//        tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "Home"), tag: 1)
    }
    
    func setUpDaysOfTheWeekLabel() -> String{
        var todaysSubString = todaysDate as NSString
        todaysSubString = todaysSubString.substring(with: NSRange(location: 0, length: 3)) as NSString
        let checkmark = "✅"
        let newSubstring = (todaysSubString as String) + " __"
        let newStringPlusCheck = (todaysSubString as String) + " " + checkmark
        let newText = daysOfTheWeekText.text?.replacingOccurrences(of: newSubstring, with: newStringPlusCheck, options: .literal, range: nil)
        return newText! as String
    }
    
    // Set up the table views when the view appears
    override func viewWillAppear(_ animated: Bool) {
        let currentDateAsString = DateFormatter().dateWithoutTime.string(from: currentDate)
        appointmentArray = db.getAppointmentByDate(currentDateAsString, formatter: DateFormatter().dateWithoutTime)
        taskArray = db.getTaskByDate(currentDateAsString, formatter: DateFormatter().dateWithoutTime)
        journalArray = db.getJournalByDate(currentDateAsString, formatter: DateFormatter().dateWithoutTime)
        
        taskViewTable.reloadData()
        appointmentViewTable.reloadData()
        journalViewTable.reloadData()
    }
    
    
    // MARK - Empty Data Source Methods
    
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        if scrollView == appointmentViewTable{
            let str = "No Appointments scheduled for today"
            let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)]
            return NSAttributedString(string: str, attributes: attributes)
        }
        else if scrollView == taskViewTable{
            let str = "No Tasks scheduled for today"
            let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)]
            return NSAttributedString(string: str, attributes: attributes)
        }
        else if scrollView == journalViewTable{
            let str = "No Journals for today"
            let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)]
            return NSAttributedString(string: str, attributes: attributes)
        }
        return nil
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        if scrollView == appointmentViewTable{
            let str = "Please go to the Appointment Tab if you would like to schedule an appointment for today"
            let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
            return NSAttributedString(string: str, attributes: attributes)
        }
        else if scrollView == taskViewTable{
            let str = "Please go to the Task Tab if you would like to schedule a task for today"
            let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
            return NSAttributedString(string: str, attributes: attributes)
        }
        else if scrollView == journalViewTable{
            let str = "Please go to the Journal Tab if you would like to write a journal for today"
            let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
            return NSAttributedString(string: str, attributes: attributes)
        }
        return nil
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        if scrollView == appointmentViewTable{
            let image = UIImage(named: "Appointments")
            return image
        }
        else if scrollView == taskViewTable{
            let image = UIImage(named: "Tasks")
            return image
        }
        else if scrollView == journalViewTable{
            let image = UIImage(named: "Journals")
            return image
        }
        return nil
    }


    // MARK - Table View Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == appointmentViewTable{
            return appointmentArray.count
        }
        else if tableView == taskViewTable{
            return taskArray.count
        }
        else{
            return journalArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Appointment Table View
        if tableView == appointmentViewTable{
            let appointment = appointmentArray[(indexPath as NSIndexPath).row] as AppointmentItem
            let appointmentCell = appointmentViewTable.dequeueReusableCell(withIdentifier: appointmentCellID, for: indexPath) as! HomeAppointmentCell
            
            // If the appointment is overdue then the starting date text color is red
            if appointment.isOverdue == true{
                appointmentCell.homeAppointmentStart.textColor = UIColor.red
            }
            else{
                appointmentCell.homeAppointmentStart.textColor = UIColor.black
            }
            
            // If the appointment has been completed then we need to mark it with a check
            appointmentCell.homeAppointmentCompleted(appointment)
            
            // Set the other images and labels.
            appointmentCell.homeAppointmentImage.image = UIImage(named: "Appointments")
            appointmentCell.setTitle(title: appointment.title)
            appointmentCell.setType(type: appointment.type)
            appointmentCell.setStart(start: homeDateFormat.string(from: appointment.startingTime))
            appointmentCell.setEnd(end: homeDateFormat.string(from: appointment.endingTime))
            appointmentCell.setLocation(location: appointment.appLocation)
            appointmentCell.setAlert(alert: appointment.alert)
            appointmentCell.setRepeat(repeating: appointment.repeating)
            appointmentCell.setAdditional(additional: appointment.additionalInfo)
            appointmentCell.preservesSuperviewLayoutMargins = false
            appointmentCell.separatorInset = .zero
            appointmentCell.layoutMargins = .zero
            
            return appointmentCell
        }
            // Task Table View
        else if tableView == taskViewTable{
            let task = taskArray[(indexPath as NSIndexPath).row] as TaskItem
            let taskCell = taskViewTable.dequeueReusableCell(withIdentifier: taskCellID, for: indexPath) as! HomeTaskCell
            
            // If the task is completed it should have a green checkbox
            taskCell.homeTaskCompleted(task)
            taskCell.setTitle(title: task.taskTitle)
            taskCell.setAlert(alert: task.alert)
            taskCell.setInfo(info: task.taskInfo)
            taskCell.setCompletionDate(date: homeDateFormat.string(from: task.estimateCompletionDate))
            taskCell.setRepeating(repeating: task.repeating)
            taskCell.homeTaskTypeImage.image = UIImage(named: "Tasks")
            taskCell.preservesSuperviewLayoutMargins = false
            taskCell.separatorInset = .zero
            taskCell.layoutMargins = .zero
            
            // Task has past its due date
            if task.isOverdue{
                taskCell.homeTaskCompletionDate.textColor = UIColor.red
            }
            else{
                taskCell.homeTaskCompletionDate.textColor = UIColor.black
            }
            
            return taskCell
        }
            // Journal Table View
        else{
            let journal = journalArray[(indexPath as NSIndexPath).row] as JournalItem
            let journalCell = journalViewTable.dequeueReusableCell(withIdentifier: journalCellID, for: indexPath) as! HomeJournalCell
            
            let journalImage = UIImage(named: "Journals")!
            journalCell.setTitle(title: journal.journalTitle)
            journalCell.setEntry(entry: journal.journalEntry)
            journalCell.setJournalImage(image: journalImage)
            journalCell.preservesSuperviewLayoutMargins = false
            journalCell.separatorInset = .zero
            journalCell.layoutMargins = .zero
            return journalCell
        }
    }
    
    // MARK - Table View Header Methods
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        print("Will display header view")
        if let headerView = view as? UITableViewHeaderFooterView{
            if tableView == appointmentViewTable{
                headerView.textLabel?.text = "Appointments (\(appointmentArray.count))"
                headerView.textLabel?.textColor = UIColor.white
                headerView.backgroundView?.backgroundColor = UIColor().appointmentColor
            }
            else if tableView == taskViewTable{
                headerView.textLabel?.text = "Tasks (\(taskArray.count))"
                headerView.textLabel?.textColor = UIColor.white
                headerView.backgroundView?.backgroundColor = UIColor().taskColor
            }
            else if tableView == journalViewTable{
                headerView.textLabel?.text = "Journals (\(journalArray.count))"
                headerView.textLabel?.textColor = UIColor.white
                headerView.backgroundView?.backgroundColor = UIColor().journalColor
            }
        }
    }
    
    // MARK - Table View Menu Controllers
    
    // Appointments and Tasks can be completed, canceled and delted from the 
    // Home view controller
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Need an alert dialog box so the user can specify that they have completed the task.
        // When you select a task and mark it as complete on the home screen change the picture to a green checkbox
        let exitMenu = UIAlertAction(title: "Exit Menu", style: .cancel, handler: nil)
        
        if tableView == taskViewTable{
            // Get the task item and task cell
            var task = taskArray[(indexPath as NSIndexPath).row] as TaskItem
            let taskCell = taskViewTable.cellForRow(at: indexPath) as! HomeTaskCell
            
            // Create an Alert to ask the user if they have completed the task.
            let alert = (UIAlertController(title: "Hello", message: "Have you completed the task: \n\(task.taskTitle)?", preferredStyle: UIAlertControllerStyle.alert))
            
            // Add the option to complete a task or exit the menu
            let completeTaskAction = (UIAlertAction(title: "Complete Task", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) in
                
                let completeTask = UIAlertController(title: "Confirmation", message: "Are you sure you want to Complete the task: \n\(task.taskTitle)?", preferredStyle: UIAlertControllerStyle.alert)
                
                // Add complete action to the complete task controller
                let complete = UIAlertAction(title: "Complete", style: .destructive, handler: {(action: UIAlertAction) in
                    task.completed = true
                    task.canceled = false
                    task.deleted = false
                    taskCell.homeTaskCompleted(task)
                    self.db.updateTask(task)
                })
                
                completeTask.addAction(complete)
                completeTask.addAction(exitMenu)
                self.present(completeTask, animated: true, completion: nil)

            }))
            // Add the option to cancel a task and a confirmation menu
            let cancelTaskAction = (UIAlertAction(title: "Cancel Task", style: UIAlertActionStyle.default, handler: {(action: UIAlertAction) in
                let confirmationMenu = self.confirmationMenu("Tasks", typeOfAction: "Cancel", indexPath: indexPath)
                // Why is the user canceling the task
                confirmationMenu.addTextField(configurationHandler: {(textField) in
                    textField.placeholder = "Reason for cancel"
                    textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
                })
                self.present(confirmationMenu, animated: true, completion: nil)

            }))
            // Add the option to delete a task and a confirmation menu
            let deleteTaskAction = (UIAlertAction(title: "Delete Task", style: UIAlertActionStyle.destructive, handler: { (action: UIAlertAction) in
                
                let confirmationMenu = self.confirmationMenu("Tasks", typeOfAction: "Delete", indexPath: indexPath)
                // Why is the user deleting the task
                confirmationMenu.addTextField(configurationHandler: {(textField) in
                    textField.placeholder = "Reason for delete"
                    textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
                })

                self.present(confirmationMenu, animated: true, completion: nil)
            } ))
            
            alert.addAction(completeTaskAction)
            alert.addAction(cancelTaskAction)
            alert.addAction(deleteTaskAction)
            alert.addAction(exitMenu)
            
            // Show the alert to the user
            self.present(alert, animated: true, completion: nil)
        }
            
        // Set up Appointment Table on the Home Screen
        else if tableView == appointmentViewTable{
            // Get the appointment item
            var appointment = appointmentArray[(indexPath as NSIndexPath).row] as AppointmentItem
            let appointmentCell = appointmentViewTable.cellForRow(at: indexPath) as! HomeAppointmentCell
            
            // Create an Alert to ask the user if they have completed the task.
            let alert = UIAlertController(title: "Hello", message: "Have you finished the appointment: \n\(appointment.title)?", preferredStyle: UIAlertControllerStyle.alert)
            
            // Add the option to complete an appointment and a confirmation menu
            let completeAppointmentAction = (UIAlertAction(title: "Complete Appointment", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in

                let completeAppointment = UIAlertController(title: "Confirmation", message: "Are you sure you want to Complete the appointment: \n\(appointment.title)?", preferredStyle: UIAlertControllerStyle.alert)
                let complete = (UIAlertAction(title: "Complete", style: .destructive, handler: {(action: UIAlertAction) in
                    
                    appointment.completed = true
                    appointment.canceled = false
                    appointment.deleted = false
                    appointmentCell.homeAppointmentCompleted(appointment)
                    self.db.updateAppointment(appointment)
                    
                }))
                
                completeAppointment.addAction(complete)
                completeAppointment.addAction(exitMenu)
                self.present(completeAppointment, animated: true, completion: nil)
            } ))
            
            // Add the option to cancel an appointment and a confirmation menu
            let cancelAppointmentAction = (UIAlertAction(title: "Cancel Appointment", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                
                // Present the confirmation menu
                let confirmationAlert = self.confirmationMenu("Appointments", typeOfAction: "Cancel", indexPath: indexPath)
                
                // Why is the user canceling the appointment
                confirmationAlert.addTextField(configurationHandler: {(textField) in
                    textField.placeholder = "Reason for cancel"
                    textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
                })
                self.present(confirmationAlert, animated: true, completion: nil)
                
            } ))
            // Add the option to delete an appointment and a confirmation menu
            let deleteAppointmentAction = (UIAlertAction(title: "Delete Appointment", style: UIAlertActionStyle.destructive, handler: { (action: UIAlertAction) in
                
                // Present the confirmation menu
                let confirmationAlert = self.confirmationMenu("Appointments", typeOfAction: "Delete", indexPath: indexPath)
                
                // Why is the user deleting the appointment
                confirmationAlert.addTextField(configurationHandler: {(textField) in
                    textField.placeholder = "Reason for delete"
                    textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
                })
                self.present(confirmationAlert, animated: true, completion: nil)
                
            } ))
            
            alert.addAction(completeAppointmentAction)
            alert.addAction(cancelAppointmentAction)
            alert.addAction(deleteAppointmentAction)
            alert.addAction(exitMenu)
            
            // Show the alert to the user
            self.present(alert, animated: true, completion: nil)

        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // The confirmation menu checks that a user is preforming their desired action for the item
    func confirmationMenu(_ tableName:String, typeOfAction: String, indexPath: IndexPath) -> UIAlertController{
        // Create exit menu action to reuse
        let exitMenu = UIAlertAction(title: "Exit Menu", style: .cancel, handler: nil)

        // If we are dealing with the appointments table
        if tableName == "Appointments"{
            var appointment = appointmentArray[(indexPath as NSIndexPath).row] as AppointmentItem
            let appointmentCell = appointmentViewTable.cellForRow(at: indexPath) as! HomeAppointmentCell
            
        
            let alert = UIAlertController(title: "Confirmation",
                                          message: "Are you sure you want to \(typeOfAction) the appointment: \n\(appointment.title)?",
                preferredStyle: UIAlertControllerStyle.alert)
            
                let action = (UIAlertAction(title: "\(typeOfAction)", style: .destructive, handler: {(action: UIAlertAction) in
                    
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
                        self.appointmentArray.remove(at: (indexPath as NSIndexPath).row)
                        self.appointmentViewTable.deleteRows(at: [indexPath], with: .automatic)
                    
                    default:
                        break
                        
                    }
                
                }))
                self.actionToEnable = action
                action.isEnabled = false
                alert.addAction(action)
                alert.addAction(exitMenu)
                return alert
        }
        // If we are dealing with the tasks table
        else{
            var task = taskArray[(indexPath as NSIndexPath).row] as TaskItem
            let taskCell = taskViewTable.cellForRow(at: indexPath) as! HomeTaskCell
            
            let alert = UIAlertController(title: "Confirmation", message: "Are you sure you want to \(typeOfAction) the task: \n\(task.taskTitle)?", preferredStyle: UIAlertControllerStyle.alert)
            let action = (UIAlertAction(title: "\(typeOfAction)", style: .destructive, handler: {(action: UIAlertAction) in
                
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
                        self.taskArray.remove(at: (indexPath as NSIndexPath).row)
                        self.taskViewTable.deleteRows(at: [indexPath], with: .automatic)
                    
                    default:
                        break
                }
                
            }))
            self.actionToEnable = action
            action.isEnabled = false
            alert.addAction(action)
            alert.addAction(exitMenu)
            return alert
        }
    }
    
    // If the text field is empty when the user cancels or deletes an appointment or task do not let
    // them cancel or delete the item
    func textChanged(_ sender:UITextField) {
        self.actionToEnable?.isEnabled = (sender.text!.isEmpty == false)
    }
    
    
}
