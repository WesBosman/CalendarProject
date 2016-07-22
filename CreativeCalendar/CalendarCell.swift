//
//  CalendarCollectionViewCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/29/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.

import UIKit
import JTAppleCalendar

@IBDesignable
class CalendarCell: JTAppleDayCellView{

    @IBOutlet weak var dayLabel: UILabel!
    @IBInspectable var appointmentColor:UIColor = UIColor.redColor()
    @IBInspectable var taskColor:UIColor = UIColor.greenColor()
    @IBInspectable var journalColor:UIColor = UIColor.yellowColor()
    @IBInspectable var dotHeight: CGFloat = 15.0
    @IBInspectable var dotWidth: CGFloat = 15.0
    @IBInspectable var weekendDotColor:UIColor = UIColor(red: 132/255.0, green: 143/255.0, blue: 235/255.0, alpha: 1.0)
    @IBInspectable var weekdayDotColor:UIColor = UIColor(red: 32/255.0, green: 143/255.0, blue: 250/255.0, alpha: 1.0)
    @IBInspectable var selectedDotColor:UIColor = UIColor.orangeColor()
    var fillColorForCircle: UIColor = UIColor.clearColor()
    
    let formatter = NSDateFormatter()
    var cellState:CellState!
    
    var appointmentDictionary: Dictionary<String, String> = [:]
    var taskDictionary: Dictionary<String, String> = [:]
    var journalDictionary: Dictionary<String, String> = [:]
    
    var appointmentCounter = 0
    var taskCounter = 0
    var journalCounter = 0
    var drawAppointment:Bool = false
    var drawTask:Bool = false
    var drawJournal:Bool = false
    
    @IBOutlet weak var appointmentCounterLabel: UILabel!
    @IBOutlet weak var taskCounterLabel: UILabel!
    @IBOutlet weak var journalCounterLabel: UILabel!
    
    func setUpCellBeforeDisplay(cellState: CellState){
        // Assign the cell state as a property of this class
        self.cellState = cellState
        self.drawAppointment = false
        self.drawTask = false
        self.drawJournal = false
        self.appointmentCounter = 0
        self.taskCounter = 0
        self.journalCounter = 0
        
        // Set the label for the date of the cell
        dayLabel.text = cellState.text
        
        // Set up the colors for the date of the cell
        configureTextColor(cellState)
        
        // Set up the dots for the cell
        setUpCellDots(cellState)
        
        // Call the draw method
        self.setNeedsDisplay()
    }
    
    func setUpCellDots(cellState: CellState){
        // Get all the scheduled appointments from the database.
        let appointmentList = DatabaseFunctions.sharedInstance.getAllAppointments()
        let taskList = DatabaseFunctions.sharedInstance.getAllTasks()
        let journalList = DatabaseFunctions.sharedInstance.getAllJournals()
        formatter.dateFormat = "MM/dd/yyyy"
        let cellDate = formatter.stringFromDate(cellState.date)
        
//        print("Cell Date: \(cellDate)")
        
        for app in appointmentList{
            let appointmentDate = formatter.stringFromDate(app.startingTime)
            
            if appointmentDate == (cellDate){
//                print("AppointmentDate: \(appointmentDate)")
                appointmentDictionary.updateValue(app.title, forKey: appointmentDate)
//                for (key, value) in appointmentDictionary{
//                    print("Key: \(key) Value: \(value)")
//                }
                self.appointmentCounter += 1
                self.drawAppointment = true
            }
        }
        
        for task in taskList{
            let taskDate = formatter.stringFromDate(task.dateCreated)
            
            if taskDate == (cellDate){
//                print("Task Date: \(taskDate)")
                taskDictionary.updateValue(task.taskTitle, forKey: taskDate)
//                for (key, value) in appointmentDictionary{
//                    print("Key: \(key) Value: \(value)")
//                }
                self.taskCounter += 1
                self.drawTask = true
            }
        }
        
        for journal in journalList{
            let journalDate = formatter.stringFromDate(journal.journalDate)
            
            if journalDate == (cellDate){
//                print("Journal Date: \(journalDate)")
                journalDictionary.updateValue(journal.journalEntry, forKey: journalDate)
//                for (key, value) in journalDictionary{
//                    print("Key: \(key) Value: \(value)")
//                }
                self.journalCounter += 1
                self.drawJournal = true
            }
        }
    }
    
    func configureTextColor(cellState: CellState){
        
        if cellState.dateBelongsTo == .ThisMonth{
            // Change text and circle color.
            dayLabel.textColor = UIColor.whiteColor()
            
            // Allow the cell to be clicked
            self.userInteractionEnabled = true
            
            // Dont hide the cell
            self.hidden = false
        }
        else{
            // Change text and circle color.
            dayLabel.textColor = UIColor.lightGrayColor()
            
            // Prevent the cell from being clicked
            self.userInteractionEnabled = false
            
            // Hide the cell
            self.hidden = true
        }
    }
    
    // Return different colors for the dot behind the day label based on column
    func isWeekdayOrWeekend() -> UIColor{
        if self.cellState.column() == 0 || self.cellState.column() == 6{
            return weekendDotColor

        }
        else{
            return weekdayDotColor

        }
    }
    
    func updateCircleColor(cellState: CellState){
        self.cellState = cellState
        setNeedsDisplay()
    }
    
    // Draw the view
    override func drawRect(rect: CGRect) {
        // Draw a circle around the day of the calendar.
        let path = UIBezierPath(ovalInRect: CGRect(x: 7, y: 35 , width: 100, height: 100))

        fillColorForCircle = isWeekdayOrWeekend()
        
        // If cell has been selected
        if cellState.isSelected == true{
            fillColorForCircle = selectedDotColor
            self.layer.backgroundColor = UIColor.whiteColor().CGColor
        }
        else{
            fillColorForCircle = isWeekdayOrWeekend()
        }
        fillColorForCircle.setFill()
        path.fill()
        
        drawDotLogic()
    }
    
    // MARK - Draw Calendar Cell Dots
    
    func drawDotLogic(){
        // Draw the dots for the cells and if the counter on the cell is zero hide the label
        if self.appointmentCounter > 0 && self.drawAppointment == true{
            drawAppointmentDot()
        }
        else{
            appointmentCounterLabel.hidden = true
        }
        
        if self.taskCounter > 0 && self.drawTask == true{
            drawTaskDot()
        }
        else{
            taskCounterLabel.hidden = true
        }
        
        if self.journalCounter > 0 && self.drawJournal == true{
            drawJournalDot()
        }
        else{
            journalCounterLabel.hidden = true
        }
    }
    
    func drawAppointmentDot(){
        let appointmentCircle = UIBezierPath(ovalInRect: CGRect(x: 30.0, y: 20.0, width: dotWidth, height: dotHeight))
        appointmentColor.setFill()
        appointmentCircle.fill()
        setNeedsDisplay()
    }
    
    func drawTaskDot(){
        let taskCircle = UIBezierPath(ovalInRect: CGRect(x: 50.0, y: 20.0, width: dotWidth, height: dotHeight))
        taskColor.setFill()
        taskCircle.fill()
    }
    
    func drawJournalDot(){
        let journalCircle = UIBezierPath(ovalInRect: CGRect(x: 70.0, y: 20.0, width: dotWidth, height: dotHeight))
        journalColor.setFill()
        journalCircle.fill()
    }
    
    // MARK - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}