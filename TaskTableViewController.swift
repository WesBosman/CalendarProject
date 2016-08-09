//
//  TaskTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/12/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    private let taskId = "TaskCells"
    private var taskList:[TaskItem] = []
    private var selectedIndexPath = NSIndexPath?.self
    private let db = DatabaseFunctions.sharedInstance
    private var taskSections: [String] = []
    private let taskDateFormatter = NSDateFormatter().dateWithoutTime
    private var taskDayForSections: Dictionary<String, [TaskItem]> = [:]
    weak var actionToEnable: UIAlertAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the left navigation button to be the edit button.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blueColor()
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(named: "Tasks"), tag: 3)
    }

    
    // View did appear needs to be called because we animated the view from the static table save button being pressed.
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        refreshList()
    }
    
    // Refresh the list of tasks so that the new one gets properly sorted in ascending order.
    func refreshList(){
        taskList = db.getAllTasks()
        // Sort the task list based on the estimated completion date
        taskList = taskList.sort({$0.estimateCompletionDate.compare($1.estimateCompletionDate) == NSComparisonResult.OrderedAscending})
        
        for task in taskList{
            let dateForSectionAsString = taskDateFormatter.stringFromDate(task.estimateCompletionDate)
            
            if !(taskSections.contains(dateForSectionAsString)){
                taskSections.append(dateForSectionAsString)
                print("Task Section Date: \(dateForSectionAsString)")
            }
        }
        
        for section in taskSections{
            taskList = db.getTaskByDate(section, formatter: taskDateFormatter)
            taskDayForSections.updateValue(taskList, forKey: section)
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Section Methods
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return taskDayForSections.keys.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDayForSections[taskSections[section]]!.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !taskSections[section].isEmpty{
            return taskSections[section]
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            return 0.0
        }
        else{
            return 30.0
        }
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            return nil
        }
        else{
            return tableView.headerViewForSection(section)
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor().defaultButtonColor
        header.textLabel?.textColor = UIColor.whiteColor()
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(taskId, forIndexPath: indexPath) as! TaskCell
//        let taskItem = taskList[indexPath.row] as TaskItem
        let tableSection = taskDayForSections[taskSections[indexPath.section]]
        let taskItem = tableSection![indexPath.row]
        
        // Configure the cell...
        cell.taskCompleted(taskItem)
        cell.taskCompletionDate.text = "Complete by: \(taskDateFormatter.stringFromDate(taskItem.estimateCompletionDate))"
        cell.taskTitle.text = "Event: \(taskItem.taskTitle)"
        cell.taskSubtitle.text = "Additional Info: \(taskItem.taskInfo)"
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let tableSection = taskDayForSections[taskSections[indexPath.section]]
        var taskForAction = tableSection![indexPath.row] as TaskItem
        let taskCellForAction = tableView.cellForRowAtIndexPath(indexPath) as! TaskCell
        let exitMenu = UIAlertAction(title: "Exit Menu", style: .Cancel, handler: nil)
        
        // Make custom actions for delete, cancel and complete.
        let deletedAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let deleteOptions = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete the task: \(taskForAction.taskTitle)?", preferredStyle: .Alert)
            deleteOptions.addTextFieldWithConfigurationHandler({(textField) in
                textField.placeholder = "Reason for Delete"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
            })
            
            let deleteTask = UIAlertAction(title: "Delete Task", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Delete the row from the data source
                let key = self.taskSections[indexPath.section]
                print("Key for removal: \(key)")
                self.taskDayForSections[key]?.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                //Delete from database
                taskForAction.completed = false
                taskForAction.canceled = false
                taskForAction.deleted = true
                taskForAction.deletedReason = deleteOptions.textFields![0].text ?? ""
                self.db.updateTask(taskForAction)
                
            })
            self.actionToEnable = deleteTask
            self.actionToEnable?.enabled = false
            deleteOptions.addAction(deleteTask)
            deleteOptions.addAction(exitMenu)
            self.presentViewController(deleteOptions, animated: true, completion: nil)
        })
        
        
        let canceledAction = UITableViewRowAction(style: .Default, title: "Cancel", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let cancelOptions = UIAlertController(title: "Cancel Task", message: "Would you like to cancel the task: \(taskForAction.taskTitle)", preferredStyle: .Alert)
            cancelOptions.addTextFieldWithConfigurationHandler({(textField) in
                textField.placeholder = "Reason for Cancel"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
            })

            let cancelAction = UIAlertAction(title: "Cancel Task", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Cancel Appointment
                taskForAction.completed = false
                taskForAction.canceled = true
                taskForAction.deleted = false
                taskForAction.canceledReason = cancelOptions.textFields![0].text ?? ""
                taskCellForAction.taskCompleted(taskForAction)
                self.db.updateTask(taskForAction)
                
            })
            self.actionToEnable = cancelAction
            self.actionToEnable?.enabled = false
            cancelOptions.addAction(cancelAction)
            cancelOptions.addAction(exitMenu)
            self.presentViewController(cancelOptions, animated: true, completion: nil)
        })
        
        
        let completedAction = UITableViewRowAction(style: .Default, title: "Complete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let completeOptions = UIAlertController(title: "Complete Task", message: "Have you completed task: \(taskForAction.taskTitle)", preferredStyle: .Alert)
            
            // Appointment was completed.
            let completeAction = UIAlertAction(title: "Complete Task", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Complete the appointment and update its image.
                taskForAction.completed = true
                taskForAction.canceled = false
                taskForAction.deleted = false
                taskCellForAction.taskCompleted(taskForAction)
                self.db.updateTask(taskForAction)
                
            })            
            completeOptions.addAction(completeAction)
            completeOptions.addAction(exitMenu)
            self.presentViewController(completeOptions, animated: true, completion: nil)
        })
        
        completedAction.backgroundColor = UIColor.blueColor()
        canceledAction.backgroundColor = UIColor.orangeColor()
        return [deletedAction, canceledAction, completedAction]
        
    }
    
    func textChanged(sender:UITextField) {
        self.actionToEnable?.enabled = (sender.text!.isEmpty == false)
    }


    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.

        print("\nSegue Identifier: \(segue.identifier)\n")
 
        if segue.identifier == "TabBarController"{
            var tabBarC: UITabBarController = segue.destinationViewController as! UITabBarController
            var destination: HomeViewController = tabBarC.viewControllers?.first as! HomeViewController
            destination.taskArray = self.taskTestList
            print("Destination task array: \(destination.taskArray)")
        }

    }
    */
}
