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
    var appointmentList:[AppointmentItem] = [];
    var appointmentDateSections = Set<NSDate>()
    var selectedIndexPath: NSIndexPath?
    let db = DatabaseFunctions.sharedInstance

    
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
        tableView.allowsSelection = false
        
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Appointments", image: UIImage(named: "Appointment"), tag: 2)
    }

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshList()
    }
    
    // Refresh the list do not let more than 64 notifications on screen at any one time.
    func refreshList(){
        appointmentList = db.getAllAppointments()
        for app in appointmentList{
            appointmentDateSections.insert(app.startingTime)
        }
        print(appointmentDateSections)
        
        if appointmentList.count > 64{
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        
        // This sets the bage number back to zero when the view loads.
        self.tabBarController!.tabBar.items?[1].badgeValue = nil
        
        tableView.reloadData()
    }

    // Return the number of elements in the array
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentList.count
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
        let appItem = appointmentList[indexPath.row] as AppointmentItem
        
        // If the current time is later than the starting time of the appointment then the color is set to red.
        if (appItem.isOverdue) {
            cell.appointmentStart.textColor = UIColor.redColor()
        }
        // If its not true that the event has happened the text should be black
        else {
            cell.appointmentStart.textColor = UIColor.blackColor()
        }
        
        if appItem.completed == true{
            cell.appointmentCompletedImage.image = UIImage(named: "CircleTickedGreen")
        }
        else{
            cell.appointmentCompletedImage.image = UIImage(named: "CircleUntickedRed")
        }
        
        let startFormatter = NSDateFormatter()
        let endFormatter = NSDateFormatter()
        startFormatter.dateFormat = "'Starting Time: ' MMM dd 'at' h:mm a"
        endFormatter.dateFormat = "'Ending Time:  ' MMM dd 'at' h:mm a"
        let startingTime = startFormatter.stringFromDate(appItem.startingTime)
        let endingTime = endFormatter.stringFromDate(appItem.endingTime)
        
        cell.appointmentTitle.text = "Event: \(appItem.title)"
        cell.appointmentType.text = "Type: \(appItem.type)"
        cell.appointmentStart.text = startingTime
        cell.appointmentEnd.text = endingTime
        cell.appointmentLocation.text = "Location: \(appItem.appLocation)"
        cell.appointmentAdditionalInfo.text = "Additional Info: \(appItem.additionalInfo)"
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // These are custom actions for dealing with the editing of an appointment
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        var appointmentForAction = appointmentList[indexPath.row] as AppointmentItem
        let appointmentCellForAction = tableView.cellForRowAtIndexPath(indexPath) as! AppointmentCell
        
        // Make custom actions for delete, cancel and complete.
        let deletedAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let deleteOptions = UIAlertController(title: "Delete", message: "Are you sure you want to delete the appointment: \(appointmentForAction.title)?", preferredStyle: .Alert)
            
            let deleteAppointment = UIAlertAction(title: "Delete Appointment", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Delete the row from the data source
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                //Delete from database
                //self.db.deleteAppointmentAndNotification("Appointments", uuid: itemToDelete.UUID)
                appointmentCellForAction.appointmentNotCompleted(appointmentForAction)
                appointmentForAction.deleted = true
                self.db.updateAppointment(appointmentForAction)
                
            })
            let cancelDelete = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            deleteOptions.addAction(cancelDelete)
            deleteOptions.addAction(deleteAppointment)
            
            self.presentViewController(deleteOptions, animated: true, completion: nil)
        })
        
        
        let canceledAction = UITableViewRowAction(style: .Default, title: "Cancel", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let cancelOptions = UIAlertController(title: "Cancel Appointment", message: "Would you like to cancel the appointment: \(appointmentForAction.title)", preferredStyle: .Alert)
            
            // Appointment was canceled.
            let cancelAction = UIAlertAction(title: "Cancel Appointment", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Cancel Appointment 
                appointmentCellForAction.appointmentNotCompleted(appointmentForAction)
                appointmentForAction.canceled = true
                self.db.updateAppointment(appointmentForAction)
                
            })
            let abortCancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            
            cancelOptions.addAction(cancelAction)
            cancelOptions.addAction(abortCancel)
            
            self.presentViewController(cancelOptions, animated: true, completion: nil)
        })
        
        
        let completedAction = UITableViewRowAction(style: .Default, title: "Complete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let completeOptions = UIAlertController(title: "Complete Appointment", message: "Have you completed appointment: \(appointmentForAction.title)", preferredStyle: .Alert)
            
            // Appointment was completed.
            let completeAction = UIAlertAction(title: "Complete Appointment", style: .Default, handler: {(action: UIAlertAction) -> Void in
                
                // Complete the appointment and update its image.
                appointmentCellForAction.appointmentCompleted(appointmentForAction)
                appointmentForAction.completed = true
                self.db.updateAppointment(appointmentForAction)
                
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
        // Pass the selected object to the Home View.
        
        if segue.identifier == "Home"{
            let view = segue.destinationViewController as! HomeViewController
            let indexPath = sender as! NSIndexPath
            
            
        }
    }
    */
}
