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
    var appointmentTestList:[AppointmentItem] = [];
    var appointmentDateSections = Set<NSDate>()
    var selectedIndexPath: NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor(red:0.90, green:0.93, blue:0.98, alpha:1.00)
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blueColor()
        NSNotificationCenter
            .defaultCenter()
            .addObserver(self, selector: #selector(AppointmentTableViewController.refreshList), name: "AppointmentListShouldRefresh", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    // Refresh the list do not let more than 64 notifications on screen at any one time.
    func refreshList(){
        appointmentTestList = AppointmentItemList.sharedInstance.allItems()
        for app in appointmentTestList{
            appointmentDateSections.insert(app.startingTime)
        }
        print(appointmentDateSections)
        
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
        return 1 //appointmentDateSections.count
    }
    
    // Make a cell where the title and the start date are retrieved from the save button being pressed
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // The cell is a custom appointment cell that we have created.
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! AppointmentCell
        // The cell gets updated from the information stored in the appointment item object
        let appItem = appointmentTestList[indexPath.row] as AppointmentItem
        
        // If the current time is later than the starting time of the appointment then the color is set to red.
        if (appItem.isOverdue) {
            cell.appointmentStart.textColor = UIColor.redColor()
        }
        // If its not true that the event has happened the text should be black
        else {
            cell.appointmentStart.textColor = UIColor.blackColor()
        }
        
        let startFormatter = NSDateFormatter()
        let endFormatter = NSDateFormatter()
        startFormatter.dateFormat = "'Starting Time: ' MMM dd 'at' h:mm a"
        endFormatter.dateFormat = "'Ending Time:  ' MMM dd 'at' h:mm a"
        
        cell.appointmentTitle.text = "Event: \(appItem.title)"
        cell.appointmentStart.text = startFormatter.stringFromDate(appItem.startingTime)
        cell.appointmentEnd.text = endFormatter.stringFromDate(appItem.endingTime)
        cell.appointmentLocation.text = "Location:        \(appItem.appLocation)"
        cell.appointmentAdditionalInfo.text = "Additional Info: \(appItem.additionalInfo)"
        
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
            let itemToDelete = appointmentTestList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            AppointmentItemList.sharedInstance.removeItem(itemToDelete)
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
    }

    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the Home View.
        /**
        if segue.identifier == "Home"{
            let view = segue.destinationViewController as! HomeViewController
            let indexPath = sender as! NSIndexPath
            
            
        }
        **/
    }
}
