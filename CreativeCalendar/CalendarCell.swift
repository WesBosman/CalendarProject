//
//  CalendarCollectionViewCell.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/29/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.

import UIKit
import JTAppleCalendar
import ChameleonFramework

@IBDesignable
class CalendarCell: JTAppleDayCellView{

    @IBOutlet weak var dayLabel: UILabel!
    @IBInspectable var appointmentColor:UIColor = UIColor().appointmentColor
    @IBInspectable var taskColor:UIColor = UIColor().taskColor
    @IBInspectable var journalColor:UIColor = UIColor().journalColor
    @IBInspectable var dotHeight: CGFloat = 15.0
    @IBInspectable var dotWidth: CGFloat = 15.0
    @IBInspectable var weekendDotColor:UIColor = UIColor(red: 132/255.0, green: 143/255.0, blue: 235/255.0, alpha: 1.0)
    @IBInspectable var weekdayDotColor:UIColor = UIColor(red: 32/255.0, green: 143/255.0, blue: 250/255.0, alpha: 1.0)
    @IBInspectable var selectedDotColor:UIColor = UIColor.orange
    @IBInspectable var backGroundViewColor = UIColor.orange
    @IBInspectable var backgroundHeight = 10.0
    @IBInspectable var backgroundWidth  = 10.0
//    @IBOutlet weak var backgroundView: UIView!
    fileprivate var fillColorForCircle: UIColor = UIColor.clear
    fileprivate var formatter = DateFormatter().dateWithoutTime
    var cellState:CellState!
    var appointmentCounter = 0
    var taskCounter = 0
    var journalCounter = 0
    var dayDotWidth: CGFloat  = 40
    var dayDotHeight: CGFloat = 40
    fileprivate var drawAppointment:Bool = false
    fileprivate var drawTask:Bool = false
    fileprivate var drawJournal:Bool = false
    @IBOutlet weak var appointmentCounterLabel: UILabel!
    @IBOutlet weak var taskCounterLabel: UILabel!
    @IBOutlet weak var journalCounterLabel: UILabel!

    
    func setUpCellBeforeDisplay(_ cellState: CellState){
        // Assign the cell state as a property of this class
        self.cellState = cellState
        self.appointmentCounter = 0
        self.taskCounter = 0
        self.journalCounter = 0
        self.drawAppointment = false
        self.drawTask = false
        self.drawJournal = false
        
        appointmentCounterLabel.font = UIFont.boldSystemFont(ofSize: 16)
        taskCounterLabel.font        = UIFont.boldSystemFont(ofSize: 16)
        journalCounterLabel.font     = UIFont.boldSystemFont(ofSize: 16)
        
        appointmentCounterLabel.textColor = UIColor.white
        taskCounterLabel.textColor        = UIColor.white
        journalCounterLabel.textColor     = UIColor.white
        
        // Set the label for the date of the cell
        dayLabel.text = cellState.text
        
        // Set up the colors for the date of the cell
        configureTextColor(cellState)
        
        // Set up the dots for the cell
        setUpCellDots(cellState)
        
        // Call the draw method
        self.setNeedsDisplay()
    }
    
    func updateCell(_ cellState:CellState){
        self.cellState = cellState
        setNeedsDisplay()
    }
    
    func setUpCellDots(_ cellState: CellState){
        // Get all the scheduled appointments from the database.
        let cellDate = formatter.string(from: cellState.date)
        
        // Use dictionaries for fast loading of the calendar
        let appointmentDict = Appointments.appointmentDictionary
        let taskDict        = Tasks.taskDictionary
        let journalDict     = JournalStructures.journalDictionary
        
        if let appointmentList = appointmentDict[cellDate]{
            if appointmentList.count != 0{
                self.appointmentCounter = appointmentList.count
                self.drawAppointment = true
            }
        }
        
        if let taskList = taskDict[cellDate]{
            if taskList.count != 0{
                self.taskCounter = taskList.count
                self.drawTask = true
            }
        }
        
        if let journalList = journalDict[cellDate]{
            if journalList.count != 0{
                self.journalCounter = journalList.count
                self.drawJournal = true
            }
        }
    }
    
    func configureTextColor(_ cellState: CellState){
        
        if cellState.dateBelongsTo == .thisMonth{
            // Change text and circle color.
            dayLabel.textColor = UIColor.white
            
            // Allow the cell to be clicked
            self.isUserInteractionEnabled = true
            
            // Dont hide the cell
            self.isHidden = false
        }
        else{
            // Prevent the cell from being clicked
            self.isUserInteractionEnabled = false
            
            // Hide the cell
            self.isHidden = true
        }
    }
    
    // Return different colors for the dot behind the day label based on column
    func isWeekdayOrWeekend() -> UIColor{
        if self.cellState.column() == 0 || self.cellState.column() == 6{
            self.dayLabel.textColor = UIColor.white
            return weekendDotColor
        }
        else{
            self.dayLabel.textColor = UIColor.black
            return weekdayDotColor
        }
    }
    
    // MARK - Initialization methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
    
    
    // Draw the view
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        // Draw a circle around the day of the calendar.        
        let path = UIBezierPath(ovalIn: CGRect(x: dayLabel.center.x - (dayDotWidth / 2), y: dayLabel.center.y - (dayDotHeight / 2), width: dayDotWidth, height: dayDotHeight))
        
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
        let appointmentCircle = UIBezierPath(ovalIn: CGRect(x: appointmentCounterLabel.center.x - (dotWidth / 2),
            y: appointmentCounterLabel.center.y - (dotHeight / 2),
            width: dotWidth, height: dotHeight))
        appointmentColor.setFill()
        appointmentCircle.fill()
    }
    
    func drawTaskDot(){
        let taskCircle = UIBezierPath(ovalIn: CGRect(x: taskCounterLabel.center.x - (dotWidth / 2),
            y: taskCounterLabel.center.y - (dotHeight / 2),
            width: dotWidth, height: dotHeight))
        taskColor.setFill()
        taskCircle.fill()
    }
    
    func drawJournalDot(){
        let journalCircle = UIBezierPath(ovalIn: CGRect(x: journalCounterLabel.center.x - (dotWidth / 2),
            y: journalCounterLabel.center.y - (dotHeight / 2),
            width: dotWidth, height: dotHeight))
        journalColor.setFill()
        journalCircle.fill()
    }
}
