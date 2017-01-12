//
//  TaskStaticTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class TaskStaticTableViewController: UITableViewController {
    
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var taskAdditionalInfoTextBox: UITextField!
    @IBOutlet weak var taskFinishDateLabel: UILabel!
    @IBOutlet weak var taskFinishDateRightDetail: UILabel!
    @IBOutlet weak var taskDatePicker: UIDatePicker!
    @IBOutlet weak var repeatingTaskRightDetail: UILabel!
    @IBOutlet weak var repeatingTaskTitle: UILabel!
//    @IBOutlet weak var saveTask: UIButton!
    @IBOutlet weak var alertTaskTitle: UILabel!
    @IBOutlet weak var alertTaskRightDetail: UILabel!
    
    fileprivate let db = DatabaseFunctions.sharedInstance
    fileprivate var taskDatePickerIsHidden = false
    fileprivate var taskRepeatDayIsHidden = false
    fileprivate var taskAlertIsHidden = false
    fileprivate let taskFormatter = DateFormatter().dateWithTime
    fileprivate let currentDate = Date()
    
    var startTimesArray:[Date] = []
    var alertTimesArray: [Date] = []
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        taskNameTextField.placeholder = "Task Name"
        taskAdditionalInfoTextBox.placeholder = "Additional Information"
        taskFinishDateLabel.text = "Estimated Task Completion Date"
        taskFinishDateRightDetail.text = taskFormatter.string(from: currentDate)
        repeatingTaskTitle.text = "Schedule a repeating Task"
        alertTaskTitle.text = "Schedule an alert"
        alertTaskRightDetail.text = AlertTableViewCell().alertArray[0]
        repeatingTaskRightDetail.text = RepeatTableViewCell().repeatDays[0]
        
        // Set the boundary dates for the maximum and minimum dates of the date picker
        taskDatePicker.minimumDate = Date()
        taskDatePicker.maximumDate = Date().calendarEndDate
        
        // Set the color and shape of the save button
