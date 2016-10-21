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
    let scrollView: UIScrollView = UIScrollView(frame: CGRectMake(20, 20, 335, 325))
    let appointmentTableView: UITableView = UITableView(frame: CGRectMake(10,35, 315, 280))
    let taskTableView: UITableView = UITableView(frame: CGRectMake(10, 35, 315, 280))
    let journalTableView: UITableView = UITableView(frame: CGRectMake(10, 35, 315, 280))
    let pageControl:UIPageControl = UIPageControl(frame: CGRectMake(185,  350, 200, 25))
    var frame = CGRectMake(0, 0, 0, 0)
    var appointment:String = String()
    var task:String = String()
    var journal:String = String()
    var appointmentList:[AppointmentItem] = []
    var taskList:[TaskItem] = []
    var journalList:[JournalItem] = []
    var selectedDate:NSDate = NSDate()
    var journalCellHeightArray: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appointmentList = DatabaseFunctions.sharedInstance.getAppointmentByDate(NSDateFormatter().dateWithoutTime.stringFromDate(selectedDate), formatter: NSDateFormatter().dateWithoutTime)
        
        taskList = DatabaseFunctions.sharedInstance.getTaskByDate(NSDateFormatter().dateWithoutTime.stringFromDate(selectedDate), formatter: NSDateFormatter().dateWithoutTime)
        
        journalList = DatabaseFunctions.sharedInstance.getJournalByDate(NSDateFormatter().dateWithoutTime.stringFromDate(selectedDate), formatter: NSDateFormatter().dateWithoutTime)
        
        configurePageController()
        scrollView.layer.cornerRadius = 10
        appointmentTableView.layer.cornerRadius = 10
        taskTableView.layer.cornerRadius = 10
        journalTableView.layer.cornerRadius = 10
        
        self.appointmentTableView.estimatedRowHeight = 85.0
        self.taskTableView.estimatedRowHeight = 85.0
        self.journalTableView.estimatedRowHeight = 85.0
        
        self.scrollView.delegate = self
        self.appointmentTableView.delegate = self
        self.appointmentTableView.dataSource = self
        self.taskTableView.delegate = self
        self.taskTableView.dataSource = self
        self.journalTableView.delegate = self
        self.journalTableView.dataSource = self
        self.view.addSubview(scrollView)
        
        for index in 0..<3 {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            self.scrollView.pagingEnabled = true
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
        
        self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width * 3, self.scrollView.frame.size.height)
        
        pageControl.addTarget(self, action: #selector(PopoverViewController.changePage(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    // MARK - Page Controller Methods
    
    func configurePageController(){
        pageControl.numberOfPages = 3
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.whiteColor()
        pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        self.view.addSubview(pageControl)
    }
    
    func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPointMake(x, 0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if tableView == appointmentTableView{
            let appointment = appointmentList[indexPath.row] as AppointmentItem
            let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "AppointmentPopover")
            cell.textLabel?.text = appointment.title
            cell.detailTextLabel?.text = "type: " + appointment.type
                + "\nlocation: " + appointment.appLocation
                + "\nstart: " + NSDateFormatter().dateWithTime.stringFromDate(appointment.startingTime)
                + "\nend:   " +  NSDateFormatter().dateWithTime.stringFromDate(appointment.endingTime)
                + "\nadditional info: " + appointment.additionalInfo
            
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .ByWordWrapping
            return cell
        }
        else if tableView == taskTableView{
            let task = taskList[indexPath.row] as TaskItem
            let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "TaskPopover")
            cell.textLabel?.text = task.taskTitle
            cell.detailTextLabel?.text = NSDateFormatter().dateWithTime.stringFromDate(task.estimateCompletionDate) + "\n" + task.taskInfo
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .ByWordWrapping
            return cell
        }
        else{
            // TO-DO How to poisition the text so its readable even if the text is large
            let journal = journalList[indexPath.row] as JournalItem
            let cell = UITableViewCell.init(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "JournalPopover")
            cell.textLabel?.text = journal.getSimplifiedDate()
            cell.detailTextLabel?.text = journal.journalEntry
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.lineBreakMode = .ByWordWrapping
            cell.textLabel?.sizeToFit()
            cell.detailTextLabel?.sizeToFit()
            
            cell.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleBottomMargin, UIViewAutoresizing.FlexibleTopMargin]
            
            
            let journalTitleHeight = cell.textLabel?.frame.height
            let journalSubtitleHeight = cell.textLabel?.frame.height
            let combinedHeight = journalTitleHeight! + journalSubtitleHeight!
            print("Journal Combined Height: \(combinedHeight)")
            
            journalCellHeightArray.append(combinedHeight)
            cell.sizeToFit()
            return cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
