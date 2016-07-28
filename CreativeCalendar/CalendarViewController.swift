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
    @IBOutlet weak var calendarInfo: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendarView.registerCellViewXib(fileName: "CellView")
        calendarView.registerHeaderViewXibs(fileNames: ["HeaderView"])
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.cellSnapsToEdge = true
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
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("calendarPopover", sender: self)
    }
    
    func prepareForPopoverPresentation(popoverPresentationController: UIPopoverPresentationController) {
        if selectedCell.cellState.isSelected == true{
            let popoverVC = PopoverViewController()
//            popoverVC.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverPresentationController.permittedArrowDirections = [.Up, .Down]
            popoverPresentationController.sourceRect = CGRect(x: 0.0, y: 0.0, width: selectedCell.frame.size.width, height: selectedCell.frame.size.height)
            popoverPresentationController.sourceView = selectedCell
            popoverPresentationController.backgroundColor = UIColor.orangeColor()
            presentViewController(popoverVC, animated: true, completion: nil)
        }
    }
    
    
    // Calendar must know the number of rows, start date, end date and calendar
    func configureCalendar(calendar: JTAppleCalendarView) -> (startDate: NSDate, endDate: NSDate, numberOfRows: Int, calendar: NSCalendar) {
        
        components.month = 3
        formatter.dateFormat = "MM/dd/yyyy"
        calendarStartDate = formatter.dateFromString("07/01/2016")!
        calendarEndDate = userCalendar.dateByAddingComponents(components, toDate: calendarStartDate, options: [])!        
        return(startDate: calendarStartDate, endDate: calendarEndDate, numberOfRows: numberOfRows, calendar: userCalendar)
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
            formatter.dateFormat = "MM/dd/yyyy"
            let stringDate = formatter.stringFromDate(cellState.date)
//            print()
//            print("Cell Date: \(stringDate)")
//            print("Cell Column: \(cellState.column())")
//            print("Cell Row: \(cellState.row())")
//            print("Calendar Cell Appointment Counter: \(calendarCell.appointmentCounter)")
//            print("Calendar Cell Task Counter: \(calendarCell.taskCounter)")
//            print("Calendar Cell Journal Counter: \(calendarCell.journalCounter)")
//            calendarCell.backgroundColor = UIColor.whiteColor()
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
    func calendar(calendar: JTAppleCalendarView, sectionHeaderSizeForDate date: (startDate: NSDate, endDate: NSDate)) -> CGSize {
        return CGSize(width: calendarView.frame.size.width, height: 100)
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplaySectionHeader header: JTAppleHeaderView, date: (startDate: NSDate, endDate: NSDate), identifier: String) {
        
        if let headerView = header as? CalendarHeaderView{
            headerView.topLabel.text = setUpHeaderView(date.startDate)
        
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
//            print("Popover Segue")
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