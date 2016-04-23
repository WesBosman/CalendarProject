//
//  AppointmentStaticTableController.swift
//  CreativeCalendar
//
//  Created by Wes on 4/19/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AppointmentStaticTableViewController: UITableViewController{
    
 
    @IBOutlet weak var startingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentStartDate: UIDatePicker!
    private var startDatePickerHidden = false
    private var endDatePickerHidden = false
    @IBOutlet weak var endingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentEndDate: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the initial values for the date pickers.
        startDatePickerDidChange()
        endDatePickerDidChange()
        toggleStartDatePicker()
        toggleEndDatePicker()
        
    }
    // Update the right detail start date when the user moves date or time.
    @IBAction func startDatePickerAction(sender: AnyObject) {
        startDatePickerDidChange()
    }
    // Update the right detail of the end time when the user moves the date or time.
    @IBAction func endDatePickerAction(sender: AnyObject) {
        endDatePickerDidChange()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func startDatePickerDidChange(){
        startingTimeDetailLabel.text = NSDateFormatter.localizedStringFromDate(appointmentStartDate.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
        
    }
    
    func endDatePickerDidChange(){
        endingTimeDetailLabel.text = NSDateFormatter.localizedStringFromDate(appointmentEndDate.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2 && indexPath.row == 0{
            toggleStartDatePicker()
        }
        else if indexPath.section == 2 && indexPath.row == 2{
            toggleEndDatePicker()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if startDatePickerHidden && indexPath.section == 2 && indexPath.row == 1{
            return 0
        }
        else if endDatePickerHidden && indexPath.section == 2 && indexPath.row == 3{
            return 0
        }
        else{
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    // Toggle the starting date picker
    func toggleStartDatePicker(){
        startDatePickerHidden = !startDatePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }
    // Toggle the ending date picker
    func toggleEndDatePicker(){
        endDatePickerHidden = !endDatePickerHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    // MARK: - Table view data source
    /**
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }
**/

    
}

