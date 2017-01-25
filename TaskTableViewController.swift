//
//  TaskTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/12/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit


class TaskTableViewController: UITableViewController, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    fileprivate let taskId = "TaskCells"
    fileprivate var selectedIndexPath = IndexPath?.self
    fileprivate let db = DatabaseFunctions.sharedInstance
    fileprivate let taskDateFormatter = DateFormatter().dateWithoutTime
    weak var actionToEnable: UIAlertAction?
    fileprivate let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the left navigation button to be the edit button.
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        // This will refresh the table view when a notification arrives
        NotificationCenter.default
            .addObserver(self, selector: #selector(TaskTableViewController.refreshList), name: NSNotification.Name(rawValue: "TaskListShouldRefresh"), object: nil)
        
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
//        tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(named: "Tasks"), tag: 3)
    }

    
    // View did appear needs to be called because we animated the view from the static table save button being pressed.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        refreshList()
    }
    
    // Refresh the list of tasks so that the new one gets properly sorted in ascending order.
    func refreshList(){        
        var taskList = db.getAllTasks()
        // Sort the task list based on the estimated completion date
        taskList = taskList.sorted(by: {$0.estimateCompletionDate.compare($1.estimateCompletionDate as Date) == ComparisonResult.orderedAscending})
        
        for task in taskList{
            let dateForSectionAsString = taskDateFormatter.string(from: task.estimateCompletionDate)
            
            if !(Tasks.taskSections.contains(dateForSectionAsString)){
                Tasks.taskSections.append(dateForSectionAsString)
            }
        }
        
        // Sort the keys of the dictionary that contain string dates
        Tasks.taskSections = Tasks.taskSections.sorted(by: {
            (left: String, right: String) -> Bool in
            return taskDateFormatter.date(from: left)?.compare(taskDateFormatter.date(from: right)!) == ComparisonResult.orderedAscending
        })
        
        for section in Tasks.taskSections{
            
            // Get tasks from database based on date
            taskList = db.getTaskByDate(section, formatter: taskDateFormatter)
            
            // Set the task dictionary up
            Tasks.taskDictionary.updateValue(taskList, forKey: section)
            
            // Set up the global dictionary
            Tasks.taskDictionary = Tasks.taskDictionary
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
    
    // MARK - Empty Table View Methods
        
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "No Tasks scheduled"
        let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .headline)]
        return NSAttributedString(string: str, attributes: attributes)
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        let str = "Please click the add button to schedule Tasks"
        let attributes = [NSFontAttributeName: UIFont.preferredFont(forTextStyle: .body)]
        return NSAttributedString(string: str, attributes: attributes)
    }
    
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        let image = UIImage(named: "Tasks")
        return image
    }

    // MARK: - Section Methods
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return Tasks.taskDictionary.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Tasks.taskDictionary[Tasks.taskSections[section]]!.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !(Tasks.taskSections[section].isEmpty){
            return Tasks.taskSections[section]
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
        header.contentView.backgroundColor = UIColor().taskColor
        header.textLabel?.textColor = UIColor.white
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: taskId, for: indexPath) as! TaskCell

        let tableSection = Tasks.taskDictionary[Tasks.taskSections[(indexPath as NSIndexPath).section]]
        let taskItem = tableSection![(indexPath as NSIndexPath).row]
        
        // Configure the cell...
        cell.taskCompleted(taskItem)
        cell.setTitle(title: taskItem.taskTitle)
        cell.setAdditional(additional: taskItem.taskInfo)
        cell.setAlert(alert: taskItem.alert)
        cell.setRepeating(rep: taskItem.repeating)
        cell.setEstimatedCompletedDate(date: DateFormatter().dateWithTime.string(from: taskItem.estimateCompletionDate))
        // If the task item is past due color it red
        if taskItem.isOverdue{
            cell.taskCompletionDate.textColor = UIColor.red
        }
        else{
            cell.taskCompletionDate.textColor = UIColor.black
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let tableSection = Tasks.taskDictionary[Tasks.taskSections[(indexPath as NSIndexPath).section]]
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
                        for key in Tasks.taskDictionary.keys{
                            // Get the section key
                            if let k = Tasks.taskDictionary[key]{
                                // Get the appointment based on the key
                                for task in k{
                                    // If the task title is equal to the one we are deleting
                                    // Then remove it
                                    if task.taskTitle == taskForAction.taskTitle
                                        && task.taskInfo == taskForAction.taskInfo{
                                        
                                        if let index = k.index(where: {$0.taskTitle == taskForAction.taskTitle}){
                                            print("Removing Task \(Tasks.taskDictionary[key]?.remove(at: index))")
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
                        let key = Tasks.taskSections[indexPath.section]
                        print("Key for removal: \(key)")
                        Tasks.taskDictionary[key]?.remove(at: indexPath.row)
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
                
                deleteAllTasksController.addAction(deleteOneAction)
                deleteAllTasksController.addAction(deleteAllAction)
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
    
    // For Canceling and Deleting Task Menus
    func textChanged(_ sender:UITextField) {
        self.actionToEnable?.isEnabled = (sender.text!.isEmpty == false)
    }
}
