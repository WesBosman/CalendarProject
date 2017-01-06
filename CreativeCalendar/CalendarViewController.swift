//
//  CalendarController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/29/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.

import UIKit
import JTAppleCalendar


class CalendarViewController: UIViewController, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource, UIPopoverPresentationControllerDelegate, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    let userCalendar = Calendar.current
    let formatter = DateFormatter().calendarFormat
    let components = DateComponents()
    var weekdayLabel:String = String()
    var numberOfRows = 6
    var selectedCell: CalendarCell = CalendarCell()
    var selectedDate: Date = Date()
    @IBOutlet weak var leftCalendarArrow: UIButton!
    @IBOutlet weak var rightCalendarArrow: UIButton!
    var count:Int = 1
    let calendarSectionTitles: [String] = ["Appointments", "Tasks", "Journals"]
    let calendarAppointmentCellId: String = "CalendarAppointmentCell"
    let calendarTaskCellId: String = "CalendarTaskCell"
    let calendarJournalCellId: String = "CalendarJournalCell"
    var calendarAppointmentList: [AppointmentItem] = []
    var calendarTaskList: [TaskItem] = []
    var calendarJournalList: [JournalItem] = []
    var selectedIndexPath: IndexPath? = nil
    var toggleJournalHeight: Bool = false
    @IBOutlet weak var calendarTableView: UITableView!
    let calendarDateFormatter = DateFormatter().dateWithoutTime
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Calendar View View Did Load Method")
        calendarView.registerCellViewXib(file: "CellView")
        calendarView.registerHeaderView(xibFileNames: ["HeaderView"])
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.backgroundColor = UIColor.clear
        
        // Set up the table view for displaying the information from the calendar by day
        calendarTableView.delegate = self
        calendarTableView.dataSource = self
        
        // Make the gradient background
        let background = CAGradientLayer().makeGradientBackground()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        // Navigation bar
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blue
                
        // Select the current date
        calendarView.reloadData() {
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true)
        }
        
        // Register the cells for the tableView
        
        // Register appointment cells
        let appointmentNib = UINib(nibName: "AppointmentTableViewCell", bundle: nil)
        self.calendarTableView.register(appointmentNib, forCellReuseIdentifier: "AppointmentTableViewCell")
        
        // Register task cell
        let taskNib = UINib(nibName: "TaskTableViewCell", bundle: nil)
        self.calendarTableView.register(taskNib, forCellReuseIdentifier: "TaskTableViewCell")
        
        // Register journal cell
        let journalNib = UINib(nibName: "JournalTableViewCell", bundle: nil)
        self.calendarTableView.register(journalNib, forCellReuseIdentifier: "JournalTableViewCell")
        
        // Set up the calendar
        self.calendarTableView.layer.cornerRadius = 10
        self.calendarTableView.backgroundColor = UIColor.clear
        self.calendarTableView.allowsSelection = false
        // There will be no lines when there are no cells
        self.calendarTableView.tableFooterView = UIView(frame: CGRect())
        
    }
    
    // Failable Initializer for tab bar controller
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print("Calendar Init Coder Method")
        // Initialize Tab Bar Item
        tabBarItem = UITabBarItem(title: "Calendar", image: UIImage(named: "Calendar"), tag: 5)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // If the user does not have to scroll to the next segment themselves then pressing the more button will never fail.
        print("Calendar View Did Appear Animated Method")
        calendarView.reloadData(){
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true)
        }
        
        // Estimate the height of the cells in the table view
        calendarTableView.reloadData()
        self.calendarTableView.estimatedRowHeight = 100
        self.calendarTableView.setNeedsLayout()
        self.calendarTableView.layoutIfNeeded()
        
    }
    
    @IBAction func rightCalendarArrowPressed(_ sender: AnyObject) {
        print("Right Arrow Pressed Action")
        calendarView.scrollToNextSegment()
        calendarView.reloadData(){
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true)
        }
    }
    
    @IBAction func leftCalendarArrowPressed(_ sender: AnyObject) {
        print("Left Arrow Pressed Action")
        calendarView.scrollToPreviousSegment()
        calendarView.reloadData(){
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true)
        }
    }
    
    // Calendar must know the number of rows, start date, end date and calendar
    func configureCalendar(_ calendar: JTAppleCalendarView) -> (startDate: Date, endDate: Date, numberOfRows: Int, calendar: Calendar) {
        print("Old Configure Calendar Method")
        // Use the NSDate Extensions for the start and end date
        return(startDate: Date().calendarStartDate as Date, endDate: Date().calendarEndDate as Date, numberOfRows: numberOfRows, calendar: userCalendar)
    }
    
    // Configure the calendar
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        print("Congifure Calendar Method")
        let parameters = ConfigurationParameters(startDate: Date().calendarStartDate,
                                                 endDate: Date().calendarEndDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar: userCalendar,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    // Display the calendar cells
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {

        if let calendarCell = cell as? CalendarCell{
            calendarCell.setUpCellBeforeDisplay(cellState)
            if calendarCell.appointmentCounter > 0{
                calendarCell.appointmentCounterLabel.isHidden = false
                calendarCell.appointmentCounterLabel.text = String(calendarCell.appointmentCounter)
            }
            else{
                calendarCell.appointmentCounterLabel.isHidden = true
            }
            
            if calendarCell.taskCounter > 0{
                calendarCell.taskCounterLabel.isHidden = false
                calendarCell.taskCounterLabel.text = String(calendarCell.taskCounter)
            }
            else{
                calendarCell.taskCounterLabel.isHidden = true
            }
            
            if calendarCell.journalCounter > 0{
                calendarCell.journalCounterLabel.isHidden = false
                calendarCell.journalCounterLabel.text = String(calendarCell.journalCounter)
            }
            else{
                calendarCell.journalCounterLabel.isHidden = true
            }
            selectedCell = calendarCell
            calendarCell.setNeedsDisplay()
        }

    }
    
    // Function for when the cell has been selected
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        print("Did Select Date Method")
        let stringDate = DateFormatter().dateWithoutTime.string(from: cellState.date)
        print("String Date \(stringDate)")
        
        // Send the selected date to the popover so we know which appointments tasks and journals to retrieve from the database
        if let calendarCell = cell as? CalendarCell{
            selectedDate = cellState.date
            selectedCell = calendarCell
            calendarCell.updateCell(cellState)
            
            // Get the items at those dates
            setUpTableView()
        }
    }
    
    // Function for when the cell has been deselected
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        print("Did De-Select Date Method")
        // Update the cell state to deselect it
        if let calendarCell = cell as? CalendarCell{
            calendarCell.updateCell(cellState)
        }
    }
    
    // MARK - Calendar Header Methods
    
    // Sets up the month and year for the header view.
    func setUpHeaderView(_ startingMonth: Date) -> String {
        print("Set Up Header Method")
        let month = (userCalendar as NSCalendar).component([.month], from: startingMonth)
        let monthName = formatter.monthSymbols[(month - 1) % 12]
        let year = (userCalendar as NSCalendar).component([.year], from: startingMonth)
        let dateString = monthName + " " + String(year)
        return dateString
    }

    // Display the section header
    func calendar(_ calendar: JTAppleCalendarView, willDisplaySectionHeader header: JTAppleHeaderView, range: (start: Date, end: Date), identifier: String) {
        print("Will Display Section Header Method")
        if let headerView = header as? CalendarHeaderView{
            headerView.topLabel.text = setUpHeaderView(range.start)
            
            var weekdayString = String()
            
            for index in 1...7 {
                let day : NSString = formatter.weekdaySymbols[index - 1 % 7] as NSString
                //              print("Day: \(day)")
                let spaces = String(repeating: String((" " as Character)), count: 12)
                weekdayString += day.substring(to: 3).uppercased() + spaces
            }
            headerView.bottomLabel.text = weekdayString
        }

    }
    
    // Set the size of the section header
    func calendar(_ calendar: JTAppleCalendarView, sectionHeaderSizeFor range: (start: Date, end: Date), belongingTo month: Int) -> CGSize {
        print("Section Header Size For Method")
        return CGSize(width: calendarView.frame.size.width, height: 100)
    }
    
    // MARK - Table View Methods 
    
    func setUpTableView(){
        // TODO - Want this function to not have to hit the database
        let stringDate = calendarDateFormatter.string(from: selectedDate)
        print("String for selected date \(stringDate)")
        
        calendarAppointmentList = DatabaseFunctions.sharedInstance.getAppointmentByDate(stringDate, formatter: calendarDateFormatter)
        
        calendarTaskList = DatabaseFunctions.sharedInstance.getTaskByDate(stringDate, formatter: calendarDateFormatter)
        
        calendarJournalList = DatabaseFunctions.sharedInstance.getJournalByDate(stringDate, formatter: calendarDateFormatter)
        
        calendarTableView.reloadData()
        calendarTableView.beginUpdates()
        calendarTableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            print("Appointments in Section \(calendarAppointmentList.count)")
            return calendarAppointmentList.count
        }
        else if section == 1{
            print("Tasks in Section \(calendarTaskList.count)")
            return calendarTaskList.count
        }
        else if section == 2{
            print("Journals in Section \(calendarJournalList.count)")
            return calendarJournalList.count
        }
        return 0
    }
    
    // If the arrays have information in them then add to the number of sections to display
    func numberOfSections(in tableView: UITableView) -> Int {
        var count: Int = 0
        
        if(!calendarAppointmentList.isEmpty){
            count += 1
            print("Appointment Count")
        }
        if(!calendarTaskList.isEmpty){
            count += 1
            print("Task Count")
        }
        if(!calendarJournalList.isEmpty){
            count += 1
            print("Journal Count")
        }
        print("Number of Sections in Table == \(count)")
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var appointment: AppointmentItem
        var task: TaskItem
        var journal: JournalItem
        
        print("Number of Appointments \(calendarAppointmentList.count)")
        print("Number of Tasks \(calendarTaskList.count)")
        print("Number of Journals \(calendarJournalList.count)")
        print("IndexPath.section \(indexPath.section)")
        print("IndexPath.row \(indexPath.row)")
        
        // Selected Date
        let stringDate = calendarDateFormatter.string(from: selectedDate)
        print("Selected String Date \(stringDate)")
        
        // TODO Make sure these do not fail
        if calendarAppointmentList.isEmpty == false && indexPath.row < calendarAppointmentList.count{
            appointment = calendarAppointmentList[indexPath.row]
            
            if indexPath.section == 0{
                let appointmentCell: AppointmentTableCell = calendarTableView.dequeueReusableCell(withIdentifier: "AppointmentTableViewCell", for: indexPath) as! AppointmentTableCell
                appointmentCell.appointmentCompleted(appointment)
                appointmentCell.appointmentImage.image = UIImage(named: "Appointments")
                appointmentCell.appointmentTitle.text = appointment.title
                appointmentCell.appointmentType.text  = appointment.type
                appointmentCell.appointmentStart.text = DateFormatter().dateWithTime.string(from: appointment.startingTime)
                appointmentCell.appointmentEnd.text   = DateFormatter().dateWithTime.string(from:appointment.endingTime)
                appointmentCell.appointmentAlert.text = appointment.alert
                appointmentCell.appointmentLocation.text = appointment.appLocation
                appointmentCell.appointmentAdditionalInfo.text = appointment.additionalInfo
                
                // Additional info size to fit
                appointmentCell.appointmentAdditionalInfo.sizeToFit()
                return appointmentCell
            }
        }
        
        if calendarTaskList.isEmpty == false && indexPath.row < calendarTaskList.count{
            task = calendarTaskList[indexPath.row]
            
            let taskCell: TaskTableCell = calendarTableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath) as! TaskTableCell
            taskCell.taskCompleted(task)
            taskCell.taskImage.image = UIImage(named: "Tasks")
            taskCell.taskTitle.text  = task.taskTitle
            taskCell.taskAlert.text  = task.alert
            taskCell.taskEstimatedCompleteDate.text = DateFormatter().dateWithoutTime.string(from:task.estimateCompletionDate)
            taskCell.taskAdditionalInfo.text = task.taskInfo
            
            // Size to fit for additional information
            taskCell.taskAdditionalInfo.sizeToFit()
            return taskCell
        }
        
        if calendarJournalList.isEmpty == false && indexPath.row < calendarJournalList.count{
            journal = calendarJournalList[indexPath.row]
            
            let journalCell: JournalTableCell = calendarTableView.dequeueReusableCell(withIdentifier: "JournalTableViewCell", for: indexPath) as! JournalTableCell
            journalCell.journalImage.image = UIImage(named: "Journals")
            journalCell.journalTitle.text  = journal.getSimplifiedDate()
            journalCell.journalEntry.text  = journal.journalEntry
            journalCell.journalEntry.lineBreakMode = .byWordWrapping
            journalCell.journalEntry.numberOfLines = 0
            
            // Size to fit for journal entry
            journalCell.journalEntry.sizeToFit()
            return journalCell
        }

        // Otherwise return an empty table view cell
        return UITableViewCell()
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return nil if there are no rows in a section
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            print("Title for header is returning nil")
            return nil
        }
        return calendarSectionTitles[section]
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // If there are no rows in a section return nil
        if tableView.dataSource?.tableView(tableView, numberOfRowsInSection: section) == 0{
            print("View for header is returning nil")
            return nil
        }
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
        let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
        label.text = calendarSectionTitles[section]
        label.textColor = UIColor.white
        view.addSubview(label)
        
        // Appointment Section 
        if section == 0{
            view.backgroundColor = UIColor().appointmentColor
        }
        else if section == 1{
            view.backgroundColor = UIColor().taskColor
        }
        else{
            view.backgroundColor = UIColor().journalColor
        }
        
        print("Returning View")
        
        return view
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
