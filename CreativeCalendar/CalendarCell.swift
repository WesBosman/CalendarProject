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
    @IBInspectable var weekendDayColor = UIColor.lightGrayColor()
    @IBInspectable var normalDayColor = UIColor.whiteColor()
    @IBInspectable var fillColorForCircle: UIColor = UIColor.blackColor()
    @IBInspectable var isSelected = false
    @IBInspectable var appointmentColor:UIColor = UIColor.redColor()
    @IBInspectable var taskColor:UIColor = UIColor.greenColor()
    @IBInspectable var journalColor:UIColor = UIColor.yellowColor()
    @IBInspectable var dotHeight: CGFloat = 15.0
    @IBInspectable var dotWidth: CGFloat = 15.0
    
    var drawAppointment:Bool = false
    var drawTask:Bool = false
    var drawJournal:Bool = false
    
    func setUpCellBeforeDisplay(cellState: CellState, date: NSDate){
        dayLabel.text = cellState.text
        configureTextColor(cellState)
        
        // Get all the scheduled appointments from the database.
        let appointmentList = DatabaseFunctions.sharedInstance.getAllAppointments()
        let taskList = DatabaseFunctions.sharedInstance.getAllTasks()
        let journalList = DatabaseFunctions.sharedInstance.getAllJournals()
        let formatter = NSDateFormatter()
        
        formatter.dateFormat = "MM/dd/yyyy"
        let cellDate = formatter.stringFromDate(date)
//        print("Cell Date: \(cellDate)")
        
        for app in appointmentList{
//            print("App.startingTime: \(app.startingTime)")
            let appointmentDate = formatter.stringFromDate(app.startingTime)
//            print("Appointment Date: \(appointmentDate)")
            
            if appointmentDate == (cellDate){
//                print("\nCell Date == Appointment Date\n")
                drawAppointment = true
            }
            
        }
        
        // NEED TO CHANGE THE WAY TASK AND JOURNAL DATES ARE STORED IN DATABASE
        for task in taskList{
            let taskDate = formatter.stringFromDate(task.dateCreated)
//            print("Task String From Date: \(taskDate)")
            
            if taskDate == (cellDate){
//                print("\nCell Date == Task Date\n")
                drawTask = true
            }
        }
        
        for journal in journalList{
            let journalDate = formatter.stringFromDate(journal.journalDate)
//            print("Journal String From Date: \(journalDate)")
            
            if journalDate == (cellDate){
//                print("\nCell Date == Journal Date\n")
                drawJournal = true
            }
        }
        
    }
    
    func configureTextColor(cellState:CellState){
        if cellState.dateBelongsTo == .ThisMonth{
            
            // Change text and circle color.
            dayLabel.textColor = normalDayColor
            
            // Allow the cell to be clicked
            self.userInteractionEnabled = true
            
            // Dont hide the cell
            self.hidden = false
        }
        else{
            // Change text and circle color.
            dayLabel.textColor = weekendDayColor
            
            // Prevent the cell from being clicked
            self.userInteractionEnabled = false
            
            // Hide the cell
            self.hidden = true
        }
    }
    
    func configureCircleColor(){
        if self.isSelected == true{
            // If user clicks the date cell color it orange
            fillColorForCircle = UIColor.orangeColor()
        }
        else{
            // Otherwise color it purple
            fillColorForCircle = UIColor.purpleColor()
        }
        setNeedsDisplay()
    }
    
    // Draw the view
    override func drawRect(rect: CGRect) {
        // Draw a circle around the day of the calendar.
        let path = UIBezierPath(ovalInRect: CGRect(x: 22.5 , y: 50 , width: 100, height: 100))
        fillColorForCircle.setFill()
        path.fill()
        
        if drawAppointment == true{
            drawAppointmentDot()
        }

        if drawTask == true{
            drawTaskDot()
        }
        
        if drawJournal == true{
            drawJournalDot()
        }
        
    }
    
    // MARK - Draw Calendar Cell Dots
    
    func drawAppointmentDot(){
        let appointmentCircle = UIBezierPath(ovalInRect: CGRect(x: 35.0, y: 35.0, width: dotWidth, height: dotHeight))
        appointmentColor.setFill()
        appointmentCircle.fill()
        setNeedsDisplay()
    }
    
    func drawTaskDot(){
        let taskCircle = UIBezierPath(ovalInRect: CGRect(x: 65.0, y: 30.0, width: dotWidth, height: dotHeight))
        taskColor.setFill()
        taskCircle.fill()
    }
    
    func drawJournalDot(){
        let journalCircle = UIBezierPath(ovalInRect: CGRect(x: 95.0, y: 35.0, width: dotWidth, height: dotHeight))
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