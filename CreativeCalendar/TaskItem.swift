//
//  TaskItem.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//  This structure is similar to the appointment item structure 
//  May end up wanting to set a approximate time to remind people of their to do list.

import Foundation

struct TaskItem{
    var taskTitle: String
    var taskInfo: String
    var UUID: String
    
    init(title: String, info: String, UUID: String){
        self.taskTitle = title
        self.taskInfo = info
        self.UUID = UUID
    }
    
}