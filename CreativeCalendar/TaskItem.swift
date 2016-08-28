//
//  TaskItem.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//  This structure is similar to the appointment item structure 

import Foundation

struct TaskItem{
//    var dateCreated: NSDate
    var dateCompleted: String?
    var estimateCompletionDate: NSDate
    var taskTitle: String
    var taskInfo: String
    var repeating: String
    var alert: String
    var completed: Bool
    var canceled: Bool
    var deleted: Bool
    var canceledReason: String?
    var deletedReason: String?
    var UUID: String
    
    init(title: String, info: String, estimatedCompletion: NSDate, repeatTime: String, alertTime: String, isComplete:Bool, isCanceled: Bool, isDeleted: Bool, dateFinished:String?, cancelReason: String?, deleteReason: String?, UUID: String){
        self.dateCompleted = dateFinished
        self.taskTitle = title
        self.taskInfo = info
        self.repeating = repeatTime
        self.alert = alertTime
        self.completed = isComplete
        self.canceled = isCanceled
        self.deleted = isDeleted
        self.estimateCompletionDate = estimatedCompletion
        self.canceledReason = cancelReason
        self.deletedReason = deleteReason
        self.UUID = UUID
    }
}