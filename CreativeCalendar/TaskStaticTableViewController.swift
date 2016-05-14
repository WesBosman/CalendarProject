//
//  TaskStaticTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class TaskStaticTableViewController: UITableViewController {
    
    @IBOutlet weak var taskNameRightDetail: UILabel!
    @IBOutlet weak var taskAdditionalRightDetail: UILabel!
    private var taskNameHidden = false
    private var taskAdditionalInfoHidden = false
    @IBOutlet weak var titleOfTaskTextBox: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        taskAdditionalRightDetail.text = " "
        taskNameRightDetail.text = " "
        toggleNameOfTask()
        toggleAdditionalInfoOfTask()

    }
    // Display the name of the title in the right detail
    @IBAction func enterTaskTitlePressed(sender: AnyObject) {
        taskNameRightDetail.text = titleOfTaskTextBox.text
        toggleNameOfTask()
    }
    
    // Save the information to pass it to the previous view
    @IBAction func saveTaskPressed(sender: AnyObject) {
        let taskItem = TaskItem(title: taskNameRightDetail.text!,
                                info: taskAdditionalRightDetail.text!,
                                UUID: NSUUID().UUIDString)
        TaskItemList.sharedInstance.addItem(taskItem)
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    // Toggle the hidden feature of the task name
    func toggleNameOfTask(){
        taskNameHidden = !taskNameHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleAdditionalInfoOfTask(){
        taskAdditionalInfoHidden = !taskAdditionalInfoHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if taskNameHidden && indexPath.section == 0 && indexPath.row == 1{
            return 0
        }
        else if taskAdditionalInfoHidden && indexPath.section == 1 && indexPath.row == 1{
            return 0
        }
        return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Toggle name of task
        if indexPath.section == 0 && indexPath.row == 0{
            toggleNameOfTask()
        }
        // Additional information drop down
        else if indexPath.section == 1 && indexPath.row == 0{
            toggleAdditionalInfoOfTask()
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
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
