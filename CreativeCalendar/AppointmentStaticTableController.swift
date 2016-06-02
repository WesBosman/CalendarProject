//
//  AppointmentStaticTableController.swift
//  CreativeCalendar
//
//  Created by Wes on 4/19/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AppointmentStaticTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{
    
    @IBOutlet weak var appointmentNameDetailLabel: UILabel!
    @IBOutlet weak var startingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentStartDate: UIDatePicker!
    @IBOutlet weak var appointmentLocationDetailLabel: UILabel!
    private var startDatePickerHidden = false
    private var endDatePickerHidden = false
    private var appointmentTypeHidden = false
    private var appointmentNameHidden = false
    private var appointmentLocationHidden = false
    let typeOfAppointments = ["Family" , "Doctor" , "Recreational" , "Exercise" , "Medications times" , "Social Event" , "Leisure" , "Household"]
    private let cellID: String = "AppointmentCells"
    @IBOutlet weak var endingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentEndDate: UIDatePicker!
    @IBOutlet weak var nameOfAppointmentTextBox: UITextField!
    @IBOutlet weak var locationOfAppointmentTextBox: UITextField!
    @IBOutlet weak var additionalInfoTextBox: UITextView!
    @IBOutlet weak var appointmentPicker: UIPickerView!
    @IBOutlet weak var typeOfAppointmentRightDetail: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the initial positions for the cells and date pickers to be hidden.
        toggleNameOfEvent()
        toggleAppointmentDropDown()
        toggleLocationOfEvent()
        startDatePickerDidChange()
        endDatePickerDidChange()
        toggleStartDatePicker()
        toggleEndDatePicker()
        // Set the data source and delegate for the appointment picker
        appointmentPicker.dataSource = self
        appointmentPicker.delegate = self
        additionalInfoTextBox.delegate = self
        // Make the right details for the location and name empty at start
        appointmentNameDetailLabel.text = " "
        appointmentLocationDetailLabel.text = " "
        // Set the initial type of appointment to the first object when clicked
        typeOfAppointmentRightDetail.text = typeOfAppointments[0]
        // Set some initial default text for the TextView so the user knows where to type.
        additionalInfoTextBox.text = "Additional Information..."
        additionalInfoTextBox.textColor = UIColor.lightGrayColor()
        //appointmentPicker.backgroundColor = UIColor(red:0.90, green:0.93, blue:0.98, alpha:1.00)
        
    }
    
    // Picker View Functions for the types of appointments the user can pick from.
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
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
    
    // This is for the text view delegate so that the user can tell where the additional info text box is.
    func textViewDidBeginEditing(textView: UITextView) {
        if additionalInfoTextBox.textColor == UIColor.lightGrayColor(){
            additionalInfoTextBox.text = nil
            additionalInfoTextBox.textColor = UIColor.blackColor()
        }
    }
    
    // Update the right detail of the name of the event
    @IBAction func enterButtonPressed(sender: AnyObject) {
        appointmentNameDetailLabel.text = nameOfAppointmentTextBox.text
        toggleNameOfEvent()
    }
    
    // Pass the information from this view to the previous view
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        // If all the required fields are filled in then save the appointment otherwise show an alert
        if ((!appointmentNameDetailLabel.text!.isEmpty) && (!typeOfAppointmentRightDetail.text!.isEmpty) &&
            (!startingTimeDetailLabel.text!.isEmpty) && (!endingTimeDetailLabel.text!.isEmpty) &&
            (!appointmentLocationDetailLabel.text!.isEmpty)){
        
            let appointmentItem = AppointmentItem(startTime: appointmentStartDate.date,
                                              endTime: appointmentEndDate.date,
                                              title: appointmentNameDetailLabel.text!,
                                              location: appointmentLocationDetailLabel.text!,
                                              additional: additionalInfoTextBox.text!,
                                              UUID: NSUUID().UUIDString)
        
            AppointmentItemList.sharedInstance.addItem(appointmentItem)
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        else{
            let someFieldMissing = UIAlertController(title: "Missing Required Fields", message: "One or more of the reqired fields marked with an asterisk has not been filled in", preferredStyle: .Alert)
            someFieldMissing.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) in
                    // Essentially do nothing. Unless we want to print some sort of log message.
                    //print("Action for stoping the saving of incomplete appointment form")
                }))
            self.presentViewController(someFieldMissing, animated: true, completion: nil)
        }
        
    }
    @IBAction func locationButtonPressed(sender: AnyObject) {
        appointmentLocationDetailLabel.text = locationOfAppointmentTextBox.text
        toggleLocationOfEvent()
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
        // Name of the event/appointment
        if indexPath.section == 0 && indexPath.row == 0{
            toggleNameOfEvent()
        }
        // Appointment drop down
        else if indexPath.section == 1 && indexPath.row == 0{
            toggleAppointmentDropDown()
        }
        // Starting date picker
        else if indexPath.section == 2 && indexPath.row == 0{
            toggleStartDatePicker()
        }
        // Ending date picker
        else if indexPath.section == 2 && indexPath.row == 2{
            toggleEndDatePicker()
        }
        // Appointment location drop down
        else if indexPath.section == 3 && indexPath.row == 0{
            toggleLocationOfEvent()
        }
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // This method hides the cells for the larger data collection objects
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Hide the appointment name entry, text box and button
        if appointmentNameHidden && indexPath.section == 0 && indexPath.row == 1{
            return 0
        }
        // Hide the cell beneath the appointment type label
        else if appointmentTypeHidden && indexPath.section == 1 && indexPath.row == 1{
            return 0
        }
        // Hide the stating date picker
        else if startDatePickerHidden && indexPath.section == 2 && indexPath.row == 1{
            return 0
        }
        // Hide ending date picker
        else if endDatePickerHidden && indexPath.section == 2 && indexPath.row == 3{
            return 0
        }
        // Hide the location entry, text box and button
        else if appointmentLocationHidden && indexPath.section == 3 && indexPath.row == 1{
            return 0
        }
        // Return the normal height otherwise
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
    
    func toggleLocationOfEvent(){
        appointmentLocationHidden = !appointmentLocationHidden
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

