
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
    private var repeatAppointmentTableHidden = false
    let typeOfAppointments = ["Family" , "Medical" , "Recreational" , "Exercise" , "Medications times" , "Social Event" , "Leisure" , "Household", "Work", "Physical Therapy", "Occupational Therapy", "Speech Therapy", "Class", "Self Care", "Other"]
    private let cellID: String = "AppointmentCells"
    @IBOutlet weak var endingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentEndDate: UIDatePicker!
    @IBOutlet weak var appointmentLocationTextBox: UITextField!
    @IBOutlet weak var additionalInfoTextBox: UITextView!
    @IBOutlet weak var appointmentPicker: UIPickerView!
    @IBOutlet weak var typeOfAppointmentRightDetail: UILabel!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var repeatAppointmentTitle: UILabel!
    @IBOutlet weak var repeatAppointmentRightDetail: UILabel!
    @IBOutlet weak var repeatDaysTableView: UITableView!
    @IBOutlet weak var repeatDaysDone: UIButton!
    @IBOutlet weak var saveAppointment: UIButton!
    @IBOutlet weak var otherEnterButton: UIButton!
    
    let dateFormat = NSDateFormatter()
    let db = DatabaseFunctions.sharedInstance
    var startDate:NSDate? = nil
    var endDate: NSDate? = nil
    var otherTextString: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Sets the initial positions for the cells and date pickers to be hidden.
        toggleAppointmentDropDown()
        startDatePickerDidChange()
        endDatePickerDidChange()
        toggleStartDatePicker()
        toggleEndDatePicker()
        toggleOther()
        toggleRepeatAppointment()
        
        // Set the data source and delegate for the appointment picker
        appointmentPicker.dataSource = self
        appointmentPicker.delegate = self
        additionalInfoTextBox.delegate = self
        
        // Set the buttons borders shapes, widths and colors
        saveAppointment.layer.cornerRadius = 10
        saveAppointment.layer.borderWidth = 2
        saveAppointment.layer.borderColor = UIColor().defaultButtonColor.CGColor
        saveAppointment.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        saveAppointment.layer.backgroundColor = UIColor().defaultButtonColor.CGColor
        otherEnterButton.layer.cornerRadius = 10
        otherEnterButton.layer.borderWidth = 2
        otherEnterButton.layer.borderColor = UIColor().defaultButtonColor.CGColor
        otherEnterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        otherEnterButton.layer.backgroundColor = UIColor().defaultButtonColor.CGColor
        
        appointmentNameTextField.placeholder = "Name of Appointment"
        appointmentLocationTextBox.placeholder = "Location of Appointment"
        typeOfAppointmentRightDetail.text = typeOfAppointments[0]
        
        repeatAppointmentTitle.text = "Schedule a repeating Appointment"
        repeatAppointmentRightDetail.text = String()
        
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
        if  "Other" == typeOfAppointments[row] ||
            "Class" == typeOfAppointments[row] ||
            "Self Care" == typeOfAppointments[row]{
            
            if otherIsHidden{
                toggleOther()
            }
            
            // A switch statement for the type of appointment Other, Class, Self Care.
            // The other text string goes in front of the appointment as a label for the 
            // three categories where a user can enter their own appointment type.
            let value = typeOfAppointments[row]
            
            switch value {
            case "Other":
                otherTextString = "Other: "
            case "Class":
                otherTextString = "Class: "
            default:
                otherTextString = "Self Care: "
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
        
            let appointmentItem = AppointmentItem(type: otherTextString
                                                        + typeOfAppointmentRightDetail.text!,
                                                  startTime: startDate!,
                                                  endTime: endDate!,
                                                  title: appointmentNameTextField.text!,
                                                  location: appointmentLocationTextBox.text!,
                                                  additional: additionalInfoTextBox.text!,
                                                  isComplete:  false,
                                                  isCanceled:  false,
                                                  isDeleted:   false,
                                                  dateFinished:  nil,
                                                  UUID: NSUUID().UUIDString)
                    
            // IF the additional information text box has not been changed then add an empty string to that field of the database
            if additionalInfoTextBox.text == "Additional Information..."{
                let newAppointmentItem = AppointmentItem(type: appointmentItem.type,
                                                      startTime: startDate!,
                                                      endTime: endDate!,
                                                      title: appointmentItem.title,
                                                      location: appointmentItem.appLocation,
                                                      additional: "",
                                                      isComplete: false,
                                                      isCanceled: false,
                                                      isDeleted:  false,
                                                      dateFinished:  nil,
                                                      UUID: appointmentItem.UUID)
                db.addToAppointmentDatabase(newAppointmentItem)
            }
            // Otherwise add what is in the additional information text box.
            else{
                db.addToAppointmentDatabase(appointmentItem)
            }
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
        if ((otherTextField.text!.isEmpty) || (otherTextField.placeholder == "Please enter the type of appointment")){
            otherTextField.placeholder = "Please Enter the type of Appointment Here"
        }
        else{
            typeOfAppointmentRightDetail.text = otherTextField.text
            toggleOther()
            toggleAppointmentDropDown()
        }
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
    
    // This method works as it should.
    func calcNotificationTime(date:NSDate) -> NSDate{
        dateFormat.dateStyle = NSDateFormatterStyle.LongStyle
        dateFormat.timeStyle = .MediumStyle
        dateFormat.dateFormat = "MM/dd/yyyy h:mm a"
        let stringFromDate = dateFormat.stringFromDate(date)
        let dateFromString = dateFormat.dateFromString(stringFromDate)!
        return dateFromString
    }
    
    func startDatePickerDidChange(){
        let date = calcNotificationTime(appointmentStartDate.date)
        startDate = date
        startingTimeDetailLabel.text = dateFormat.stringFromDate(startDate!)
    }
    
    func endDatePickerDidChange(){
        let date = calcNotificationTime(appointmentEndDate.date)
        endDate = date
        endingTimeDetailLabel.text = dateFormat.stringFromDate(endDate!)
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
        else if indexPath.section == 5 && indexPath.row == 0{
            toggleRepeatAppointment()
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
        else if repeatAppointmentTableHidden && indexPath.section == 5 && indexPath.row == 1{
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
    
    // Toggle repeat appointment
    func toggleRepeatAppointment(){
        repeatAppointmentTableHidden = !repeatAppointmentTableHidden
        let defaults = NSUserDefaults.standardUserDefaults()
        if let r = defaults.arrayForKey("RepeatAppointmentCell"){
            var str: String = String()
            for rep in r{
                str += (rep as! String) + " "
                print("Rep: \(rep), Str: \(str)")
                repeatAppointmentRightDetail.text = str
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
}