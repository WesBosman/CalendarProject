//
//  PopoverViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/20/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController , UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let pageTitles = ["Appointments", "Tasks", "Journals"]
    let scrollView: UIScrollView = UIScrollView(frame: CGRect(x: 20, y: 20, width: 335, height: 325))
    let appointmentTableView: UITableView = UITableView(frame: CGRect(x: 10,y: 35, width: 315, height: 280))
    let taskTableView: UITableView = UITableView(frame: CGRect(x: 10, y: 35, width: 315, height: 280))
    let journalTableView: UITableView = UITableView(frame: CGRect(x: 10, y: 35, width: 315, height: 280))
    let pageControl:UIPageControl = UIPageControl(frame: CGRect(x: 185,  y: 350, width: 200, height: 25))
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var appointment:String = String()
    var task:String = String()
    var journal:String = String()
    var appointmentList:[AppointmentItem] = []
    var taskList:[TaskItem] = []
    var journalList:[JournalItem] = []
    var selectedDate:Date = Date()
    var journalCellHeightArray: [CGFloat] = []
    let appointmentIdentifier: String = "AppointmentTableCell"
    let taskIdentifier: String = "TaskCell"
    let journalIdentifier: String = "JournalCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appointmentList = DatabaseFunctions.sharedInstance.getAppointmentByDate(DateFormatter().dateWithoutTime.string(from: selectedDate), formatter: DateFormatter().dateWithoutTime)
        
        taskList = DatabaseFunctions.sharedInstance.getTaskByDate(DateFormatter().dateWithoutTime.string(from: selectedDate), formatter: DateFormatter().dateWithoutTime)
        
        journalList = DatabaseFunctions.sharedInstance.getJournalByDate(DateFormatter().dateWithoutTime.string(from: selectedDate), formatter: DateFormatter().dateWithoutTime)
        
        configurePageController()
        scrollView.layer.cornerRadius = 10
        appointmentTableView.layer.cornerRadius = 10
        taskTableView.layer.cornerRadius = 10
        journalTableView.layer.cornerRadius = 10
        
        self.appointmentTableView.estimatedRowHeight = 85.0
        self.taskTableView.estimatedRowHeight = 85.0
        self.journalTableView.estimatedRowHeight = 85.0
        
        self.scrollView.delegate = self
        
        self.appointmentTableView.register(AppointmentCell.self, forCellReuseIdentifier: appointmentIdentifier)
        self.appointmentTableView.delegate = self
        self.appointmentTableView.dataSource = self
       
        
        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        self.taskTableView.register(TaskCell.self, forCellReuseIdentifier: taskIdentifier)
        
        self.journalTableView.delegate = self
        self.journalTableView.dataSource = self
        self.journalTableView.register(JournalCell.self, forCellReuseIdentifier: journalIdentifier)
        
        // Register cell appointment
        //self.appointmentTableView.register(AppointmentTableCell.self, forCellReuseIdentifier: appointmentIdentifier)
//        self.appointmentTableView.register(UINib(nibName:"AppointmentTableViewCell", bundle: nil), forCellReuseIdentifier: appointmentIdentifier)
        
        
        self.view.addSubview(scrollView)
        
        for index in 0..<3 {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.isPagingEnabled = true
//            self.scrollView.scrollEnabled = true
            
            switch(index){
            case 0:
                // Appointment subview
                let subView = UIView(frame: frame)
                subView.backgroundColor = UIColor().appointmentColor
                let appointmentHeader = UILabel(frame: CGRect(x: 10, y: 10, width: subView.frame.width - 10, height: 20))
                appointmentHeader.text = "Appointments"
                
                subView.addSubview(appointmentHeader)
                subView.addSubview(appointmentTableView)
                self.scrollView .addSubview(subView)
                
            case 1:
                // Task subview
                let subView = UIView(frame: frame)
                subView.backgroundColor = UIColor().taskColor
                let taskHeader = UILabel(frame: CGRect(x: 10, y: 10, width: subView.frame.width - 10, height: 20))
                taskHeader.text = "Tasks"
                
                subView.addSubview(taskHeader)
                subView.addSubview(taskTableView)
                self.scrollView .addSubview(subView)
                
            case 2:
                // Journal subview
                let subView = UIView(frame: frame)
                subView.backgroundColor = UIColor().journalColor
                let journalHeader = UILabel(frame: CGRect(x: 10, y: 10, width: subView.frame.width - 10, height: 20))
                journalHeader.text = "Journals"
                
                subView.addSubview(journalHeader)
                subView.addSubview(journalTableView)
                self.scrollView .addSubview(subView)
                
            default:
                break
                
            }
        }
        
        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width * 3, height: self.scrollView.frame.size.height)
        
        pageControl.addTarget(self, action: #selector(PopoverViewController.changePage(_:)), for: UIControlEvents.valueChanged)
    }
    
    // MARK - Page Controller Methods
    
    func configurePageController(){
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.white
        pageControl.currentPageIndicatorTintColor = UIColor.black
        self.view.addSubview(pageControl)
    }
    
    func changePage(_ sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == appointmentTableView{
            return appointmentList.count
        }
        else if tableView == taskTableView{
            return taskList.count
        }
        else{
            return journalList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == appointmentTableView{
            let appointment = appointmentList[(indexPath as NSIndexPath).row] as AppointmentItem
            let cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "AppointmentPopover")
            cell.textLabel?.text = appointment.title
            cell.detailTextLabel?.text = "type: " + appointment.type
                + "\nlocation: " + appointment.appLocation
                + "\nstart: " + DateFormatter().dateWithTime.string(from: appointment.startingTime)
                + "\nend:   " +  DateFormatter().dateWithTime.string(from: appointment.endingTime)
                + "\nadditional info: " + appointment.additionalInfo
            
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .byWordWrapping
            
//            let cell: AppointmentTableCell = appointmentTableView.dequeueReusableCell(withIdentifier: appointmentIdentifier, for: indexPath) as! AppointmentTableCell
//            
//            cell.appointmentTitle.text  = appointment.title
//            cell.appointmentType.text   = appointment.type
            
            return cell
        }
        else if tableView == taskTableView{
            let task = taskList[(indexPath as NSIndexPath).row] as TaskItem
            let cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "TaskPopover")
            cell.textLabel?.text = task.taskTitle
            cell.detailTextLabel?.text = DateFormatter().dateWithTime.string(from: task.estimateCompletionDate) + "\n" + task.taskInfo
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .byWordWrapping
            return cell
        }
        else{
            // TO-DO How to poisition the text so its readable even if the text is large
            let journal = journalList[(indexPath as NSIndexPath).row] as JournalItem
            let cell = UITableViewCell.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: "JournalPopover")
            cell.textLabel?.text = journal.getSimplifiedDate()
            cell.detailTextLabel?.text = journal.journalEntry
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .byWordWrapping
            cell.textLabel?.sizeToFit()
            cell.detailTextLabel?.sizeToFit()
            
            cell.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleBottomMargin, UIViewAutoresizing.flexibleTopMargin]
            
            
            let journalTitleHeight = cell.textLabel?.frame.height
            let journalSubtitleHeight = cell.textLabel?.frame.height
            let combinedHeight = journalTitleHeight! + journalSubtitleHeight!
            print("Journal Combined Height: \(combinedHeight)")
            
            journalCellHeightArray.append(combinedHeight)
            cell.sizeToFit()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // Estimated height for row at an index path must be called in order to use automatic dimensions
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0
    }
}
