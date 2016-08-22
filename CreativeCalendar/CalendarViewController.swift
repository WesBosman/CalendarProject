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
    let formatter = NSDateFormatter().calendarFormat
    let components = NSDateComponents()
    var weekdayLabel:String = String()
    var numberOfRows = 6
    var selectedCell: CalendarCell = CalendarCell()
    var appointment:String = String()
    var task:String = String()
    var journal:String = String()
    @IBOutlet weak var calendarInfo: UIButton!
    @IBOutlet weak var leftCalendarArrow: UIButton!
    @IBOutlet weak var rightCalendarArrow: UIButton!
    var count:Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.registerCellViewXib(fileName: "CellView")
        calendarView.registerHeaderViewXibs(fileNames: ["HeaderView"])
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.backgroundColor = UIColor.clearColor()
        
        // Make the gradient background
        let background = CAGradientLayer().makeGradientBackground()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        // Set up the info button on the calendar
        calendarInfo.layer.cornerRadius = 10
        calendarInfo.layer.borderWidth = 2
        calendarInfo.layer.borderColor = UIColor.whiteColor().CGColor
        calendarInfo.setTitleColor(UIColor().defaultButtonColor, forState: .Normal)
        calendarInfo.backgroundColor = UIColor.whiteColor()
        
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
    
    override func viewDidAppear(animated: Bool) {
        // This almost works the way I would like it to but I am experiencing problems with the popover view when trying to set the current date as a selected one.
        calendarView.reloadData(){
            self.calendarView.selectDates([NSDate()])
        }
    }
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("calendarPopover", sender: self)
    }
    
    @IBAction func rightCalendarArrowPressed(sender: AnyObject) {
        calendarView.scrollToNextSegment()
    }
    
    @IBAction func leftCalendarArrowPressed(sender: AnyObject) {
        calendarView.scrollToPreviousSegment()
    }
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        if selectedCell.cellState != nil{
            if selectedCell.cellState.isSelected == true{
                let popoverVC = PopoverViewController()
                popoverPresentationController.permittedArrowDirections = [.Up, .Down]
                popoverPresentationController.sourceRect = CGRect(x: 0.0, y: 0.0, width: selectedCell.frame.size.width, height: selectedCell.frame.size.height)
                popoverPresentationController.sourceView = selectedCell
                popoverPresentationController.backgroundColor = UIColor.orangeColor()
                presentViewController(popoverVC, animated: true, completion: nil)
            }
        }
        else{
            selectedCell.cellState = calendarView.cellStatusForDate(NSDate())
            print("Selected Cell is selected : \(selectedCell.cellState.isSelected)")
            print("Calendar Cell has not initally been selected...")
        }
    }
    
    
    // Calendar must know the number of rows, start date, end date and calendar
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        // Use the NSDate Extensions for the start and end date
        return(startDate: NSDate().calendarStartDate, endDate: NSDate().calendarEndDate, numberOfRows: numberOfRows, calendar: userCalendar)
    }
    
    // Is about to display cell calls set up before display from cell
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        
        if let calendarCell = cell as? CalendarCell{
            calendarCell.setUpCellBeforeDisplay(cellState)
            if calendarCell.appointmentCounter > 0{
                calendarCell.appointmentCounterLabel.hidden = false
                calendarCell.appointmentCounterLabel.text = String(calendarCell.appointmentCounter)
            }
            else{
                calendarCell.appointmentCounterLabel.hidden = true
            }
            
            if calendarCell.taskCounter > 0{
                calendarCell.taskCounterLabel.hidden = false
                calendarCell.taskCounterLabel.text = String(calendarCell.taskCounter)
            }
            else{
                calendarCell.taskCounterLabel.hidden = true
            }
            
            if calendarCell.journalCounter > 0{
                calendarCell.journalCounterLabel.hidden = false
                calendarCell.journalCounterLabel.text = String(calendarCell.journalCounter)
            }
            else{
                calendarCell.journalCounterLabel.hidden = true
            }
            calendarCell.setNeedsDisplay()
        }
        
    }
    
    // Function for when the cell has been selected
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        if let calendarCell = cell as? CalendarCell{
            let stringDate = formatter.stringFromDate(cellState.date)
            
            let taskDate = NSDateFormatter().dateWithoutTime.stringFromDate(cellState.date)
            
            let appointmentList = DatabaseFunctions.sharedInstance.getAppointmentByDate(stringDate, formatter: formatter)
            let taskList = DatabaseFunctions.sharedInstance.getTaskByDate(taskDate, formatter: NSDateFormatter().dateWithoutTime)
            let journalList = DatabaseFunctions.sharedInstance.getJournalByDate(stringDate, formatter: formatter)
            var appointmentString = String()
            var taskString = String()
            var journalString = String()
            let bullet = "• "

            
            for a in appointmentList{
                appointmentString += bullet + a.title + "\n   " + a.appLocation + "\n "
            }
            appointment = appointmentString
        
            for t in taskList{
                taskString += bullet + t.taskTitle + "\n   " + t.taskInfo + "\n "
            }
            task = taskString
        
            for j in journalList{
                journalString += bullet + j.journalEntry + "\n "
            }
            journal = journalString
            
            
            selectedCell = calendarCell
            calendarCell.updateCell(cellState)
        }
    }
    
    // Function for when the cell has been deselected
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        if let calendarCell = cell as? CalendarCell{
            calendarCell.updateCell(cellState)
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
    func calendar(calendar: JTAppleCalendarView, sectionHeaderSizeForDate dateRange: (start: NSDate, end: NSDate), belongingTo month: Int) -> CGSize {
        return CGSize(width: calendarView.frame.size.width, height: 100)

    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplaySectionHeader header: JTAppleHeaderView, dateRange: (start: NSDate, end: NSDate), identifier: String) {
        if let headerView = header as? CalendarHeaderView{
            headerView.topLabel.text = setUpHeaderView(dateRange.start)
            
            var weekdayString = String()
            
            for index in 1...7 {
                let day : NSString = formatter.weekdaySymbols[index - 1 % 7] as NSString
                //              print("Day: \(day)")
                let spaces = String(count: 14, repeatedValue: (" " as Character))
                weekdayString += day.substringToIndex(3).uppercaseString + spaces
            }
            headerView.bottomLabel.text = weekdayString
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "calendarPopover"{

            if let vc = segue.destinationViewController as? PopoverViewController{
            
                let controller = vc.popoverPresentationController
                
                vc.appointment = appointment
                vc.task = task
                vc.journal = journal
                
                if controller != nil{
                    controller?.delegate = self
                }
            }
        }
    }

}