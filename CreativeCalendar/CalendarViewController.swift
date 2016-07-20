//
//  CalendarController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/29/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.

import UIKit
import JTAppleCalendar

class CalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource{
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let userCalendar = NSCalendar.currentCalendar()
    let formatter = NSDateFormatter()
    let components = NSDateComponents()
    var calendarStartDate:NSDate = NSDate()
    var calendarEndDate:NSDate = NSDate()
    var weekdayLabel:String = String()
    
    @IBOutlet weak var appointmentFooterLabel: UILabel!
    @IBOutlet weak var taskFooterLabel: UILabel!
    @IBOutlet weak var journalFooterLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.registerCellViewXib(fileName: "CellView")
        calendarView.registerHeaderViewXibs(fileNames: ["HeaderView"])
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.cellSnapsToEdge = true
        calendarView.direction = .Horizontal
        
        // This eliminates seperation between cells.
        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
        // The size of the cells in the calendar view
//        calendarView.itemSize = 80
        // Smaller cells seem to be the right color?
        
        // Set up background gradient
        let background = CAGradientLayer().makeGradientBackground()
        background.frame = self.view.bounds
        calendarView.layer.insertSublayer(background, atIndex: 0)
        
        // Select the current date
        calendarView.reloadData() {
            self.calendarView.selectDates([NSDate()])
        }
        
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(named: "Calendar"), tag: 5)
    }

    
    // Calendar must know the number of rows, start date, end date and calendar
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        
        let numberOfRows = 6
        components.month = 3
        formatter.dateFormat = "MM/dd/yyyy"
        calendarStartDate = formatter.dateFromString("07/01/2016")!
        calendarEndDate = userCalendar.dateByAddingComponents(components, toDate: calendarStartDate, options: [])!
//        print("Calendar Start Date \(calendarStartDate)")
//        print("Calendar End Date \(calendarEndDate)")
        
        return(startDate: calendarStartDate, endDate: calendarEndDate, numberOfRows: numberOfRows, calendar: userCalendar)
    }
    
    // Is about to display cell calls set up before display from cell
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        
        let calendarCell = cell as! CalendarCell
        calendarCell.setUpCellBeforeDisplay(cellState)
        
    }
    
    // Function for when the cell has been selected
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        let calendarCell = (cell as! CalendarCell)
        formatter.dateFormat = "MM/dd/yyyy"
        let stringDate = formatter.stringFromDate(cellState.date)
        print("String Date: \(stringDate)")
        let appointmentLbl = calendarCell.appointmentDictionary[stringDate]
        let taskLbl = calendarCell.taskDictionary[stringDate]
        let journalLbl = calendarCell.journalDictionary[stringDate]

        print("Appointment footer: \(appointmentLbl)")
        appointmentFooterLabel.text = appointmentLbl
        taskFooterLabel.text = taskLbl
        journalFooterLabel.text = journalLbl
        
        calendarCell.isSelected = true
        calendarCell.updateCircleColor()
    }
    
    // Function for when the cell has been deselected
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        let calendarCell = (cell as! CalendarCell)
        calendarCell.isSelected = false
        calendarCell.updateCircleColor()
    }
    
    // MARK - Header Methods
    
    // Sets up the month and year for the header view.
    func setUpHeaderView(startingMonth: NSDate) -> String{
        let month = userCalendar.component([.Month], fromDate: startingMonth)
        let monthName = formatter.monthSymbols[(month - 1) % 12]
        let year = userCalendar.component([.Year], fromDate: startingMonth)
        let dateString = monthName + " " + String(year)
        return dateString
    }
    
    // Size of the header view
    func calendar(calendar: JTAppleCalendarView, sectionHeaderSizeForDate date: (startDate: NSDate, endDate: NSDate)) -> CGSize {
        return CGSize(width: 600.0, height: 175.0)
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplaySectionHeader header: JTAppleHeaderView, date: (startDate: NSDate, endDate: NSDate), identifier: String) {
        
        let header = (header as? CalendarHeaderView)
        header?.topLabel.text = setUpHeaderView(date.startDate)
        
        var weekdayString = String()
        
        for index in 1...7 {
            let day : NSString = formatter.weekdaySymbols[index - 1 % 7] as NSString
//            print("Day: \(day)")

            let spaces = String(count: 30, repeatedValue: (" " as Character))
            weekdayString += day.substringToIndex(3).uppercaseString + spaces
        }
        
        header?.bottomLabel.text = weekdayString
        header?.bottomLabel.font = UIFont(name: "Helvetica", size: 14.0)
    }
    
    func calendar(calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWithdate startDate: NSDate, endingWithDate endDate: NSDate) {
        print("Calendar boundaries: \(calendarView.currentCalendarDateSegment())")
    }
    
}