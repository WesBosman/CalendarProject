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
    var selectedDate: NSDate = NSDate()
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
            self.calendarView.selectDates([NSDate()], triggerSelectionDelegate: true)
        }
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(named: "Calendar"), tag: 5)
    }
    
    override func viewDidAppear(animated: Bool) {
        // If the user does not have to scroll to the next segment themselves then pressing the more button will never fail.
        calendarView.reloadData(){
            self.calendarView.selectDates([NSDate()], triggerSelectionDelegate: true)
        }
    }
    
    @IBAction func moreButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("calendarPopover", sender: self)
    }
    
    @IBAction func rightCalendarArrowPressed(sender: AnyObject) {
        calendarView.scrollToNextSegment()
        calendarView.reloadData(){
            self.calendarView.selectDates([NSDate()], triggerSelectionDelegate: true)
        }
    }
    
    @IBAction func leftCalendarArrowPressed(sender: AnyObject) {
        calendarView.scrollToPreviousSegment()
        calendarView.reloadData(){
            self.calendarView.selectDates([NSDate()], triggerSelectionDelegate: true)
        }
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
            print("Calendar Cell has not initally been selected and is nil...")
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
            selectedCell = calendarCell
            calendarCell.setNeedsDisplay()
        }
        
    }
    
    // Function for when the cell has been selected
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        // Send the selected date to the popover so we know which appointments tasks and journals to retrieve from the database
        if let calendarCell = cell as? CalendarCell{
            selectedDate = cellState.date
            selectedCell = calendarCell
            calendarCell.updateCell(cellState)
        }
    }
    
    // Function for when the cell has been deselected
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        // Update the cell state to deselect it
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
            
                vc.preferredContentSize = CGSize(width: 375.0, height: 375.0)
                let controller = vc.popoverPresentationController
                vc.selectedDate = selectedDate

                if controller != nil{
                    controller?.delegate = self

                }
            }
        }
    }

}