//        saveTask.layer.cornerRadius = 10
//        saveTask.layer.borderWidth = 2
//        saveTask.layer.borderColor = UIColor().defaultButtonColor.cgColor
//        saveTask.setTitleColor(UIColor.white, for: UIControlState())
//        saveTask.backgroundColor = UIColor().defaultButtonColor
        
        // Hide the pickers from the user
        toggleTaskDatePicker()
        toggleRepeatDayPicker()
        toggleAlertTableView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        if (indexPath as NSIndexPath).row == 0 && (indexPath as NSIndexPath).section == 0{
            taskNameTextField.becomeFirstResponder()
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        }
        else if (indexPath as NSIndexPath).row == 0 && (indexPath as NSIndexPath).section == 1{
            taskAdditionalInfoTextBox.becomeFirstResponder()
            cell!.selectionStyle = UITableViewCellSelectionStyle.none
        }
        else if (indexPath as NSIndexPath).row == 0 && (indexPath as NSIndexPath).section == 2{
            toggleTaskDatePicker()
        }
        else if (indexPath as NSIndexPath).row == 0 && (indexPath as NSIndexPath).section == 3{
            toggleRepeatDayPicker()
        }
        else if (indexPath as NSIndexPath).row == 0 && (indexPath as NSIndexPath).section == 4{
            toggleAlertTableView()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if taskDatePickerIsHidden && (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 1{
            return 0
        }
        else if taskRepeatDayIsHidden && (indexPath as NSIndexPath).section == 3 && (indexPath as NSIndexPath).row == 1{
            return 0
        }
        else if taskAlertIsHidden && (indexPath as NSIndexPath).section == 4 && (indexPath as NSIndexPath).row == 1{
            return 0
        }
        else{
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    @IBAction func taskDatePickerChanged(_ sender: AnyObject) {
        let dateAsString = taskFormatter.string(from: taskDatePicker.date)
        print("Task Date: \(dateAsString)")
        taskFinishDateRightDetail.text = dateAsString
    }
    
    
    @IBAction func saveInNavBarPressed(_ sender: AnyObject) {
        print("Save Button in Nav Bar Pressed")
        
        var additionalInfoString = String()
        
        if !(taskAdditionalInfoTextBox.text! == "Additional Information") || !((taskAdditionalInfoTextBox.text?.isEmpty)!){
            print("Task additional Information is not empty && does not equal additional information")
            additionalInfoString = taskAdditionalInfoTextBox.text!
        }
        
        if (!taskNameTextField.text!.isEmpty && !taskFinishDateRightDetail.text!.isEmpty){
            print("Task Formatter.dateFromString = \(taskFormatter.date(from: taskFinishDateRightDetail.text!)!)")
            let taskItem = TaskItem(title: taskNameTextField.text!,
                                    info: additionalInfoString,
                                    estimatedCompletion: taskFormatter.date(from: taskFinishDateRightDetail.text!)!,
                                    repeatTime: repeatingTaskRightDetail.text!,
                                    alertTime:  alertTaskRightDetail.text!,
                                    isComplete: false,
                                    isCanceled: false,
                                    isDeleted: false,
                                    dateFinished: nil,
                                    cancelReason: nil,
                                    deleteReason: nil,
                                    UUID: UUID().uuidString)
            
            db.addToTaskDatabase(taskItem)
            
            if startTimesArray.isEmpty == false{
                print("Start Times Array is not empty!")
                
                for task in startTimesArray{
                    let taskItem = TaskItem(title: taskNameTextField.text!,
                                            info: additionalInfoString,
                                            estimatedCompletion: task,
                                            repeatTime: repeatingTaskRightDetail.text!,
                                            alertTime: alertTaskRightDetail.text!,
                                            isComplete: false,
                                            isCanceled: false,
                                            isDeleted: false,
                                            dateFinished: nil,
                                            cancelReason: nil,
                                            deleteReason: nil,
                                            UUID: UUID().uuidString)
                    
                    db.addToTaskDatabase(taskItem)
                    
                }
            }
            
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
        else{
            // This is similar to the code for the static appointment alert.
            let someFieldMissing = UIAlertController(title: "Missing Task Title or Date", message: "One or more of the reqired fields marked with an asterisk has not been filled in", preferredStyle: .alert)
            someFieldMissing.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                // Essentially do nothing. Unless we want to print some sort of log message.
            }))
            self.present(someFieldMissing, animated: true, completion: nil)
        }
    }
    
    // Save the information to pass it to the previous view
//    @IBAction func saveTaskPressed(_ sender: AnyObject) {
//        // Make sure there is atleast a task title in order to let the user save the task
////        let current = NSDate()
//        var additionalInfoString = String()
//        
//        if !(taskAdditionalInfoTextBox.text! == "Additional Information") || !((taskAdditionalInfoTextBox.text?.isEmpty)!){
//            print("Task additional Information is not empty && does not equal additional information")
//            additionalInfoString = taskAdditionalInfoTextBox.text!
//        }
//        
//        if (!taskNameTextField.text!.isEmpty && !taskFinishDateRightDetail.text!.isEmpty){
//            print("Task Formatter.dateFromString = \(taskFormatter.date(from: taskFinishDateRightDetail.text!)!)")
//            let taskItem = TaskItem(title: taskNameTextField.text!,
//                                    info: additionalInfoString,
//                                    estimatedCompletion: taskFormatter.date(from: taskFinishDateRightDetail.text!)!,
//                                    repeatTime: repeatingTaskRightDetail.text!,
//                                    alertTime:  alertTaskRightDetail.text!,
//                                    isComplete: false,
//                                    isCanceled: false,
//                                    isDeleted: false,
//                                    dateFinished: nil,
//                                    cancelReason: nil,
//                                    deleteReason: nil,
//                                    UUID: UUID().uuidString)
//            
//            db.addToTaskDatabase(taskItem)
//            
//            if startTimesArray.isEmpty == false{
//                print("Start Times Array is not empty!")
//                
//                for task in startTimesArray{
//                    let taskItem = TaskItem(title: taskNameTextField.text!,
//                                            info: additionalInfoString,
//                                            estimatedCompletion: task,
//                                            repeatTime: repeatingTaskRightDetail.text!,
//                                            alertTime: alertTaskRightDetail.text!,
//                                            isComplete: false,
//                                            isCanceled: false,
//                                            isDeleted: false,
//                                            dateFinished: nil,
//                                            cancelReason: nil,
//                                            deleteReason: nil,
//                                            UUID: UUID().uuidString)
//                
//                    db.addToTaskDatabase(taskItem)
//
//                }
//            }
//            
//            
//            _ = self.navigationController?.popToRootViewController(animated: true)
//        }
//        else{
//            // This is similar to the code for the static appointment alert.
//            let someFieldMissing = UIAlertController(title: "Missing Task Title or Date", message: "One or more of the reqired fields marked with an asterisk has not been filled in", preferredStyle: .alert)
//            someFieldMissing.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
//                // Essentially do nothing. Unless we want to print some sort of log message.
//            }))
//            self.present(someFieldMissing, animated: true, completion: nil)
//        }
//    }
    
    func toggleTaskDatePicker(){
        taskDatePickerIsHidden = !taskDatePickerIsHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleRepeatDayPicker(){
        taskRepeatDayIsHidden = !taskRepeatDayIsHidden
        if let taskRepeat = defaults.object(forKey: "RepeatIdentifier"){
            makeRecurringTask( String(describing: taskRepeat), start: taskDatePicker.date)
            repeatingTaskRightDetail.text = String(describing: taskRepeat)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleAlertTableView(){
        
        taskAlertIsHidden = !taskAlertIsHidden
        if let taskAlert = defaults.object(forKey: "AlertIdentifier"){
            alertTaskRightDetail.text = String(describing: taskAlert)
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // Tasks only are worried about the estiated completion time
    func makeRecurringTask(_ interval: String, start: Date){
        print("Make New Notification Interval: \(interval)")
        let calendar = Calendar.current
        var dateComponents = DateComponents()
    
        switch(interval){
        case "":
            dateComponents.day = 0
            break
        case "Every Day":
            dateComponents.day = 1
            break
        case "Every Week":
            dateComponents.day = 7
            break
        case "Every Two Weeks":
            dateComponents.day = 14
            break
        case "Every Month":
            dateComponents.day = 28
            break
        default:
            break
        }
        // Get the time for the users appointment
        let endDate = Date().calendarEndDate
        let newStart = (calendar as NSCalendar).date(byAdding: dateComponents, to: start, options: .matchStrictly)
    
        // Add the new start and end time to this array of tuples
        startTimesArray.append(newStart!)
    
        // If the new date is still within range of the calendar boundary dates then call this method again
        if(newStart?.isInRange(Date(), to: endDate) == true){
    
            makeRecurringTask(interval, start: newStart!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
