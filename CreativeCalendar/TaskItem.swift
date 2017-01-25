//
//  TaskItem.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//  This structure is similar to the appointment item structure 


class Tasks{
    static var taskDictionary:Dictionary<String, [TaskItem]> = [:]
    static var taskItems: [TaskItem] = []
    static var taskSections: [String] = []
    fileprivate let db = DatabaseFunctions.sharedInstance
    fileprivate var formatter = DateFormatter().dateWithoutTime
    
    func setUpTaskDictionary(){
        Tasks.taskItems = db.getAllTasks()
        
        // Sort the tasks based on estimated completion date
        Tasks.taskItems = Tasks.taskItems.sorted(by: {$0.estimateCompletionDate.compare($1.estimateCompletionDate) == ComparisonResult.orderedAscending})
        
        for task in Tasks.taskItems{
            let taskDate = formatter.string(from: task.estimateCompletionDate)
            
            // If task sections does not contain the date add it
            if(!Tasks.taskSections.contains(taskDate)){
                Tasks.taskSections.append(taskDate)
            }
        }
        
        for section in Tasks.taskSections{
            // Get the tasks based on their date
            Tasks.taskItems = db.getTaskByDate(section, formatter: formatter)
            
            // Set the global task dictionary
            Tasks.taskDictionary.updateValue(Tasks.taskItems, forKey: section)
        }
    }
    
    func addTaskToDictionary(){
        
    }
    
    func removeTaskFromDictionary(){
        
    }
}

struct TaskItem{
    var dateCompleted: String?
    var estimateCompletionDate: Date
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
    
    init(title: String, info: String, estimatedCompletion: Date, repeatTime: String, alertTime: String, isComplete:Bool, isCanceled: Bool, isDeleted: Bool, dateFinished:String?, cancelReason: String?, deleteReason: String?, UUID: String){
        
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
        return (Date().compare(self.estimateCompletionDate) == ComparisonResult.orderedDescending)
    }
}
