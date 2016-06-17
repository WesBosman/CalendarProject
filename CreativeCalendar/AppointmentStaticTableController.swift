//
//  AppointmentStaticTableController.swift
//  CreativeCalendar
//
//  Created by Wes on 4/19/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class AppointmentStaticTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate{
    
    @IBOutlet weak var appointmentNameTextField: UITextField!
    @IBOutlet weak var startingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentStartDate: UIDatePicker!
    private var startDatePickerHidden = false
    private var endDatePickerHidden = false
    private var appointmentTypeHidden = false
    private var otherIsHidden = false
    let typeOfAppointments = ["Family" , "Doctor" , "Recreational" , "Exercise" , "Medications times" , "Social Event" , "Leisure" , "Household", "Other"]
    private let cellID: String = "AppointmentCells"
    @IBOutlet weak var endingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentEndDate: UIDatePicker!
    @IBOutlet weak var nameOfAppointmentTextBox: UITextField!
    @IBOutlet weak var appointmentLocationTextBox: UITextField!
    @IBOutlet weak var additionalInfoTextBox: UITextView!
    @IBOutlet weak var appointmentPicker: UIPickerView!
    @IBOutlet weak var typeOfAppointmentRightDetail: UILabel!
    @IBOutlet weak var otherTextField: UITextField!
    var startDate:NSDate? = nil
    var endDate: NSDate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the initial positions for the cells and date pickers to be hidden.
        toggleAppointmentDropDown()
        startDatePickerDidChange()
        endDatePickerDidChange()
        toggleStartDatePicker()
        toggleEndDatePicker()
        toggleOther()
        // Set the data source and delegate for the appointment picker
        appointmentPicker.dataSource = self
        appointmentPicker.delegate = self
        additionalInfoTextBox.delegate = self
        
        appointmentNameTextField.placeholder = "Name of Appointment"
        appointmentLocationTextBox.placeholder = "Location of Appointment"
        typeOfAppointmentRightDetail.text = typeOfAppointments[0]
        // Set some initial default text for the TextView so the user knows where to type.
        additionalInfoTextBox.text = "Additional Information..."
        additionalInfoTextBox.textColor = UIColor.lightGrayColor()
        otherTextField.placeholder = "Please enter the type of appointment"
        
    }
    
    // MARK - Picker View Methods
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
        // Show the other appointment cell when user highlights other.
        if typeOfAppointments[row] == "Other"{
            if otherIsHidden{
                toggleOther()
            }
        }
        // Hide the other appointment cell when user picks a different category.
        else{
            if !otherIsHidden{
                toggleOther()
            }
        }
    }
    
    // MARK - Table View Methods
    // This is for the text view delegate so that the user can tell where the additional info text box is.
    func textViewDidBeginEditing(textView: UITextView) {
        if additionalInfoTextBox.textColor == UIColor.lightGrayColor(){
            additionalInfoTextBox.text = nil
            additionalInfoTextBox.textColor = UIColor.blackColor()
        }
    }
    
    // Pass the information from this view to the previous view
    @IBAction func saveButtonPressed(sender: AnyObject) {
        
        // If all the required fields are filled in then save the appointment otherwise show an alert
        if ((!typeOfAppointmentRightDetail.text!.isEmpty) &&
            (!startingTimeDetailLabel.text!.isEmpty) &&
            (!endingTimeDetailLabel.text!.isEmpty) &&
            (!appointmentLocationTextBox.text!.isEmpty)){
        
            let appointmentItem = AppointmentItem(startTime: startDate!,
                                              endTime: endDate!,
                                              title: appointmentNameTextField.text!,
                                              location: appointmentLocationTextBox.text!,
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

    @IBAction func otherButtonPressed(sender: AnyObject) {
        typeOfAppointmentRightDetail.text = otherTextField.text
        toggleOther()
        toggleAppointmentDropDown()
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
    
    func calcNotificationTime(date:NSDate) -> NSDate{
        let calendar = NSCalendar.currentCalendar()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "MM/dd/yyy HH:mm"
        let dateComp = calendar.components([.Month, .Year, .Day, .Hour, .Minute], fromDate: date)
        let month = dateComp.month
        let day = dateComp.day
        let year = dateComp.year
        let hour = dateComp.hour
        let minute = dateComp.minute
        let newDate = String(month) + "/" + String(day) + "/" + String(year) + " " + String(hour) + ":" + String(minute)
        let dateFromString = dateFormat.dateFromString(newDate)
//        print("Date from String: \(dateFromString)")
//        print("New Date: \(newDate)")
        return dateFromString!
    }
    
    func startDatePickerDidChange(){
        let date = calcNotificationTime(appointmentStartDate.date)
        startDate = date
//        print("START DATE: \(startDate!)")
        
        startingTimeDetailLabel.text = NSDateFormatter.localizedStringFromDate(appointmentStartDate.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)

//        print("Appointment Start Date: \(appointmentStartDate.date)")
        
    }
    
    func endDatePickerDidChange(){
        let date = calcNotificationTime(appointmentEndDate.date)
        endDate = date
        endingTimeDetailLabel.text = NSDateFormatter.localizedStringFromDate(appointmentEndDate.date, dateStyle: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.ShortStyle)
//        print("Appointment End Date: \(appointmentEndDate.date)")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Appointment drop down
        if indexPath.section == 1 && indexPath.row == 0{
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
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // This method hides the cells for the larger data collection objects
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        // Hide the cell beneath the appointment type label
        if appointmentTypeHidden && indexPath.section == 1 && indexPath.row == 1{
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
        // Not sure how to get the correct picker view item.
        else if otherIsHidden && indexPath.section == 1 && indexPath.row == 2{
            return 0
        }
        // Return the normal height otherwise
        else{
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    // Toggle when picker selection is other
    func toggleOther(){
        otherIsHidden = !otherIsHidden
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
    
}