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
    var drawAppointment:Bool = false
    var drawTask:Bool = false
    var drawJournal:Bool = false
    var isWeekend = false
    var isWeekday = false
    var isSelected = false
    
    func setUpCellBeforeDisplay(cellState: CellState){
        dayLabel.text = cellState.text
        configureTextColor(cellState)
        
//        // Get all the scheduled appointments from the database.
//        let appointmentList = DatabaseFunctions.sharedInstance.getAllAppointments()
//        let taskList = DatabaseFunctions.sharedInstance.getAllTasks()
//        let journalList = DatabaseFunctions.sharedInstance.getAllJournals()
//        
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "MM/dd/yyyy"
//        let cellDate = formatter.stringFromDate(cellState.date)
//        
//        print("Cell Date: \(cellDate)")
//        
//        for app in appointmentList{
//            let appointmentDate = formatter.stringFromDate(app.startingTime)
//            
//            if appointmentDate == (cellDate){
//                print("AppointmentDate: \(appointmentDate)")
//                drawAppointment = true
//            }
//            
//        }
//        
//        for task in taskList{
//            let taskDate = formatter.stringFromDate(task.dateCreated)
//            
//            if taskDate == (cellDate){
//                print("Task Date: \(taskDate)")
//                drawTask = true
//            }
//        }
//        
//        for journal in journalList{
//            let journalDate = formatter.stringFromDate(journal.journalDate)
//            
//            if journalDate == (cellDate){
//                print("Journal Date: \(journalDate)")
//                drawJournal = true
//            }
//        }        
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
        
//        if cellState.column() == 0 || cellState.column() == 6{
//            isWeekend = true
//        }
//        else{
//            isWeekday = true
//        }
        
        
    }
    
    func updateCircleColor(){
        setNeedsDisplay()
    }
    
    // Draw the view
    override func drawRect(rect: CGRect) {
        // Draw a circle around the day of the calendar.
        let path = UIBezierPath(ovalInRect: CGRect(x: 22.5 , y: 50 , width: 100, height: 100))
        
        // If the cell has not been selected yet
        if self.isWeekend == true{
            fillColorForCircle = weekendDotColor
        }
        else{
            fillColorForCircle = weekdayDotColor
        }
        
        // If cell has been selected
        if self.isSelected == true{
            fillColorForCircle = selectedDotColor
        }
        else{
            if self.isWeekday{
                fillColorForCircle = weekdayDotColor
            }
            else{
                fillColorForCircle = weekendDotColor
            }
        }
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