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
    var UUID: String
    
    init(startTime: NSDate,
         endTime: NSDate,
         title: String,
         location: String,
         additional: String,
         UUID: String) {
        self.startingTime = startTime
        self.endingTime = endTime
        self.title = title
        self.appLocation = location
        self.additionalInfo = additional
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.startingTime) == NSComparisonResult.OrderedDescending) // deadline is earlier than current date
    }
}
