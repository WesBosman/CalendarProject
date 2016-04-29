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
    var deadline: NSDate
    var UUID: String
    
    init(deadline: NSDate, title: String, UUID: String) {
        self.deadline = deadline
        self.title = title
        self.UUID = UUID
    }
    
    var isOverdue: Bool {
        return (NSDate().compare(self.deadline) == NSComparisonResult.OrderedDescending) // deadline is earlier than current date
    }
}
