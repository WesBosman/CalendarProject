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
    var dateCreated: String
    var dateCompleted: String?
    var taskTitle: String
    var taskInfo: String
    var completed: Bool
    var UUID: String
    
    init(dateMade:String,title: String, info: String, completed:Bool, dateFinished: String?, UUID: String){
        self.dateCreated = dateMade
        self.dateCompleted = dateFinished
        self.taskTitle = title
        self.taskInfo = info
        self.completed = completed
        self.UUID = UUID
    }
}