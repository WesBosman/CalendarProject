//
//  CalendarController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/29/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.

import UIKit
import JTAppleCalendar


class CalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource, UIPopoverPresentationControllerDelegate{
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    let userCalendar = NSCalendar.currentCalendar()
    let formatter = NSDateFormatter()
    let components = NSDateComponents()
    var calendarStartDate:NSDate = NSDate()
    var calendarEndDate:NSDate = NSDate()
    var weekdayLabel:String = String()
    var numberOfRows = 6
    var selectedCell:CalendarCell = CalendarCell()
    
    var appointment:String = String()
    var task:String = String()
    var journal:String = String()
    
    @IBOutlet weak var appointmentFooterLabel: UILabel!
    @IBOutlet weak var taskFooterLabel: UILabel!
    @IBOutlet weak var journalFooterLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var daysOfWeekLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.registerCellViewXib(fileName: "CellView")
        calendarView.registerHeaderViewXibs(fileNames: ["HeaderView"])
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.cellSnapsToEdge = true
        
        // This eliminates seperation between cells.
//        calendarView.cellInset = CGPoint(x: 0, y: 0)
        
        // The size of the cells in the calendar view
//        calendarView.itemSize = 100.0
        // Smaller cells seem to be the right color?
        calendarView.backgroundColor = UIColor.clearColor()
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
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
        
        self.performSegueWithIdentifier("calendarPopover", sender: self)
    }
    
    func popoverControllerDidDismissPopover(popoverController: UIPopoverController) {
        print("Popover did dismiss")
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        print("Should dismiss popover")
        return true
    }
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        if selectedCell.cellState.isSelected == true{
            let popoverVC = PopoverViewController()
            popoverVC.modalPresentationStyle = UIModalPresentationStyle.Popover
            let popover = popoverVC.popoverPresentationController
            let calendarRect = CGRect(x: selectedCell.frame.size.height, y: selectedCell.frame.size.width / 2, width: 200, height: 200)
            popover?.sourceRect = calendarRect
            
            popover!.backgroundColor = UIColor.greenColor()

        }

    }
    
    
    // Calendar must know the number of rows, start date, end date and calendar
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        
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
        
        if let calendarCell = cell as? CalendarCell{
            calendarCell.setUpCellBeforeDisplay(cellState)
            calendarCell.appointmentCounterLabel.text = String(calendarCell.appointmentCounter)
            calendarCell.taskCounterLabel.text = String(calendarCell.taskCounter)
            calendarCell.journalCounterLabel.text = String(calendarCell.journalCounter)
        }
        
    }
    
    // Function for when the cell has been selected
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        if let calendarCell = cell as? CalendarCell{
            formatter.dateFormat = "MM/dd/yyyy"
            let stringDate = formatter.stringFromDate(cellState.date)
            print()
            print("Cell Date: \(stringDate)")
            print("Cell Column: \(cellState.column())")
            print("Cell Row: \(cellState.row())")
            print("Calendar Cell Appointment Counter: \(calendarCell.appointmentCounter)")
            print("Calendar Cell Task Counter: \(calendarCell.taskCounter)")
            print("Calendar Cell Journal Counter: \(calendarCell.journalCounter)")

            
            
            let appointmentLbl = calendarCell.appointmentDictionary[stringDate]
            let taskLbl = calendarCell.taskDictionary[stringDate]
            let journalLbl = calendarCell.journalDictionary[stringDate]
                        
            if appointmentLbl != nil{
                appointment = appointmentLbl!
            }
            else{
                appointment = ""
            }
            if taskLbl != nil{
                task = taskLbl!
            }
            else{
                task = ""
            }
            if journalLbl != nil{
                journal = journalLbl!
            }
            else{
                journal = ""
            }
            
//            print("Appointment footer: \(appointmentLbl)")
            appointmentFooterLabel.text = appointmentLbl
            taskFooterLabel.text = taskLbl
            journalFooterLabel.text = journalLbl
            selectedCell = calendarCell
        
            calendarCell.updateCircleColor(cellState)
        }
    }
    
    // Function for when the cell has been deselected
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        if let calendarCell = cell as? CalendarCell{
            calendarCell.updateCircleColor(cellState)
        }
    }
    
    // MARK - Header Methods
    
    // Sets up the month and year for the header view.
    func setUpHeaderView(startingMonth: NSDate) -> String {
        let month = userCalendar.component([.Month], fromDate: startingMonth)
        let monthName = formatter.monthSymbols[(month - 1) % 12]
        let year = userCalendar.component([.Year], fromDate: startingMonth)
        let dateString = monthName + " " + String(year)
        return dateString
    }
    
    // Size of the header view
    func calendar(calendar: JTAppleCalendarView, sectionHeaderSizeForDate date: (startDate: NSDate, endDate: NSDate)) -> CGSize {
        return CGSize(width: 0, height: 0)
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplaySectionHeader header: JTAppleHeaderView, date: (startDate: NSDate, endDate: NSDate), identifier: String) {
        
        monthLabel.text = setUpHeaderView(date.startDate)
        
        var weekdayString = String()
        
        for index in 1...7 {
            let day : NSString = formatter.weekdaySymbols[index - 1 % 7] as NSString
//            print("Day: \(day)")

            let spaces = String(count: 19, repeatedValue: (" " as Character))
            weekdayString += day.substringToIndex(3).uppercaseString + spaces
        }
        daysOfWeekLabel.text = weekdayString
    }
        
    func calendar(calendar: JTAppleCalendarView, didScrollToDateSegmentStartingWithdate startDate: NSDate, endingWithDate endDate: NSDate) {
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "calendarPopover"{
            print("Popover Segue")
            let vc = segue.destinationViewController as UIViewController
//            let popOverView = segue.destinationViewController as! PopoverViewController
//            let source = segue.sourceViewController as! CalendarViewController
            
            let controller = vc.popoverPresentationController
            
//            popOverView.appointmentPopoverLabel.text = appointment
//            popOverView.taskPopoverLabel.text = task
//            popOverView.journalPopoverLabel.text = journal
            
            
            if controller != nil{
                controller?.delegate = self
                controller?.permittedArrowDirections = [.Up, .Down]
                controller?.sourceRect = CGRect(x: 0.0, y: 0.0, width: selectedCell.frame.size.width, height: selectedCell.frame.size.height)
                controller?.sourceView = selectedCell
            }
        }
    }

}