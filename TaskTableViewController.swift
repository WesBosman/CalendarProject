//
//  TaskTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/12/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class TaskTableViewController: UITableViewController {
    let taskId = "TaskCells"
    var taskList:[TaskItem] = []
    var selectedIndexPath = NSIndexPath?.self
    let db = DatabaseFunctions.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the left navigation button to be the edit button.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor(red:0.90, green:0.93, blue:0.98, alpha:1.00)
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
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(taskId, forIndexPath: indexPath) as! TaskCell
        let taskItem = taskList[indexPath.row] as TaskItem
        // Configure the cell...
        cell.taskCompleted(taskItem)
        
//        if taskItem.completed == true{
//            cell.taskImage.image = UIImage(named: "checkbox")
//        }
//        else{
//            cell.taskImage.image = UIImage(named: "uncheckbox")
//        }
        cell.taskTitle.text = "Event: \(taskItem.taskTitle)"
        cell.taskSubtitle.text = "Additional Info: \(taskItem.taskInfo)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var taskForAction = taskList[indexPath.row] as TaskItem
//        let taskCellForAction = tableView.cellForRowAtIndexPath(indexPath) as! TaskCell
        
        // Make custom actions for delete, cancel and complete.
        let deletedAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let deleteOptions = UIAlertController(title: "Delete", message: "Are you sure you want to delete the task: \(taskForAction.taskTitle)?", preferredStyle: .Alert)
            
            let deleteAppointment = UIAlertAction(title: "Delete Task", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Delete the row from the data source
                self.taskList.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                //Delete from database
                taskForAction.deleted = true
                self.db.updateTask(taskForAction)
                
            })
            let cancelDelete = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            deleteOptions.addAction(cancelDelete)
            deleteOptions.addAction(deleteAppointment)
            
            self.presentViewController(deleteOptions, animated: true, completion: nil)
        })
        
        
        let canceledAction = UITableViewRowAction(style: .Default, title: "Cancel", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let cancelOptions = UIAlertController(title: "Cancel Task", message: "Would you like to cancel the task: \(taskForAction.taskTitle)", preferredStyle: .Alert)
            
            // Appointment was canceled.
            let cancelAction = UIAlertAction(title: "Cancel Task", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Cancel Appointment
//                taskCellForAction.appointmentNotCompleted(taskForAction)
                taskForAction.canceled = true
                self.db.updateTask(taskForAction)
                
            })
            let abortCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            cancelOptions.addAction(cancelAction)
            cancelOptions.addAction(abortCancel)
            
            self.presentViewController(cancelOptions, animated: true, completion: nil)
        })
        
        
        let completedAction = UITableViewRowAction(style: .Default, title: "Complete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let completeOptions = UIAlertController(title: "Complete Task", message: "Have you completed task: \(taskForAction.taskTitle)", preferredStyle: .Alert)
            
            // Appointment was completed.
            let completeAction = UIAlertAction(title: "Complete Task", style: .Default, handler: {(action: UIAlertAction) -> Void in
                
                // Complete the appointment and update its image.
//                taskCellForAction.appointmentCompleted(taskForAction)
                taskForAction.completed = true
                self.db.updateTask(taskForAction)
                
            })
            let completeCanceled = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            completeOptions.addAction(completeAction)
            completeOptions.addAction(completeCanceled)
            
            self.presentViewController(completeOptions, animated: true, completion: nil)
        })
        
        completedAction.backgroundColor = UIColor.blueColor()
        canceledAction.backgroundColor = UIColor.orangeColor()
        
        return [deletedAction, canceledAction, completedAction]
        
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
