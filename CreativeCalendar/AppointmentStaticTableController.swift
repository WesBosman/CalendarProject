
//
//  AppointmentStaticTableController.swift
//  CreativeCalendar
//
//  Created by Wes on 4/19/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

extension Date
{
    func isInRange(_ from: Date, to:Date) -> Bool
    {
        if(self.compare(from) == ComparisonResult.orderedDescending || self.compare(from) == ComparisonResult.orderedSame)
        {
            if(self.compare(to) == ComparisonResult.orderedAscending || self.compare(to) == ComparisonResult.orderedSame)
            {
                // date is in range
                return true
            }
        }
        // date is not in range
        return false
    }
}

class AppointmentStaticTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var appointmentNameTextField: UITextField!
    @IBOutlet weak var startingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentStartDate: UIDatePicker!
    @IBOutlet weak var endingTimeDetailLabel: UILabel!
    @IBOutlet weak var appointmentEndDate: UIDatePicker!
    @IBOutlet weak var appointmentLocationTextBox: UITextField!
    @IBOutlet weak var additionalInfoTextBox: UITextView!
    @IBOutlet weak var appointmentPicker: UIPickerView!
    @IBOutlet weak var otherTextField: UITextField!
    @IBOutlet weak var repeatAppointmentTitle: UILabel!
    @IBOutlet weak var repeatAppointmentRightDetail: UILabel!
    @IBOutlet weak var otherEnterButton: UIButton!
    @IBOutlet weak var alertAppointmentRightDetail: UILabel!
    @IBOutlet weak var alertAppointmentTitle: UILabel!
    @IBOutlet weak var typeOfAppointmentRightDetail: UILabel!
    
    fileprivate var startDatePickerHidden = false
    fileprivate var endDatePickerHidden = false
    fileprivate var appointmentTypeHidden = false
    fileprivate var otherIsHidden = false
    
    fileprivate let typeOfAppointments = ["Family" , "Medical" , "Recreational" , "Exercise" , "Medication Times" , "Social Event" , "Leisure" , "Household", "Work", "Physical Therapy",
        "Occupational Therapy", "Speech Therapy", "Class","Self Care", "Other"]
    fileprivate let cellID: String = "AppointmentCells"
    fileprivate let dateFormat:DateFormatter = DateFormatter().dateWithTime
    fileprivate let db = DatabaseFunctions.sharedInstance
    fileprivate var startingDate:Date? = nil
    fileprivate var endingDate:  Date? = nil
    fileprivate var otherTextString: String = String()
    fileprivate let currentDate = Date()
    fileprivate var appointmentAlertTimes: [Date] = []
    fileprivate var startAndEndTimesTupleArray:[(start: Date, end: Date)] = []
    fileprivate var calendar = Calendar.current
    fileprivate let universalFormat: DateFormatter = DateFormatter().universalFormatter
    var selectedRepeat:String?{
        didSet{
            repeatAppointmentRightDetail.text = selectedRepeat
        }
    }
    var selectedAlert:String?{
        didSet{
            alertAppointmentRightDetail.text = selectedAlert
        }
    }
    
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
        
        otherEnterButton.layer.cornerRadius = 10
        otherEnterButton.layer.borderWidth = 2
        otherEnterButton.layer.borderColor = UIColor().defaultButtonColor.cgColor
        otherEnterButton.setTitleColor(UIColor.white, for: UIControlState())
        otherEnterButton.layer.backgroundColor = UIColor().defaultButtonColor.cgColor
        
        // Set the maximum and minimum dates for the date pickers
        appointmentStartDate.minimumDate = currentDate
        appointmentEndDate.minimumDate = currentDate
        appointmentStartDate.maximumDate = Date().calendarEndDate
        appointmentEndDate.maximumDate = Date().calendarEndDate
        
        appointmentNameTextField.placeholder = "Name of Appointment"
        appointmentLocationTextBox.placeholder = "Location of Appointment"
        repeatAppointmentTitle.text = "Schedule a repeating Appointment"
        alertAppointmentTitle.text = "Schedule an Alert"
        typeOfAppointmentRightDetail.text = typeOfAppointments[0]
        alertAppointmentRightDetail.text = AlertTableViewController()
                                                        .alertArray[0]
        repeatAppointmentRightDetail.text = RepeatTableViewController()
            .repeatArray[0]
        
        // Set the selected alert and the selected repeat
        selectedAlert = AlertTableViewController().alertArray[0]
        selectedRepeat = RepeatTableViewController().repeatArray[0]
        
        // Set some initial default text for the TextView so the user knows where to type.
        additionalInfoTextBox.text = "Additional Information..."
        additionalInfoTextBox.font = UIFont(name: "Helvetica", size: 18.0)
        additionalInfoTextBox.textColor = UIColor.lightGray
        otherTextField.placeholder = "Please enter the type of appointment"
    }
    
    // MARK - Picker View Methods
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typeOfAppointments[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typeOfAppointments.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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

    // This is for the text view delegate so that the user can tell where the additional info text box is.
    func textViewDidBeginEditing(_ textView: UITextView) {
        if additionalInfoTextBox.textColor == UIColor.lightGray{
            additionalInfoTextBox.text = nil
            additionalInfoTextBox.textColor = UIColor.black
        }
    }
    
    @IBAction func saveInNavBarPressed(_ sender: AnyObject) {
        print("Save Button in Nav Bar Pressed")
        // If additional info was left untouched set it to be an empty string.
        var additionalInfoString = additionalInfoTextBox.text!
        if additionalInfoString == "Additional Information..."{
            additionalInfoString = String()
        }
        print("Additional Info String: \(additionalInfoString)")
        
        
        // If all the required fields are filled in then save the appointment otherwise show an alert
        if ((!typeOfAppointmentRightDetail.text!.isEmpty) &&
            (!startingTimeDetailLabel.text!.isEmpty)      &&
            (!endingTimeDetailLabel.text!.isEmpty)        &&
            (!appointmentLocationTextBox.text!.isEmpty)   &&
            (!repeatAppointmentRightDetail.text!.isEmpty)){
            
            let start = universalFormat.string(from: appointmentStartDate.date)
            let end   = universalFormat.string(from: appointmentEndDate.date)
            let fullStart = universalFormat.string(from: appointmentStartDate.date)
            let fullEnd   = universalFormat.string(from: appointmentEndDate.date)
            
            print("Appointment Start -> \(start)")
            print("Appointment End   -> \(end)")
            print("Full Appointment Start -> \(fullStart)")
            print("Full Appointment End   -> \(fullEnd)")
            
            // Add the original appointment that the user entered into the database.
            let appointmentItem = AppointmentItem(type: otherTextString
                + typeOfAppointmentRightDetail.text!,
                                                  startTime:  startingDate!,
                                                  endTime:    endingDate!,
                                                  title:      appointmentNameTextField.text!,
                                                  location:   appointmentLocationTextBox.text!,
                                                  additional: additionalInfoString,
                                                  repeatTime: repeatAppointmentRightDetail.text!,
                                                  alertTime:  alertAppointmentRightDetail.text!,
                                                  isComplete:  false,
                                                  isCanceled:  false,
                                                  isDeleted:   false,
                                                  dateFinished:  nil,
                                                  cancelReason:  nil,
                                                  deleteReason:  nil,
                                                  UUID: UUID().uuidString)
            
            db.addToAppointmentDatabase(appointmentItem)
            
            if repeatAppointmentRightDetail.text != RepeatTableViewController().repeatArray[0]{
                self.makeRecurringAppointment(appointmentItem.repeating, start: Date().calendarStartDate, end: Date().calendarEndDate)
            }
            
            // If the user has scheduled a repeat appointment then this code will execute.
            print("Start and end tuple array is empty: \(startAndEndTimesTupleArray.isEmpty)")
            if !startAndEndTimesTupleArray.isEmpty{
                
                for (start, end) in startAndEndTimesTupleArray{
                    print("Start in Start and end tuple array : \(DateFormatter().dateWithTime.string(from: start))")
                    print("End in Start and end tuple array: \(DateFormatter().dateWithTime.string(from: end))")
                    
                    let appointmentItem = AppointmentItem(type: otherTextString
                        + typeOfAppointmentRightDetail.text!,
                                                          startTime: start,
                                                          endTime: end,
                                                          title: appointmentNameTextField.text!,
                                                          location: appointmentLocationTextBox.text!,
                                                          additional: additionalInfoString,
                                                          repeatTime: repeatAppointmentRightDetail.text!,
                                                          alertTime: alertAppointmentRightDetail.text!,
                                                          isComplete:  false,
                                                          isCanceled:  false,
                                                          isDeleted:   false,
                                                          dateFinished:  nil,
                                                          cancelReason:  nil,
                                                          deleteReason:  nil,
                                                          UUID: UUID().uuidString)
                    
                    db.addToAppointmentDatabase(appointmentItem)
                    
                }
            }
            
            _ = self.navigationController?.popToRootViewController(animated: true)
        }
            
            // Let the user know that some required fields are not filled in
        else{
            let someFieldMissing = UIAlertController(title: "Missing Required Fields", message: "One or more of the reqired fields marked with an asterisk has not been filled in", preferredStyle: .alert)
            someFieldMissing.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                // Essentially do nothing. Unless we want to print some sort of log message.
            }))
            self.present(someFieldMissing, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func otherButtonPressed(_ sender: AnyObject) {
        if ((otherTextField.text!.isEmpty) ||
            (otherTextField.placeholder == "Please enter the type of appointment")){
            otherTextField.placeholder = "Please enter the type of appointment here"
        }
        else{
            typeOfAppointmentRightDetail.text = otherTextField.text
            toggleOther()
            toggleAppointmentDropDown()
        }
    }
    
    // Update the right detail start date when the user moves date or time.
    @IBAction func startDatePickerAction(_ sender: AnyObject) {
        startDatePickerDidChange()
    }
    // Update the right detail of the end time when the user moves the date or time.
    @IBAction func endDatePickerAction(_ sender: AnyObject) {
        endDatePickerDidChange()
    }
    
    @IBAction func unwindWithAppointmentRepeat(segue: UIStoryboardSegue){
        print("Unwind with appointment repeat segue")
        if let repeatVC = segue.source as? RepeatTableViewController{
            if let selectedR = repeatVC.repeatToPass{
                print("Selected Repeat => \(selectedR)")
                selectedRepeat = selectedR
            }
        }
    }
    
    @IBAction func unwindWithAppointmentAlert(segue:UIStoryboardSegue){
        if let alertVC = segue.source as? AlertTableViewController{
            print("Unwind with appointment alert segue")
            if let selectedA = alertVC.alertToPass{
                print("Selected Alert => \(selectedA)")
                selectedAlert = selectedA
            }
        }
    }
    
    
    // Want to make a method for calculating the 11:59 of the current start date that has been indicated by the start date picker
    func calcMaxEndDate(start: Date) -> Date{
        let todaysStringDate = universalFormat.string(from: start)
        print("Todays String Date \(todaysStringDate)")
        
        // Return the 11:59:59 PM for the current start date
        let tonight = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: start)
        print("Tonight \(dateFormat.string(from: tonight!))")
        
        return tonight!
    }
    
    func zeroSecondsForDate(date: Date) -> Date{
        let calendar = Calendar(identifier: .gregorian)
        var dateComp = DateComponents()
        dateComp.hour = calendar.component(.hour, from: date)
        dateComp.minute  = calendar.component(.minute, from: date)
        let newDate = calendar.date(bySettingHour: dateComp.hour!, minute: dateComp.minute!, second: 0, of: date)
        let newDateAsString = DateFormatter().universalFormatter.string(from: newDate!)
        print("New Zero'd appointment date -> \(newDateAsString)")
        return newDate!
    }
    
    func startDatePickerDidChange(){
        print("Changing the start date picker")
        startingDate = appointmentStartDate.date
        
        // Zero out the seconds for the start date
        startingDate = zeroSecondsForDate(date: startingDate!)
        
        // Set the detail label
        startingTimeDetailLabel.text = dateFormat.string(from: startingDate!)
        
        // Prevent the end date from being before the start date
        appointmentEndDate.minimumDate = startingDate!
        
        // Set the appointment ending date
        appointmentEndDate.date = startingDate!
        
        endingDate = startingDate!
        
        // Update the detail label
        endingTimeDetailLabel.text = dateFormat.string(from: startingDate!)
        
        // Prevent the end date from being outside the given day
        appointmentEndDate.maximumDate = calcMaxEndDate(start: startingDate!)
    }
    
    func endDatePickerDidChange(){
        print("Changing the end date picker")
        endingDate = appointmentEndDate.date
        endingDate = zeroSecondsForDate(date: endingDate!)
        endingTimeDetailLabel.text = dateFormat.string(from: endingDate!)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)

        if (indexPath as NSIndexPath).section == 0 && (indexPath as NSIndexPath).row == 0{
            appointmentNameTextField.becomeFirstResponder()
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        else if (indexPath as NSIndexPath).section == 3 && (indexPath as NSIndexPath).row == 0{
            appointmentLocationTextBox.becomeFirstResponder()
            cell?.selectionStyle = UITableViewCellSelectionStyle.none
        }
        // Appointment drop down
        else if (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 0{
            toggleAppointmentDropDown()
        }
        // Starting date picker
        else if (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 0{
            toggleStartDatePicker()
        }
        // Ending date picker
        else if (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 2{
            toggleEndDatePicker()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // This method hides the cells for the larger data collection objects
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        // Hide the cell beneath the appointment type label
        if appointmentTypeHidden && (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 1{
            return 0
        }
        // Hide the stating date picker
        else if startDatePickerHidden && (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 1{
            return 0
        }
        // Hide ending date picker
        else if endDatePickerHidden && (indexPath as NSIndexPath).section == 2 && (indexPath as NSIndexPath).row == 3{
            return 0
        }
        // Hide the other tableview cell
        else if otherIsHidden && (indexPath as NSIndexPath).section == 1 && (indexPath as NSIndexPath).row == 2{
            return 0
        }
        // Return the normal height otherwise
        else{
            return super.tableView(tableView, heightForRowAt: indexPath)
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
    
    
    func makeRecurringAppointment(_ interval:String, start: Date, end: Date){
        print("Make New Notification Interval: \(interval)")
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        
        switch(interval){
            case "Never":
                dateComponents.day = 0
                break
            case "Every Day":
                dateComponents.day = 1
                break
            case "Every Week":
                dateComponents.day = 7
                break
            case "Every Two Weeks":
                dateComponents.day = 14
                break
            case "Every Month":
                dateComponents.day = 28
                break
            default:
                break
        }
        // Get the time for the users appointment
        let endDate = Date().calendarEndDate
        let newStart = (calendar as NSCalendar).date(byAdding: dateComponents, to: start, options: .matchStrictly)
        let newEnd = (calendar as NSCalendar).date(byAdding: dateComponents, to: end, options: .matchStrictly)
        
        // Add the new start and end time to this array of tuples
        startAndEndTimesTupleArray.append((start: newStart!, end: newEnd!))
        
        // If the new date is still within range of the calendar boundary dates then call this method again
        if((newStart?.isInRange(startingDate!, to: endDate) == true)
            && newEnd?.isInRange(startingDate!, to: endDate) == true){
            
            makeRecurringAppointment(interval, start: newStart!, end: newEnd!)
        }
    }
    
    // MARK - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Want to pass in the values for alert and repeats
        // If the segue goes to repeats
        if segue.identifier == "toRepeatAppointment"{
            let destinationVC = segue.destination as! RepeatTableViewController
            destinationVC.repeatToPass = selectedRepeat
        }
        else if segue.identifier == "toAlertAppointment"{
            let destinationVC = segue.destination as! AlertTableViewController
            destinationVC.alertToPass = selectedAlert
        }
    }
}
