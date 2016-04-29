//
//  AppointmentStaticTableController.swift
//  CreativeCalendar
//
//  Created by Wes on 4/19/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AppointmentStaticTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var appointmentNameDetailLabel: UILabel!
    @IBOutlet weak var startingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentStartDate: UIDatePicker!
    private var startDatePickerHidden = false
    private var endDatePickerHidden = false
    private var appointmentTypeHidden = false
    private var appointmentNameHidden = false
    let typeOfAppointments = ["Family" , "Doctor" , "Recreational" , "Exercise" , "Medications times" , "Social Event" , "Leisure" , "Household"]
    private let cellID: String = "AppointmentCells"
    @IBOutlet weak var endingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentEndDate: UIDatePicker!
    //@IBOutlet weak var appointmentDropDown: UITableView!
    @IBOutlet weak var nameOfAppointmentTextBox: UITextField!
    @IBOutlet weak var appointmentPicker: UIPickerView!
    @IBOutlet weak var typeOfAppointmentRightDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the initial positions for the cells and date pickers.
        toggleNameOfEvent()
        toggleAppointmentDropDown()
        startDatePickerDidChange()
        endDatePickerDidChange()
        toggleStartDatePicker()
        toggleEndDatePicker()
        appointmentPicker.dataSource = self
        appointmentPicker.delegate = self
        //appointmentPicker.backgroundColor = UIColor(red:0.90, green:0.93, blue:0.98, alpha:1.00)
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return typeOfAppointments[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfAppointments.count
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeOfAppointmentRightDetail.text = typeOfAppointments[row]
    }
    
    
    // Update the right detail of the name of the event
    @IBAction func enterButtonPressed(sender: AnyObject) {
        appointmentNameDetailLabel.text = nameOfAppointmentTextBox.text
        toggleNameOfEvent()
    }
    
    // Pass the information from this view to the previous view
    @IBAction func saveButtonPressed(sender: AnyObject) {
        let appointmentItem = AppointmentItem(deadline: appointmentStartDate.date, title: appointmentNameDetailLabel.text!, UUID: NSUUID().UUIDString)
        AppointmentItemList.sharedInstance.addItem(appointmentItem)
        self.navigationController?.popToRootViewControllerAnimated(true)
        
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
        else if indexPath.section == 1 && indexPath.row == 0{
            toggleAppointmentDropDown()
        }
        else if indexPath.section == 0 && indexPath.row == 0{
            toggleNameOfEvent()
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
        else if appointmentTypeHidden && indexPath.section == 1 && indexPath.row == 1{
            return 0
        }
        else if appointmentNameHidden && indexPath.section == 0 && indexPath.row == 1{
            return 0
        }
        else{
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    // Toggle name of event drop down
    func toggleNameOfEvent(){
        appointmentNameHidden = !appointmentNameHidden
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    // Toggle appointment drop down
    func toggleAppointmentDropDown(){
        appointmentTypeHidden = !appointmentTypeHidden
        tableView.beginUpdates()
        tableView.endUpdates()
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

