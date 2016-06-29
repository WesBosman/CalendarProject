//
//  CalendarController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/29/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//  Followed Tutorial by Michael Michailidis

import UIKit

class CalendarController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let identifier = "CalendarCell"
    @IBOutlet weak var calendarView: UICollectionView!
    
    private let calendar = NSCalendar(identifier: NSCalendarIdentifierGregorian)!
    private var startDate: NSDate = NSDate()
    private var endDate:NSDate = NSDate()
    private let dateComponents = NSDateComponents()
    private var todayIndexPath : NSIndexPath?
    private var dateFormatter: NSDateFormatter = NSDateFormatter()
    private var monthInfo : [Int:[Int]] = [Int:[Int]]()
    private var startOfMonth: NSDate = NSDate()
    private(set) var selectedIndexPaths : [NSIndexPath] = [NSIndexPath]()
    private(set) var selectedDates : [NSDate] = [NSDate]()
    private var dictionaryMonths = Dictionary<Int, String>()
    private var headerMonths:[String] = []
    private let WEEKDAYS = 7
    private let ROWS = 6
    private let FIRST_DAY_INDEX = 0
    private let NUMBER_OF_DAYS_INDEX = 1
    private let DATE_SELECTED_INDEX = 2
    
    override func viewDidLoad() {
        calendarView.delegate = self
        calendarView.dataSource = self
        
        dictionaryMonths = [1: "January", 2: "Feburary", 3:"March", 4: "April", 5: "May" , 6: "June", 7: "July", 8: "August", 9: "September", 10: "October", 11: "November", 12: "December"]

        dateFormatter.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss"
        calendarView.backgroundColor = UIColor.whiteColor()
        dateComponents.calendar = calendar
        dateComponents.month = 3
        endDate = calendar.dateByAddingComponents(dateComponents, toDate: startDate, options: .MatchStrictly)!
        
        headerMonths = getMonths()
        print("Start Date: \(startDate)")
        print("End Date: \(endDate)")
        
        
    }
    
    // This method gets the months between the start and end date so that we can put them in 
    // The header view in the collection view.
    func getMonths() -> [String]{
        let startMonth = calendar.components([.Month], fromDate: startDate)
        let endMonth = calendar.components([.Month], fromDate: endDate)
        var s: Int = startMonth.month
        let e: Int = endMonth.month
        var monthArray:[String] = []
        
        while s <= e{
            let thisMonth = dictionaryMonths[s]
            monthArray.append(thisMonth!)
            s = s + 1
        }
        print("Month Array: \(monthArray)")
        return monthArray
    }
    
    // This method return the number of sections in the collection.
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        let firstDayOfStartMonth = self.calendar.components( [.Era, .Year, .Month], fromDate: startDate)
        firstDayOfStartMonth.day = 1 // round to first day
        
        guard let dateFromDayOneComponents = self.calendar.dateFromComponents(firstDayOfStartMonth) else {
            return 0
        }
        
        let startOfMonth = dateFromDayOneComponents
//        print("Start of Month: \(dateFormatter.stringFromDate(startOfMonth))")
        
        let today = NSDate()
        
        if  startOfMonth.compare(today) == NSComparisonResult.OrderedAscending &&
            endDate.compare(today) == NSComparisonResult.OrderedDescending {
            
            let differenceFromTodayComponents = self.calendar.components([NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: startOfMonth, toDate: today, options: NSCalendarOptions())
            
            self.todayIndexPath = NSIndexPath(forItem: differenceFromTodayComponents.day, inSection: differenceFromTodayComponents.month)
            
        }
        
        let differenceComponents = self.calendar.components(NSCalendarUnit.Month, fromDate: startDate, toDate: endDate, options: NSCalendarOptions())
//        print("Difference components: \(differenceComponents.month + 1)")
        return differenceComponents.month + 1
    }
    
    // Return the number of items in each section. The max is 42
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let monthOffsetComponents = NSDateComponents()
        
        // offset by the number of months
        monthOffsetComponents.month = section;
        
        guard let correctMonthForSectionDate = self.calendar.dateByAddingComponents(monthOffsetComponents, toDate: startOfMonth, options: NSCalendarOptions()) else {
            return 0
        }
        
        let numberOfDaysInMonth = self.calendar.rangeOfUnit(.Day, inUnit: .Month, forDate: correctMonthForSectionDate).length
        
        var firstWeekdayOfMonthIndex = self.calendar.component(NSCalendarUnit.Weekday, fromDate: correctMonthForSectionDate)
        firstWeekdayOfMonthIndex = firstWeekdayOfMonthIndex - 1 // firstWeekdayOfMonthIndex should be 0-Indexed
        firstWeekdayOfMonthIndex = (firstWeekdayOfMonthIndex + 6) % 7 // push it modularly so that we take it back one day so that the first day is Monday instead of Sunday which is the default
        
        monthInfo[section] = [firstWeekdayOfMonthIndex, numberOfDaysInMonth]
        
        return WEEKDAYS * ROWS // 7 x 6 = 42
    }
    
    // Return the cell
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let dayCell = collectionView.dequeueReusableCellWithReuseIdentifier(identifier, forIndexPath: indexPath) as! CalendarCell
        
        dayCell.backgroundColor = UIColor.lightGrayColor()
        dayCell.layer.borderColor = UIColor.blackColor().CGColor
        dayCell.layer.cornerRadius = 8
        dayCell.layer.borderWidth = 1
        
        let currentMonthInfo : [Int] = monthInfo[indexPath.section]! // we are guaranteed an array by the fact that we reached this line (so unwrap)
        
        let fdIndex = currentMonthInfo[FIRST_DAY_INDEX]
        let nDays = currentMonthInfo[NUMBER_OF_DAYS_INDEX]
        
        let fromStartOfMonthIndexPath = NSIndexPath(forItem: indexPath.item - fdIndex, inSection: indexPath.section) // if the first is wednesday, add 2
        
        if indexPath.item >= fdIndex &&
            indexPath.item < fdIndex + nDays {
            
            dayCell.dayLabel.text = String(fromStartOfMonthIndexPath.item + 1)
            dayCell.hidden = false
            
        }
        else {
            dayCell.dayLabel.text = ""
            dayCell.hidden = true
        }
        
        dayCell.selected = selectedIndexPaths.contains(indexPath)
        
//        if indexPath.section == 0 && indexPath.item == 0 {
//            self.scrollViewDidEndDecelerating(calendarView)
//        }
        
        if let idx = todayIndexPath {
            dayCell.isToday = (idx.section == indexPath.section && idx.item + fdIndex == indexPath.item)
        }
        
//        if let eventsForDay = eventsByIndexPath[fromStartOfMonthIndexPath] {
//            
//            dayCell.eventsCount = eventsForDay.count
//            
//        } else {
//            dayCell.eventsCount = 0
//        }
        return dayCell
    }
    
    // This method sets the header view for the months and days of the week.
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        
        switch kind{
        case UICollectionElementKindSectionHeader:
            let headerView =
                collectionView.dequeueReusableSupplementaryViewOfKind(kind,
                                                                      withReuseIdentifier: "HeaderView",
                                                                      forIndexPath: indexPath)
                    as! CalendarHeaderView
            
//            print("Header month: \(headerMonths[indexPath.section])")
            
            headerView.monthLabel.text = headerMonths[indexPath.section]
            headerView.bottomLabel.text = headerView.monthLabel.text
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
            
        }
    }
}
