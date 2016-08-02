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
    
    var formatter = NSDateFormatter().dateWithoutTime
    var cellState:CellState!
    
    var appointmentDictionary: Dictionary<String, [AppointmentItem]> = [:]
    var taskDictionary: Dictionary<String, [TaskItem]> = [:]
    var journalDictionary: Dictionary<String, [JournalItem]> = [:]
    var appointmentCounter = 0
    var taskCounter = 0
    var journalCounter = 0
    var drawAppointment:Bool = false
    var drawTask:Bool = false
    var drawJournal:Bool = false
    
    var appointmentC:UILabel = UILabel()
    var taskC:UILabel = UILabel()
    var journalC:UILabel = UILabel()
    
    @IBOutlet weak var appointmentCounterLabel: UILabel!
    @IBOutlet weak var taskCounterLabel: UILabel!
    @IBOutlet weak var journalCounterLabel: UILabel!
    
    func setUpCellBeforeDisplay(cellState: CellState){
        // Assign the cell state as a property of this class
        self.cellState = cellState
        self.appointmentCounter = 0
        self.taskCounter = 0
        self.journalCounter = 0
        self.drawAppointment = false
        self.drawTask = false
        self.drawJournal = false
        
        // Set the label for the date of the cell
        dayLabel.text = cellState.text
        
        // Set up the colors for the date of the cell
        configureTextColor(cellState)
        
        // Set up the dots for the cell
        setUpCellDots(cellState)
        
        // Call the draw method
        self.setNeedsDisplay()
    }
    
    func updateCell(cellState:CellState){
        self.cellState = cellState
        setNeedsDisplay()
    }
    
    func setUpCellDots(cellState: CellState){
        // Get all the scheduled appointments from the database.
        let cellDate = formatter.stringFromDate(cellState.date)
        let appointmentList = DatabaseFunctions.sharedInstance.getAppointmentByDate(cellDate)
        let taskList = DatabaseFunctions.sharedInstance.getTaskByDate(cellDate, formatter: formatter)
        let journalList = DatabaseFunctions.sharedInstance.getAllJournals()
        
        for a in appointmentList{
            let appointmentDate = formatter.stringFromDate(a.startingTime)
            var appointmentArray:[AppointmentItem] = []
            if cellDate == appointmentDate{
                appointmentArray.append(a)
                self.appointmentCounter += 1
                self.drawAppointment = true
            }
            appointmentDictionary.updateValue(appointmentArray, forKey: appointmentDate)
        }
        
        for t in taskList{
            let taskDate = formatter.stringFromDate(t.dateCreated)
            var taskArray:[TaskItem] = []
            if cellDate == taskDate{
                taskArray.append(t)
                self.taskCounter += 1
                self.drawTask = true
            }
            taskDictionary.updateValue(taskArray, forKey: taskDate)
        }
        
        for j in journalList{
            let journalDate = formatter.stringFromDate(j.journalDate)
//            print("Journal Date for cell \(journalDate)")
            var journalArray:[JournalItem] = []
            if cellDate == formatter.stringFromDate(j.journalDate){
                journalArray.append(j)
                self.journalCounter += 1
                self.drawJournal = true
            }
            journalDictionary.updateValue(journalArray, forKey: journalDate)
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
    
    // Draw the view
    override func drawRect(rect: CGRect) {
        // Draw a circle around the day of the calendar.
        let path = UIBezierPath(ovalInRect: CGRect(x: 0, y: self.center.y / 2 , width: self.frame.size.width, height: self.frame.size.height / 2))
        
        // If cell has been selected
        if cellState.isSelected == true{
            fillColorForCircle = selectedDotColor
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
        // Draw the dots for the cells
        if self.appointmentCounter > 0 && self.drawAppointment == true{
            drawAppointmentDot()
        }
        
        if self.taskCounter > 0 && self.drawTask == true{
            drawTaskDot()
        }
        
        if self.journalCounter > 0 && self.drawJournal == true{
            drawJournalDot()
        }
    }
    
    func drawAppointmentDot(){
        let appointmentCircle = UIBezierPath(ovalInRect: CGRect(x: self.frame.width / 4 - 10, y: 20.0, width: dotWidth, height: dotHeight))
        appointmentColor.setFill()
        appointmentCircle.fill()
    }
    
    func drawTaskDot(){
        let taskCircle = UIBezierPath(ovalInRect: CGRect(x: self.frame.width / 2 - 10, y: 20.0, width: dotWidth, height: dotHeight))
        taskColor.setFill()
        taskCircle.fill()
    }
    
    func drawJournalDot(){
        let journalCircle = UIBezierPath(ovalInRect: CGRect(x: self.frame.width/1.35 - 10, y: 20.0, width: dotWidth, height: dotHeight))
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