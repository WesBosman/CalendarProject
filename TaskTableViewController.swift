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
        let cell = tableView.dequeueReusableCellWithIdentifier(taskId, forIndexPath: indexPath) as! TaskTableViewCell
        let taskItem = taskList[indexPath.row] as TaskItem
        // Configure the cell...
        
        cell.taskName.text = "Event: \(taskItem.taskTitle)"
        cell.taskAdditionalInfo.text = "Additional Info: \(taskItem.taskInfo)"
        
        return cell
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let itemToDelete = taskList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            // Remove from database.
            let db = DatabaseFunctions.sharedInstance
            db.deleteFromDatabase("Tasks", uuid: itemToDelete.UUID)
            
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */


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
