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
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var shortDaysLabel: UILabel!
    
    let userCalendar = NSCalendar.currentCalendar()
    let formatter = NSDateFormatter()
    let components = NSDateComponents()
    var startDate:NSDate = NSDate()
    var endDate:NSDate = NSDate()
    var weekdayLabel:String = String()
    var thisMonth: String = String()
    let thisDay: String = String()
    let thisYear:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.calendarView.delegate = self
        self.calendarView.dataSource = self
        self.calendarView.registerCellViewXib(fileName: "CellView")
        self.calendarView.registerHeaderViewXibs(fileNames: ["HeaderView"])
        self.calendarView.cellSnapsToEdge = true
        self.calendarView.scrollEnabled = true
        self.calendarView.direction = .Horizontal
        
        // This eliminates seperation between cells.
        self.calendarView.cellInset = CGPoint(x: 3, y: 3)
        
        // The size of the cells in the calendar view
        self.calendarView.itemSize = 150
        
        components.month = 3
        formatter.dateFormat = "yyyy MM dd"
        startDate = formatter.dateFromString("2016 07 01")!
        endDate = userCalendar.dateByAddingComponents(components, toDate: startDate, options: [])!
        
        // Set up background gradient
        let background = CAGradientLayer().makeGradientBackground()
        background.frame = self.view.bounds
        self.calendarView.layer.insertSublayer(background, atIndex: 0)
        
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
        
        return(startDate: startDate, endDate: endDate, numberOfRows: numberOfRows, calendar: userCalendar)
    }
    
    // Is about to display cell calls set up before display from cell
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplayCell cell: JTAppleDayCellView, date: NSDate, cellState: CellState) {
        
        (cell as! CalendarCell).setUpCellBeforeDisplay(cellState, date:date)
    }
    
    // Function for when the cell has been selected
    func calendar(calendar: JTAppleCalendarView, didSelectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        let calendarCell = (cell as! CalendarCell)
        calendarCell.isSelected = true
        calendarCell.updateCircleColor()
//        calendarCell.layer.backgroundColor = UIColor.whiteColor().CGColor
    }
    
    // Funcrion for when the cell has been deselected
    func calendar(calendar: JTAppleCalendarView, didDeselectDate date: NSDate, cell: JTAppleDayCellView?, cellState: CellState) {
        
        let calendarCell = (cell as! CalendarCell)
        calendarCell.isSelected = false
        calendarCell.updateCircleColor()
    }
    
    // MARK - Header Methods
    func setUpHeaderView() -> String{
        let month = userCalendar.component([.Month], fromDate: startDate)
        let monthName = formatter.monthSymbols[(month - 1) % 12]
        let year = userCalendar.component([.Year], fromDate: startDate)
        let dateString = monthName + " " + String(year)
        return dateString
    }
    
    // This method gets the months between the start and end date so that we can put them in
    // The header view
    func getMonths() -> [String]{
        let startMonth = userCalendar.components([.Month], fromDate: startDate)
        let endMonth = userCalendar.components([.Month], fromDate: endDate)
        var s: Int = startMonth.month
        let e: Int = endMonth.month
        var monthArray:[String] = []
        
        while s <= e{
            let month: NSString = formatter.monthSymbols[s - 1 % 12]
//            print("Month: \(month)")
            monthArray.append(month as String)
            s = s + 1
        }
//        print("Month Array: \(monthArray)")
        return monthArray
    }
    
    func calendar(calendar: JTAppleCalendarView, sectionHeaderSizeForDate date: (startDate: NSDate, endDate: NSDate)) -> CGSize {
        return CGSize(width: 600.0, height: 150.0)
    }
    
    func calendar(calendar: JTAppleCalendarView, isAboutToDisplaySectionHeader header: JTAppleHeaderView, date: (startDate: NSDate, endDate: NSDate), identifier: String) {
        
        let header = (header as? CalendarHeaderView)
        header?.topLabel.text = setUpHeaderView()
        var weekdayString = String()
        
        for index in 1...7 {
            let day : NSString = formatter.weekdaySymbols[index - 1 % 7] as NSString
//            print("Day: \(day)")

            let spaces = String(count: 30, repeatedValue: (" " as Character))
            weekdayString += day.substringToIndex(3).uppercaseString + spaces        }
        
        header?.bottomLabel.text = weekdayString
        header?.bottomLabel.font = UIFont(name: "Helvetica", size: 14.0)

    }
    
}