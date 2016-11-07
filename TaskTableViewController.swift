//
//  TaskTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/12/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit


class TaskTableViewController: UITableViewController {
    fileprivate let taskId = "TaskCells"
    fileprivate var taskList:[TaskItem] = []
    fileprivate var selectedIndexPath = IndexPath?.self
    fileprivate let db = DatabaseFunctions.sharedInstance
    fileprivate var taskSections: [String] = []
    fileprivate let taskDateFormatter = DateFormatter().dateWithoutTime
    var taskDayForSections: Dictionary<String, [TaskItem]> = [:]
    weak var actionToEnable: UIAlertAction?
    fileprivate let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the left navigation button to be the edit button.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blue
        NotificationCenter.default
            .addObserver(self, selector: #selector(TaskTableViewController.refreshList), name: NSNotification.Name(rawValue: "TaskListShouldRefresh"), object: nil)
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(named: "Tasks"), tag: 3)
    }

    
    // View did appear needs to be called because we animated the view from the static table save button being pressed.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        refreshList()
    }
    
    // Refresh the list of tasks so that the new one gets properly sorted in ascending order.
    func refreshList(){
        taskList = db.getAllTasks()
        // Sort the task list based on the estimated completion date
        taskList = taskList.sorted(by: {$0.estimateCompletionDate.compare($1.estimateCompletionDate as Date) == ComparisonResult.orderedAscending})
        
        for task in taskList{
            let dateForSectionAsString = taskDateFormatter.string(from: task.estimateCompletionDate)
            
            if !(taskSections.contains(dateForSectionAsString)){
                taskSections.append(dateForSectionAsString)
//                print("Task Section Date: \(dateForSectionAsString)")
            }
        }
        
        for section in taskSections{
            
            // Get tasks from database based on date
            taskList = db.getTaskByDate(section, formatter: taskDateFormatter)
            
            // Set the task dictionary up
            taskDayForSections.updateValue(taskList, forKey: section)
            
            // Set up the global dictionary
            GlobalTasks.taskDictionary = taskDayForSections
        }
        
        // Dont let the user add more than 64 tasks in one day
        if taskList.count > 64{
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Section Methods
    override func numberOfSections(in tableView: UITableView) -> Int {
        return taskDayForSections.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskDayForSections[taskSections[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !taskSections[section].isEmpty{
            return taskSections[section]
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            return 0.0
        }
        else{
            return 30.0
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            return nil
        }
        else{
            return tableView.headerView(forSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor().defaultButtonColor
        header.textLabel?.textColor = UIColor.white
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskId, for: indexPath) as! TaskCell
//        let taskItem = taskList[indexPath.row] as TaskItem
        let tableSection = taskDayForSections[taskSections[(indexPath as NSIndexPath).section]]
        let taskItem = tableSection![(indexPath as NSIndexPath).row]
        
        // Configure the cell...
        cell.taskCompleted(taskItem)
        cell.taskTitle.text = "Event: \(taskItem.taskTitle)"
        cell.taskCompletionDate.text = "Complete by: \(DateFormatter().dateWithTime.string(from: taskItem.estimateCompletionDate))"
        cell.taskSubtitle.text = "Additional Info: \(taskItem.taskInfo)"
        cell.taskAlert.text = "Alert: \(taskItem.alert)"
        
        // If the task item is past due color it red
        if taskItem.isOverdue{
            cell.taskCompletionDate.textColor = UIColor.red
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let tableSection = taskDayForSections[taskSections[(indexPath as NSIndexPath).section]]
        var taskForAction = tableSection![(indexPath as NSIndexPath).row] as TaskItem
        let taskCellForAction = tableView.cellForRow(at: indexPath) as! TaskCell
        let exitMenu = UIAlertAction(title: "Exit Menu", style: .cancel, handler: nil)
        
        // Make custom actions for delete, cancel and complete.
        let deletedAction = UITableViewRowAction(style: .default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            let deleteOptions = UIAlertController(title: "Delete Task", message: "Are you sure you want to delete the task: \(taskForAction.taskTitle)?", preferredStyle: .alert)
            deleteOptions.addTextField(configurationHandler: {(textField) in
                textField.placeholder = "Reason for Delete"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            })
            
            let deleteTask = UIAlertAction(title: "Delete Task", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                
                let deleteAllTasksController = UIAlertController(title: "Delete", message: "Would you like to delete all tasks of this type with this title", preferredStyle: .alert)
                
                // Delete all tasks
                let deleteAllAction = UIAlertAction(title: "Delete All Tasks", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                    
                    // Confirmation controller
                    let confirmationController = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete All Tasks with the title: \(taskForAction.taskTitle)", preferredStyle: .alert)
                    
                    let yesConfirmation = UIAlertAction(title: "Yes", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                        
                        // Delete the row from the data source
                        // Get all elements with the same title and type
                        for key in self.taskDayForSections.keys{
                            // Get the section key
                            if let k = self.taskDayForSections[key]{
                                // Get the appointment based on the key
                                for task in k{
                                    // If the appointment title is equal to the one we are deleting
                                    // Then remove it
                                    if task.taskTitle == taskForAction.taskTitle
                                        && task.taskInfo == taskForAction.taskInfo{
                                        
                                        if let index = k.index(where: {$0.taskTitle == taskForAction.taskTitle}){
                                            self.taskDayForSections[key]?.remove(at: index)
                                            
                                        }
                                    }
                                }
                            }
                        }
                        taskForAction.deleted = true
                        taskForAction.deletedReason = deleteOptions.textFields![0].text ?? ""
                        self.db.removeAllTasksOfSameType(taskForAction, option: "delete")
                        self.tableView.reloadData()
                        
                        
                    })
                    
                    let noConfirmation = UIAlertAction(title: "No", style: .cancel, handler: nil)
                    
                    confirmationController.addAction(yesConfirmation)
                    confirmationController.addAction(noConfirmation)
                    self.present(confirmationController, animated: true, completion: nil)

                
                
                })
                
                // Delete only that task
                let deleteOneAction = UIAlertAction(title: "Delete This Task", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                    
                    // Confirmation controller
                    let confirmationController = UIAlertController(title: "Delete Confirmation", message: "Are you sure you want to delete this task with the title: \(taskForAction.taskTitle)", preferredStyle: .alert)
                    
                    let yesConfirmation = UIAlertAction(title: "Yes", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                        
                        // Delete the row from the data source
                        let key = self.taskSections[indexPath.section]
                        print("Key for removal: \(key)")
                        self.taskDayForSections[key]?.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .fade)
                        
                        //Delete from database
                        taskForAction.completed = false
                        taskForAction.canceled = false
                        taskForAction.deleted = true
                        taskForAction.deletedReason = deleteOptions.textFields![0].text ?? ""
                        self.db.updateTask(taskForAction)

                        
                    })
                    
                    let noConfirmation = UIAlertAction(title: "No", style: .cancel, handler: nil)
                    
                    confirmationController.addAction(yesConfirmation)
                    confirmationController.addAction(noConfirmation)
                    self.present(confirmationController, animated: true, completion: nil)
                    
                })
                
                let exitAction = UIAlertAction(title: "Exit Menu", style: .cancel, handler: nil)
                
                deleteAllTasksController.addAction(deleteAllAction)
                deleteAllTasksController.addAction(deleteOneAction)
                deleteAllTasksController.addAction(exitAction)
                self.present(deleteAllTasksController, animated: true, completion: nil)
                
                
            })
            self.actionToEnable = deleteTask
            self.actionToEnable?.isEnabled = false
            deleteOptions.addAction(deleteTask)
            deleteOptions.addAction(exitMenu)
            self.present(deleteOptions, animated: true, completion: nil)
        })
        
        
        let canceledAction = UITableViewRowAction(style: .default, title: "Cancel", handler: {(action:UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            let cancelOptions = UIAlertController(title: "Cancel Task", message: "Would you like to cancel the task: \(taskForAction.taskTitle)", preferredStyle: .alert)
            cancelOptions.addTextField(configurationHandler: {(textField) in
                textField.placeholder = "Reason for Cancel"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), for: .editingChanged)
            })

            let cancelAction = UIAlertAction(title: "Cancel Task", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Cancel Appointment
                taskForAction.completed = false
                taskForAction.canceled = true
                taskForAction.deleted = false
                taskForAction.canceledReason = cancelOptions.textFields![0].text ?? ""
                taskCellForAction.taskCompleted(taskForAction)
                self.db.updateTask(taskForAction)
                
            })
            self.actionToEnable = cancelAction
            self.actionToEnable?.isEnabled = false
            cancelOptions.addAction(cancelAction)
            cancelOptions.addAction(exitMenu)
            self.present(cancelOptions, animated: true, completion: nil)
        })
        
        
        let completedAction = UITableViewRowAction(style: .default, title: "Complete", handler: {(action:UITableViewRowAction!, indexPath: IndexPath!) -> Void in
            
            let completeOptions = UIAlertController(title: "Complete Task", message: "Have you completed task: \(taskForAction.taskTitle)", preferredStyle: .alert)
            
            // Appointment was completed.
            let completeAction = UIAlertAction(title: "Complete Task", style: .destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Complete the appointment and update its image.
                taskForAction.completed = true
                taskForAction.canceled = false
                taskForAction.deleted = false
                taskCellForAction.taskCompleted(taskForAction)
                self.db.updateTask(taskForAction)
                
            })            
            completeOptions.addAction(completeAction)
            completeOptions.addAction(exitMenu)
            self.present(completeOptions, animated: true, completion: nil)
        })
        
        completedAction.backgroundColor = UIColor.blue
        canceledAction.backgroundColor = UIColor.orange
        return [deletedAction, canceledAction, completedAction]
        
    }
    
    func textChanged(_ sender:UITextField) {
        self.actionToEnable?.isEnabled = (sender.text!.isEmpty == false)
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
