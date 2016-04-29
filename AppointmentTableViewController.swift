//
//  AppointmentTableViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/12/16.
//  Followed a source code example on github for an accordian menu.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//  The appointment list is from a tutorial by Jason Newell

import UIKit

class AppointmentTableViewController: UITableViewController{
    
    let cellID = "AppointmentCells"
    @IBOutlet weak var titleOfAppointmentCell: UILabel!
    var appointmentTestList:[AppointmentItem] = [];
    var selectedIndexPath: NSIndexPath?
    @IBOutlet weak var subtitleOfAppointmentCell: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshList", name: "AppointmentListShouldRefresh", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    // Refresh the list.
    func refreshList(){
        appointmentTestList = AppointmentItemList.sharedInstance.allItems()
        if appointmentTestList.count > 64{
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        tableView.reloadData()
    }
    
    // Return the number of elements in the array
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentTestList.count
    }
    
    // Return 1 section
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Make a cell where the title and the start date are retrieved from the add segue
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! UITableViewCell // retrieve the prototype cell (subtitle style)
        let appItem = appointmentTestList[indexPath.row] as AppointmentItem
        cell.textLabel?.text = appItem.title as String!
        if (appItem.isOverdue) { // the current time is later than the to-do item's deadline
            cell.detailTextLabel?.textColor = UIColor.redColor()
        } else {
            cell.detailTextLabel?.textColor = UIColor.blackColor() // we need to reset this because a cell with red subtitle may be returned by dequeueReusableCellWithIdentifier:indexPath:
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "'Due' MMM dd 'at' h:mm a" // example: "Due Jan 01 at 12:00 PM"
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(appItem.deadline)
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            var itemToDelete = appointmentTestList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            AppointmentItemList.sharedInstance.removeItem(itemToDelete)
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "Home"{
            var view = segue.destinationViewController as! HomeViewController
            let homeAppointmentCell = tableView.dequeueReusableCellWithIdentifier("homeAppointmentCell")
            
            
            //view.appointmentViewTable.dataSource = AppointmentTableViewController()
        }
    }

}
