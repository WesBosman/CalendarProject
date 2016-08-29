//
//  TaskItem.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//  This structure is similar to the appointment item structure 

import Foundation

struct TaskItem{
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
    
    // Is the task overdue
    var isOverdue: Bool {
        return (NSDate().compare(self.estimateCompletionDate) == NSComparisonResult.OrderedDescending)
    }
    
//    init(aCoder: NSCoder){
//        self.taskTitle = aCoder.decodeObjectForKey("taskTitle") as! String
//        self.taskInfo = aCoder.decodeObjectForKey("taskInfo") as! String
//        self.estimateCompletionDate = aCoder.decodeObjectForKey("taskEstimatedCompletionDate") as! NSDate
//        self.dateCompleted = aCoder.decodeObjectForKey("taskDateCompleted") as? String
//        self.deleted = aCoder.decodeBoolForKey("taskDelete")
//        self.canceled = aCoder.decodeBoolForKey("taskCancel")
//        self.completed = aCoder.decodeBoolForKey("taskComplete")
//        self.repeating = aCoder.decodeObjectForKey("taskRepeat") as! String
//        self.alert = aCoder.decodeObjectForKey("taskAlert") as! String
//        self.canceledReason = aCoder.decodeObjectForKey("taskCancelReason") as? String
//        self.deletedReason = aCoder.decodeObjectForKey("taskDeleteReason") as? String
//        self.estimateCompletionDate = aCoder.decodeObjectForKey("taskEstimatedCompletionDate") as! NSDate
//        self.UUID = aCoder.decodeObjectForKey("taskUUID") as! String
//    }
//    
//    func encoderWithEncoder(aCoder: NSCoder){
//        aCoder.encodeObject(self.taskTitle, forKey: "taskTitle")
//        aCoder.encodeObject(self.taskInfo, forKey: "taskInfo")
//        aCoder.encodeObject(self.repeating, forKey: "taskRepeat")
//        aCoder.encodeObject(self.alert, forKey: "taskAlert")
//        aCoder.encodeObject(self.canceled, forKey: "taskCancel")
//        aCoder.encodeObject(self.completed, forKey: "taskComplete")
//        aCoder.encodeObject(self.deleted, forKey: "taskDelete")
//        aCoder.encodeObject(self.canceledReason, forKey: "taskCancelReason")
//        aCoder.encodeObject(self.deletedReason, forKey: "taskDeleteReason")
//        aCoder.encodeObject(self.dateCompleted, forKey: "taskDateCompleted")
//        aCoder.encodeObject(self.estimateCompletionDate, forKey: "taskEstimatedCompletionDate")
//        aCoder.encodeObject(self.UUID, forKey: "taskUUID")
//
//    }

}