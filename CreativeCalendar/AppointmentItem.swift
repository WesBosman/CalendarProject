//
//  AppointmentItem.swift
//  CreativeCalendar
//
//  Created by Wes on 4/29/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//  This information was taken from a tutorial. By Jason Newell

import Foundation

struct AppointmentItem {
    var title: String
    var startingTime: NSDate
    var endingTime: NSDate
    var appLocation: String
    var additionalInfo: String
    var type:String
    var completed: Bool
    var canceled: Bool
    var deleted: Bool
    var dateCompleted: String?
    var UUID: String
    
    init(type:String, startTime: NSDate, endTime: NSDate, title: String, location: String, additional: String, isComplete: Bool, isCanceled: Bool, isDeleted:Bool,dateFinished:String?, UUID: String) {
        self.title = title
        self.type = type
        self.startingTime = startTime
        self.endingTime = endTime
        self.appLocation = location
        self.additionalInfo = additional
        self.completed = isComplete
        self.canceled = isCanceled
        self.deleted = isDeleted
        self.dateCompleted = dateFinished
        self.UUID = UUID
    }
    
    // Is the starting time earlier than the current date
    var isOverdue: Bool {
        return (NSDate().compare(self.startingTime) == NSComparisonResult.OrderedDescending)     }
}
