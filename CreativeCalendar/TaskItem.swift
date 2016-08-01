//
//  TaskItem.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//  This structure is similar to the appointment item structure 

import Foundation

struct TaskItem{
    var dateCreated: NSDate
    var dateCompleted: String?
    var estimateCompletionDate: String
//    var estimateCompletionDate: NSDate
    var taskTitle: String
    var taskInfo: String
    var completed: Bool
    var canceled: Bool
    var deleted: Bool
    var UUID: String
    
    init(dateMade:NSDate, title: String, info: String, estimatedCompletion:String, completed:Bool, canceled: Bool, deleted: Bool, dateFinished:String?, UUID: String){
        self.dateCreated = dateMade
        self.dateCompleted = dateFinished
        self.taskTitle = title
        self.taskInfo = info
        self.completed = completed
        self.canceled = canceled
        self.deleted = deleted
        self.estimateCompletionDate = estimatedCompletion
        self.UUID = UUID
    }
}