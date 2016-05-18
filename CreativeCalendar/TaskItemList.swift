//
//  TaskItemList.swift
//  CreativeCalendar
//
//  Created by Wes on 5/14/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit
// Global singleton declaration so this class can be instantiated only once
private let sharedTaskList = TaskItemList()

class TaskItemList{
    private let TASK_KEY = "taskItems"
    // New singleton code
    static let sharedInstance = sharedTaskList
    
    /** Old Singleton code
    class var sharedInstance : TaskItemList{
        struct Static{
            static let instance: TaskItemList = TaskItemList()
        }
        return Static.instance
    }
    **/
    
    // Create notifications for tasks??? They aren't really associated with time.
    // Add item to the dictionary
    func addItem(item: TaskItem){
        // Create the dictionary object to hold my objects
        var taskDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(TASK_KEY) ?? Dictionary()
        taskDictionary[item.UUID] = ["title" : item.taskTitle,
                                     "info" : item.taskInfo,
                                     "UUID" : item.UUID]
        
        // Save or Overwrite information in the dictionary
        NSUserDefaults.standardUserDefaults().setObject(taskDictionary, forKey: TASK_KEY)
        // Do not think I need to create a local notification.
    }
    
    // Function to remove items from the dictionary
    func removeItem(item: TaskItem){
        // Do not think I need a notification deletion here but maybe
        
        if var tasks = NSUserDefaults.standardUserDefaults().dictionaryForKey(TASK_KEY){
            tasks.removeValueForKey(item.UUID)
            // Save item
            NSUserDefaults.standardUserDefaults().setObject(tasks, forKey: TASK_KEY)
        }
    }
    
    // Return items for the user to see in the table view
    func allTasks() -> [TaskItem] {
        var taskDict = NSUserDefaults.standardUserDefaults().dictionaryForKey(TASK_KEY) ?? [:]
        let task_items = Array(taskDict.values)
        print(task_items)
        return task_items.map({TaskItem(title: $0["title"] as! String,
                                        info: $0["info"] as! String,
                                        UUID: $0["UUID"] as! String)})
            .sorted({(left: TaskItem, right: TaskItem) -> Bool in (left.taskTitle.compare(right.taskTitle) == .OrderedAscending)})
    }
}
