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
    
    private let cellID = "AppointmentCells"
    private var appointmentList:[AppointmentItem] = [];
    private var selectedIndexPath: NSIndexPath?
    private let db = DatabaseFunctions.sharedInstance
    private var appointmentDaySections: Dictionary<String, [AppointmentItem]> = [:]
    private let appointmentDateFormatter = NSDateFormatter().dateWithoutTime
    private var appointmentSections: [String] = []
    private let defaults = NSUserDefaults.standardUserDefaults()
    weak var actionToEnable:UIAlertAction?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem()
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
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
        // Get all appointments that are not marked as deleted.
        appointmentList = db.getAllAppointments()
        
        // Order the appointments based on their starting times.
        appointmentList = appointmentList.sort({$0.startingTime.compare($1.startingTime) == NSComparisonResult.OrderedAscending})
        
        for app in appointmentList{
            // Get the date from the appointment
            let appointmentDateForSectionAsString = appointmentDateFormatter.stringFromDate(app.startingTime)
            
            // If the appointment Date is not already in the appointment sections array add it
            if !appointmentSections.contains(appointmentDateForSectionAsString){
                appointmentSections.append(appointmentDateForSectionAsString)
            }
        }
        
        // Use the appointment sections array to get items from the database
        for str in appointmentSections{
            appointmentList = db.getAppointmentByDate(str, formatter: appointmentDateFormatter)
            
            // Add those items to the dictionary that the table view relies on
            appointmentDaySections.updateValue(appointmentList, forKey: str)
            
            defaults.setObject(appointmentList as? AnyObject, forKey: str)
        }
        
        // If there are more than 64 appointments today do not let the user add more appointments
        if appointmentList.count > 64{
            self.navigationItem.rightBarButtonItem?.enabled = false
        }
        
        // This sets the bage number back to zero when the view loads.
        self.tabBarController!.tabBar.items?[1].badgeValue = nil
        
        tableView.reloadData()
    }

    // MARK Section Header Methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appointmentDaySections[appointmentSections[section]]!.count
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return appointmentDaySections.keys.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return the section title as a date
        if !appointmentSections[section].isEmpty{
            return appointmentSections[section]
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
    
    // Make a cell where the title and the start date are retrieved from the save button being pressed
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // The cell is a custom appointment cell that we have created.
        let cell = tableView.dequeueReusableCellWithIdentifier(cellID, forIndexPath: indexPath) as! AppointmentCell
        let tableSection = appointmentDaySections[appointmentSections[indexPath.section]]
        let appItem = tableSection![indexPath.row]
        
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
        let startingTime = startFormatter.stringFromDate(appItem.startingTime)
        let endingTime = endFormatter.stringFromDate(appItem.endingTime)
        
        cell.appointmentCompleted(appItem)
        cell.appointmentTitle.text = "Event: \(appItem.title)"
        cell.appointmentType.text = "Type: \(appItem.type)"
        cell.appointmentStart.text = startingTime
        cell.appointmentEnd.text = endingTime
        cell.appointmentLocation.text = "Location: \(appItem.appLocation)"
        cell.appointmentAdditionalInfo.text = "Additional Info: \(appItem.additionalInfo)"
        cell.appointmentAlert.text = "Alert: \(appItem.alert)"
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, didEndEditingRowAtIndexPath indexPath: NSIndexPath) {
        tableView.reloadData()
    }
    
    // These are custom actions for dealing with the editing of an appointment
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let appointmentCellForAction = tableView.cellForRowAtIndexPath(indexPath) as! AppointmentCell
        let tableSection = appointmentDaySections[appointmentSections[indexPath.section]]
        var appointmentForAction = tableSection![indexPath.row] as AppointmentItem
        let exitMenu = UIAlertAction(title: "Exit Menu", style: .Cancel, handler: nil)
        
        // Make custom actions for delete, cancel and complete.
        let deletedAction = UITableViewRowAction(style: .Default, title: "Delete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let deleteOptions = UIAlertController(title: "Delete", message: "Are you sure you want to delete the appointment: \(appointmentForAction.title)?", preferredStyle: .Alert)
            deleteOptions.addTextFieldWithConfigurationHandler({(textField) in
                textField.placeholder = "Reason for Delete"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
            })

            
            let deleteAppointment = UIAlertAction(title: "Delete Appointment", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Delete the row from the data source
                let key = self.appointmentSections[indexPath.section]
                print("Key for removal: \(key)")
//                print("The value associated with the key: \(self.appointmentDaySections[key])")
                self.appointmentDaySections[key]?.removeAtIndex(indexPath.row)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                
                //Delete from database
                appointmentForAction.completed = false
                appointmentForAction.canceled = false
                appointmentForAction.deleted = true
                appointmentForAction.deletedReason = deleteOptions.textFields![0].text ?? ""
                self.db.updateAppointment(appointmentForAction)
                
            })
            self.actionToEnable = deleteAppointment
            deleteAppointment.enabled = false
            deleteOptions.addAction(deleteAppointment)
            deleteOptions.addAction(exitMenu)
            
            self.presentViewController(deleteOptions, animated: true, completion: nil)
        })
        
        
        let canceledAction = UITableViewRowAction(style: .Default, title: "Cancel", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let cancelOptions = UIAlertController(title: "Cancel Appointment", message: "Would you like to cancel the appointment: \(appointmentForAction.title)", preferredStyle: .Alert)
            
            cancelOptions.addTextFieldWithConfigurationHandler({(textField) in
                textField.placeholder = "Reason for Cancel"
                textField.addTarget(self, action: #selector(self.textChanged(_:)), forControlEvents: .EditingChanged)
            })
            
            // Appointment was canceled.
            let cancelAppointment = UIAlertAction(title: "Cancel Appointment", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Cancel Appointment 
                appointmentForAction.completed = false
                appointmentForAction.canceled = true
                appointmentForAction.deleted = false
                appointmentForAction.canceledReason = cancelOptions.textFields![0].text ?? ""
                appointmentCellForAction.appointmentCompleted(appointmentForAction)
                self.db.updateAppointment(appointmentForAction)
                
            })
            self.actionToEnable = cancelAppointment
            cancelAppointment.enabled = false
            cancelOptions.addAction(cancelAppointment)
            cancelOptions.addAction(exitMenu)
            
            self.presentViewController(cancelOptions, animated: true, completion: nil)
        })
        
        
        let completedAction = UITableViewRowAction(style: .Default, title: "Complete", handler: {(action:UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            
            let completeOptions = UIAlertController(title: "Complete Appointment", message: "Have you completed appointment: \(appointmentForAction.title)", preferredStyle: .Alert)
            
            // Appointment was completed.
            let completeAction = UIAlertAction(title: "Complete Appointment", style: .Destructive, handler: {(action: UIAlertAction) -> Void in
                
                // Complete the appointment and update its image.
                appointmentForAction.completed = true
                appointmentForAction.canceled = false
                appointmentForAction.deleted = false
                appointmentCellForAction.appointmentCompleted(appointmentForAction)
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
    
    func textChanged(sender:UITextField) {
        self.actionToEnable?.enabled = (sender.text!.isEmpty == false)
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
