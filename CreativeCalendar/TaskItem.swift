//
//  TaskItem.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//  This structure is similar to the appointment item structure 


class GlobalTasks{
    static var taskDictionary:Dictionary<String, [TaskItem]> = [:]
    private var taskItems: [TaskItem] = []
    private var taskSections: [String] = []
    private let db = DatabaseFunctions.sharedInstance
    private var formatter = NSDateFormatter().dateWithoutTime
    
    func setUpTaskDictionary(){
        taskItems = db.getAllTasks()
        
        // Sort the tasks based on estimated completion date
        taskItems = taskItems.sort({$0.estimateCompletionDate.compare($1.estimateCompletionDate) == NSComparisonResult.OrderedAscending})
        
        for task in taskItems{
            let taskDate = formatter.stringFromDate(task.estimateCompletionDate)
            
            // If task sections does not contain the date add it
            if(!taskSections.contains(taskDate)){
                taskSections.append(taskDate)
            }
        }
        
        for section in taskSections{
            // Get the tasks based on their date
            taskItems = db.getTaskByDate(section, formatter: formatter)
            
            // Set the global task dictionary
            GlobalTasks.taskDictionary.updateValue(taskItems, forKey: section)
        }
    }
}

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
}