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
    
    var calendarSectionTitles: [String] = ["Appointments", "Tasks", "Journals"]
    var calendarAppointmentList: [AppointmentItem] = []
    var calendarTaskList: [TaskItem] = []
    var calendarJournalList: [JournalItem] = []
    
    var selectedIndexPath: IndexPath? = nil
    @IBOutlet weak var calendarTableView: UITableView!
    let calendarDateFormatter = DateFormatter().dateWithoutTime
    
    fileprivate let appointmentCellID = "AppointmentTableViewCell"
    fileprivate let taskCellID =        "TaskTableViewCell"
    fileprivate let journalCellID =     "JournalTableViewCell"
    
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
                
        // Select the current date
        calendarView.reloadData() {
            self.calendarView.selectDates([Date()], triggerSelectionDelegate: true)
        }
        
        // Register the cells for the tableView
        
        // Register appointment cells
        let appointmentNib = UINib(nibName: appointmentCellID, bundle: nil)
        self.calendarTableView.register(appointmentNib, forCellReuseIdentifier: "AppointmentTableViewCell")
        
        // Register task cell
        let taskNib = UINib(nibName: taskCellID, bundle: nil)
        self.calendarTableView.register(taskNib, forCellReuseIdentifier: "TaskTableViewCell")
        
        // Register journal cell
        let journalNib = UINib(nibName: journalCellID, bundle: nil)
        self.calendarTableView.register(journalNib, forCellReuseIdentifier: "JournalTableViewCell")
        
        // Set up the calendar table view
        self.calendarTableView.layer.cornerRadius = 10
        self.calendarTableView.backgroundColor = UIColor.clear
        self.calendarTableView.allowsSelection = false
        
        // There will be no lines when there are no cells
        self.calendarTableView.tableFooterView = UIView(frame: CGRect())
        
        // Try to set up the automatic dimensioning of the table view
        self.calendarTableView.rowHeight = UITableViewAutomaticDimension
        self.calendarTableView.estimatedRowHeight = 100
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
    
    // Configure the calendar
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        print("Congifure Calendar Method")
        let parameters = ConfigurationParameters(startDate: Date().calendarStartDate,
                                                 endDate:   Date().calendarEndDate,
                                                 numberOfRows: numberOfRows,
                                                 calendar:     userCalendar,
                                                 firstDayOfWeek: .sunday)
        return parameters
    }
    
    // Display the calendar cells
    func calendar(_ calendar: JTAppleCalendarView, willDisplayCell cell: JTAppleDayCellView, date: Date, cellState: CellState) {

        if let calendarCell = cell as? CalendarCell{
            calendarCell.setUpCellBeforeDisplay(cellState)
            // If the appointment counter is larger than zero do not hide it
            if calendarCell.appointmentCounter > 0{
                calendarCell.appointmentCounterLabel.isHidden = false
                calendarCell.appointmentCounterLabel.text = String(calendarCell.appointmentCounter)
            }
            else{
                calendarCell.appointmentCounterLabel.isHidden = true
            }
            // If the task counter is larger than zero do not hide it
            if calendarCell.taskCounter > 0{
                calendarCell.taskCounterLabel.isHidden = false
                calendarCell.taskCounterLabel.text = String(calendarCell.taskCounter)
            }
            else{
                calendarCell.taskCounterLabel.isHidden = true
            }
            // If the journal counter is larger than zero do not hide it
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
        print("Did Select Date (Cell) Method")
        
        let stringDate = DateFormatter().dateWithoutTime.string(from: cellState.date)
        
        print("String Date \(stringDate)")
        
        // Send the selected date to the popover so we know which appointments tasks and journals to retrieve from the database
        if let calendarCell = cell as? CalendarCell{
            selectedDate = cellState.date
            selectedCell = calendarCell
            calendarCell.updateCell(cellState)
            
            // Get the items at the selected date
            setUpTableView()
        }
    }
    
    // Function for when the cell has been deselected
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleDayCellView?, cellState: CellState) {
        print("Did De-Select (Cell) Date Method")
        
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
    
    //
    // MARK - Table View Methods 
    //
    
    func setUpTableView(){
        // TODO - Want this function to not have to hit the database
        print("Set up Table View Method")
        
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
        
        switch(section){
        // Appointments
        case 0:
            return calendarAppointmentList.count
        // Tasks
        case 1:
            print("Tasks in Calendar \(calendarTaskList.count)")
            return calendarTaskList.count
        // Journals
        case 2:
            print("Journals in Calendar \(calendarJournalList.count)")
            return calendarJournalList.count
        // Default
        default:
            return 0
        }
    }
    
    // If the arrays have information in them then add to the number of sections to display
    func numberOfSections(in tableView: UITableView) -> Int {
        // There will always be three sections in the table view
        // Appointments first
        // Tasks second
        // Journals third
        return 3
    }
    
    // Returns either an appointment, task or journal cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(indexPath.section){
        // Appointments
        case 0:
            print("Cell for row at index path case 0 return appointment cell")
            let appointment = calendarAppointmentList[indexPath.row]
            print("Appointment Cell Title \(appointment.title)")
            
            
            let appointmentCell: AppointmentTableCell = calendarTableView.dequeueReusableCell(withIdentifier: appointmentCellID, for: indexPath) as! AppointmentTableCell
            appointmentCell.appointmentCompleted(appointment)
            appointmentCell.appointmentImage.image = UIImage(named: "Appointments")
            
            appointmentCell.setTitle(title: appointment.title)
            appointmentCell.setType(type: appointment.type)
            appointmentCell.setStart(start: DateFormatter().dateWithTime.string(from: appointment.startingTime))
            appointmentCell.setEnd(end: DateFormatter().dateWithTime.string(from: appointment.endingTime))
            appointmentCell.setLocation(location: appointment.appLocation)
            appointmentCell.setAlert(alert: appointment.alert)
            appointmentCell.setRepeat(rep: appointment.repeating)
            appointmentCell.setAdditional(additional: appointment.additionalInfo)
            
            // Additional info size to fit
            appointmentCell.appointmentAdditionalInfo.sizeToFit()
            return appointmentCell
            
        // Tasks
        case 1:
            print("Cell for row at index path case 1 return task cell")
            let task = calendarTaskList[indexPath.row]
            print("Task Cell Title \(task.taskTitle)")
            
            let taskCell: TaskTableCell = calendarTableView.dequeueReusableCell(withIdentifier: taskCellID, for: indexPath) as! TaskTableCell
            taskCell.taskCompleted(task)
            taskCell.taskImage.image = UIImage(named: "Tasks")
            taskCell.setTitle(title: task.taskTitle)
            taskCell.setEstimatedCompletedDate(date: DateFormatter().dateWithoutTime.string(from:task.estimateCompletionDate))
            taskCell.setAlert(alert: task.alert)
            taskCell.setRepeating(rep: task.repeating)
            taskCell.setAdditional(additional: task.taskInfo)
                
            // Size to fit for additional information
            taskCell.taskAdditionalInfo.sizeToFit()
            return taskCell
        
        // Journals
        case 2:
            print("Cell for row at index path case 2 return journal cell")
            let journal = calendarJournalList[indexPath.row]
            print("Journal Cell title \(journal.journalDate)")
            
            
            let journalCell: JournalTableCell = calendarTableView.dequeueReusableCell(withIdentifier: journalCellID, for: indexPath) as! JournalTableCell
            journalCell.journalImage.image = UIImage(named: "Journals")
            journalCell.journalTitle.text  = journal.journalTitle
            journalCell.journalEntry.text  = journal.journalEntry
            journalCell.journalEntry.lineBreakMode = .byWordWrapping
            journalCell.journalEntry.numberOfLines = 0
            
            // Size to fit for journal entry
            journalCell.journalEntry.sizeToFit()
            return journalCell

        // Default
        default:
            print("Cell for row at index path default case return empty cell")
            let cell = UITableViewCell()
//            cell.backgroundColor = UIColor.clear
            return cell
        }
    }

    // Return the title for each section header unless the section is empty
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // Return nil if there are no rows in a section
        if tableView.dataSource?.tableView(calendarTableView, numberOfRowsInSection: section) == 0{
            print("Title for header is returning nil for section \(section)")
            return nil
        }
        // Otherwise we will return a section title
        else{
            return calendarSectionTitles[section]
        }
    }
    
    // Return the view for each section header
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // If there are no rows in a section return nil
        if tableView.dataSource?.tableView(calendarTableView, numberOfRowsInSection: section) == 0{
            print("View for header is returning nil for section \(section)")
            return nil
        }
        // Otherwise configure the header's view and return it
        else{
            // Configure the view
            let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 18))
            let label = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.frame.size.width, height: 18))
            label.text = calendarSectionTitles[section]
            label.textColor = UIColor.white
            view.addSubview(label)
        
            // Color the headers of the sections in the table
            if section == 0{
                view.backgroundColor = UIColor().appointmentColor
            }
            else if section == 1{
                view.backgroundColor = UIColor().taskColor
            }
            else{
                view.backgroundColor = UIColor().journalColor
            }
        
            return view
        }
    }
    
    // This method makes the cells dissapear when there is no content
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(tableView.dataSource?.tableView(calendarTableView, numberOfRowsInSection: section) == 0){
            print("Height for the header in section \(section) is zero")
            return 0
        }
        else{
            return 30
        }
    }
}
