//
//  DatabaseFunctions.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/18/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//
//  MARK - FMDB

import Foundation
import UIKit

// This class will be used to communicate with the sqlite database on the device.
private let database = DatabaseFunctions()

class DatabaseFunctions{
    // Only ever want one instance of this class.
    static let sharedInstance = database
    private init(){}
    
    let dateFormat = NSDateFormatter().universalFormatter

    /** Make the database and store it in the documents section
      * Made this a lazy variable so it will get initiated when the class gets called
      * Eliminates calling the function over and over. Less overhead.
      */
    lazy var makeDb: FMDatabase = {
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        
        let fileURL = documents.URLByAppendingPathComponent("Database.sqlite")
        
        let db = FMDatabase(path: fileURL.path)
        // If the database is not open for editing then make it editable
        if(!db.open()){
            db.open()
        }
        // Create the three tables for storing our information.
        do{
            try db.executeUpdate("create table if not exists Appointments(id integer primary key autoincrement, date_created text, title text, type text, start_date text, end_date text, location text, additional text, completed bool, canceled bool, deleted bool, date_completed text, date_canceled text, date_deleted, cancel_reason, delete_reason, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Tasks(id integer primary key autoincrement, date_created text, task text, additional text, completed bool, canceled bool, deleted bool, estimated_completed_date text, date_completed text, date_canceled text, date_deleted text, cancel_reason, delete_reason, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Journals(id integer primary key autoincrement, date text, journal text, deleted bool, date_deleted, delete_reason, uuid text)", values: nil)
            
            // Get DatabasePath
            NSLog("Database File Path: \(fileURL.path!)")
            
        }
        catch let err as NSError{
            print("Creating Database Error: \(err.localizedDescription)")
        }
        return db
    }()
    
    // MARK - Setter Methods
    
    // Add an item to the appointment table
    func addToAppointmentDatabase(item: AppointmentItem){
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }

        let current = NSDate()
        let currentDateString = dateFormat.stringFromDate(current)
        let startDateString = dateFormat.stringFromDate(item.startingTime)
        let endDateString = dateFormat.stringFromDate(item.endingTime)
        
        do{
            let rs = try db.executeQuery("SELECT date_created, title, type, start_date, end_date, location, additional, completed, canceled, deleted, date_completed, date_canceled, date_deleted FROM Appointments", values: nil)
            var count: Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Appointments Table database: \(count)")
            try db.executeUpdate("INSERT into Appointments( date_created, title, type, start_date, end_date, location, additional,completed, canceled, deleted, uuid) values( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", values:[currentDateString, item.title, item.type, startDateString, endDateString, item.appLocation, item.additionalInfo, false, false, false, item.UUID])
            
            // Add a notification for the item.
            setAppointmentNotification(item)
            
        } catch let err as NSError{
            print("Add Appointment to Database ERROR: \(err.localizedDescription)")
        }
    }
    
    // Add a task to the task table
    func addToTaskDatabase(item: TaskItem){
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        let dateCreatedAsString = dateFormat.stringFromDate(item.dateCreated)
        let estimatedCompletionDate = NSDateFormatter().dateWithTime.stringFromDate(item.estimateCompletionDate)
        
        do{
            let rs = try db.executeQuery("SELECT date_created, task, additional, completed, canceled, deleted, estimated_completed_date, uuid FROM Tasks", values: nil)
            var count:Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Task Table database: \(count)")
            try db.executeUpdate("INSERT into Tasks(date_created, task, additional, completed, canceled, deleted, estimated_completed_date, uuid) values(?, ?, ?, ?, ?, ?, ?, ?)", values:[ dateCreatedAsString, item.taskTitle, item.taskInfo, item.completed, item.canceled, item.deleted, estimatedCompletionDate, item.UUID])
            
        } catch let err as NSError{
            print("Add Task to Database ERROR: \(err.localizedDescription)")
        }
    }
    
    // Add journal to the journal table
    func addToJournalDatabase(journal:JournalItem){
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        let journalDateAsString = dateFormat.stringFromDate(journal.journalDate)
        
        
        do{
            let rs = try db.executeQuery("SELECT date, journal FROM Journals", values: nil)
            var count:Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Journal Table database: \(count)")
            try db.executeUpdate("INSERT into Journals(date, journal, deleted, uuid) values(?, ?,?, ?)", values:[ journalDateAsString, journal.journalEntry, journal.journalDeleted, journal.journalUUID])
            
        } catch let err as NSError{
            print("Add journal to Database ERROR: \(err.localizedDescription)")
        }
    }

    // MARK - Update Methods
    
    // Update the appointment item when it gets completed, canceled or deleted
    func updateAppointment(item: AppointmentItem){
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }

        let current = NSDate()
//        let dateFormat = NSDateFormatter().universalFormatter()
        let currentDateString = dateFormat.stringFromDate(current)
        
        do{
            let selectStatement = "SELECT completed, canceled, deleted FROM Appointments WHERE uuid = ?"
            let selectResult = try db.executeQuery(selectStatement, values: [item.UUID])
            
            while(selectResult.next()){
                let isComplete = item.completed
                let isCanceled = item.canceled
                let isDeleted = item.deleted
                
                let updateCompleteStatement = "UPDATE Appointments SET completed=?, date_completed=? WHERE uuid=?"
                let updateCancelStatement = "UPDATE Appointments SET canceled=?, date_canceled=?, cancel_reason=? WHERE uuid=?"
                let updateDeleteStatement = "UPDATE Appointments SET deleted=?, date_deleted=?, delete_reason=? WHERE uuid=?"
//                print("Appointment Name \(item.title) completed: \(item.completed)")
                
                // Appointment Completed
                if isComplete == true{
//                    print("Appointment Completed")
                    try db.executeUpdate(updateCompleteStatement, values: [isComplete, currentDateString, item.UUID])
                    removeAppointmentNotification(item)
                }
                // If the appointment was already completed turn it off
                else{
//                    print("Appointment Incomplete")
                    try db.executeUpdate(updateCompleteStatement, values: [isComplete, "" ,  item.UUID])
                    setAppointmentNotification(item)
                }
                
                // Appointment Canceled
                if isCanceled == true{
//                    print("Appointment Canceled")
                    try db.executeUpdate(updateCancelStatement, values: [true, currentDateString, item.canceledReason!, item.UUID])
                    
                    // When they cancel the appointment remove the notification
                    removeAppointmentNotification(item)
                }
                else{
//                    print("Appointment no longer Canceled")
                    try db.executeUpdate(updateCancelStatement, values: [false, "","", item.UUID])
                    setAppointmentNotification(item)
                }
                
                // Appointment Deleted
                if isDeleted == true{
//                    print("Appointment Deleted")
                    try db.executeUpdate(updateDeleteStatement, values: [true, currentDateString, item.deletedReason!, item.UUID])
                    
                    // When they delete the appointment remove the notification
                    removeAppointmentNotification(item)
                }
                else{
//                    print("Appointment no longer Deleted")
                    try db.executeUpdate(updateDeleteStatement, values: [false, "", "", item.UUID])
                }
                
                
                
            }
            
        }
        catch let err as NSError{
            print("Appointment updating ERROR \(err.localizedDescription)")
        }
    }
    
    // Update the task item to be able to change the image associated with the task
    func updateTask(item: TaskItem){
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }

        let current = NSDate()
//        let dateFormat = NSDateFormatter().universalFormatter()
        let currentDateString = dateFormat.stringFromDate(current)
        
        // If date completed equals false then do this...
        do{
            // Get the value of the completed column for the task with the given uuid
            let selectStatement = "SELECT completed, canceled, deleted FROM Tasks WHERE uuid=?"
            let selectResult = try db.executeQuery(selectStatement, values: [item.UUID])
            
            while selectResult.next(){
                let isComplete = item.completed
                let isCanceled = item.canceled
                let isDeleted = item.deleted
                
                let completedStatement = "UPDATE Tasks SET completed=?, date_completed=? WHERE uuid=?"
                let canceledStatement = "UPDATE Tasks SET canceled=?, date_canceled=?, cancel_reason=? WHERE uuid=?"
                let deletedStatement = "UPDATE Tasks SET deleted=?, date_deleted=?, delete_reason=? WHERE uuid=?"
//                print("Task Name: \(item.taskTitle) Completed: \(item.completed)")

                // Complete the Task
                if isComplete == true{
                    try db.executeUpdate(completedStatement, values: [isComplete, currentDateString, item.UUID])
                    removeTaskNotification(item)
                }
                else{
                    try db.executeUpdate(completedStatement, values: [isComplete, "" , item.UUID])
                    setTaskNotification(item)
                }
                
                // Cancel the Task
                if isCanceled == true{
                    try db.executeUpdate(canceledStatement, values: [isCanceled, currentDateString , item.canceledReason!, item.UUID])
                    removeTaskNotification(item)
                }
                else{
                    try db.executeUpdate(canceledStatement, values: [isCanceled, "", "", item.UUID])
                    setTaskNotification(item)
                }
                
                // Delete the Task
                if isDeleted == true{
                    try db.executeUpdate(deletedStatement, values: [isDeleted, currentDateString, item.deletedReason!, item.UUID])
                    removeTaskNotification(item)
                }
                else{
                    try db.executeUpdate(deletedStatement, values: [isDeleted, "", "", item.UUID])
                }
            }
        }
        catch let err as NSError{
            print("Task Update Error: \(err.localizedDescription)")
        }
    }
    
    func updateJournal(item: JournalItem){
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        let current = NSDate()
        let currentDateString = dateFormat.stringFromDate(current)
        
        // If date completed equals false then do this...
        do{
            // Get the value of the completed column for the task with the given uuid
            let selectStatement = "SELECT deleted FROM Journals WHERE uuid=?"
            let selectResult = try db.executeQuery(selectStatement, values: [item.journalUUID])
            
            while selectResult.next(){
                let isDeleted = item.journalDeleted
                let deletedStatement = "UPDATE Journals SET deleted=?, date_deleted=?, delete_reason=? WHERE uuid=?"
                
                // Delete the Journal
                if isDeleted == true{
                    try db.executeUpdate(deletedStatement, values: [isDeleted, currentDateString, item.journalDeletedReason! , item.journalUUID])
                }
            }
        }
        catch let err as NSError{
            print("Journal Update Error: \(err.localizedDescription)")
        }

    }
    
    // MARK - Getter Methods
    
    // Used for giving the user the title of the appointment when alert dialog box is delivered
    // and the user is inside of the application
    func getAppointmentByDate(date:String, formatter: NSDateFormatter)-> [AppointmentItem]{
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        var appointmentArray: [AppointmentItem] = []

        do{
            let fetchAppointmentByDateStatement = "SELECT title, type, start_date, end_date, location, additional, completed, canceled, deleted, date_completed, cancel_reason, delete_reason, uuid FROM Appointments WHERE deleted=?"
            let query = try db.executeQuery(fetchAppointmentByDateStatement, values: [false])
            
            while query.next(){
                let appointmentTitle = query.objectForColumnName("title") as! String
                let appointmentType = query.objectForColumnName("type") as! String
                let appointmentStart = dateFormat.dateFromString(query.objectForColumnName("start_date") as! String)
                let appointmentEnd = dateFormat.dateFromString(query.objectForColumnName("end_date") as! String)
                let appointmentLocation = query.objectForColumnName("location") as! String
                let appointmentAdditional = query.objectForColumnName("additional") as! String
                let appointmentComplete = query.objectForColumnName("completed") as! Bool
                let appointmentCanceled = query.objectForColumnName("canceled") as! Bool
                let appointmentDeleted = query.objectForColumnName("deleted") as! Bool
                let appointmentDone = query.objectForColumnName("date_completed") as? String
                let appointmentCancelReason = query.objectForColumnName("cancel_reason") as? String
                let appointmentDeleteReason = query.objectForColumnName("delete_reason") as? String
                let appointmentUUID = query.objectForColumnName("uuid") as! String
                
                
                let appointmentItem = AppointmentItem(type: appointmentType,
                                                      startTime: appointmentStart! ,
                                                      endTime: appointmentEnd!,
                                                      title: appointmentTitle,
                                                      location: appointmentLocation,
                                                      additional: appointmentAdditional,
                                                      isComplete: appointmentComplete,
                                                      isCanceled: appointmentCanceled,
                                                      isDeleted: appointmentDeleted,
                                                      dateFinished: appointmentDone,
                                                      cancelReason: appointmentCancelReason,
                                                      deleteReason: appointmentDeleteReason,
                                                      UUID: appointmentUUID)
                
                let newAppointmentStartTime = formatter.stringFromDate(appointmentStart!)
                
                if (newAppointmentStartTime == date && !appointmentArray.contains{ $0.UUID == appointmentItem.UUID}){
                    appointmentArray.append(appointmentItem)
                }
            }
        }
        catch let err as NSError{
            print("Get Appointments By Date ERROR: \(err.localizedDescription)")
        }
        return appointmentArray
    }
    
    // Get Task By Date
    func getTaskByDate(date:String, formatter:NSDateFormatter)-> [TaskItem]{
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        var taskArray:[TaskItem] = []
        
        do{
            let fetchTaskByDateStatement = "SELECT date_created, task, additional, completed, canceled, deleted, estimated_completed_date, date_completed, cancel_reason, delete_reason, uuid FROM Tasks WHERE deleted=?"
            let task = try db.executeQuery(fetchTaskByDateStatement, values: [false])
            
            while task.next(){
                let taskMade = dateFormat.dateFromString(task.objectForColumnName("date_created") as! String)
                let taskTitle = task.objectForColumnName("task") as! String
                let taskAdditional = task.objectForColumnName("additional") as! String
                let estimatedDateCompleted = NSDateFormatter().dateWithTime.dateFromString(task.objectForColumnName("estimated_completed_date") as! String)
                let taskCompleted = task.boolForColumn("completed")
                let taskCanceled = task.boolForColumn("canceled")
                let taskDeleted = task.boolForColumn("deleted")
                let taskDone = task.objectForColumnName("date_completed") as? String
                let taskCancelReason = task.objectForColumnName("cancel_reason") as? String
                let taskDeleteReason = task.objectForColumnName("delete_reason") as? String
                let taskUUID = task.objectForColumnName("uuid") as! String
                
                let taskItem = TaskItem(dateMade: taskMade!,
                                        title: taskTitle,
                                        info: taskAdditional,
                                        estimatedCompletion: estimatedDateCompleted!,
                                        completed: taskCompleted,
                                        canceled: taskCanceled,
                                        deleted:  taskDeleted,
                                        dateFinished: taskDone,
                                        cancelReason: taskCancelReason,
                                        deleteReason: taskDeleteReason,
                                        UUID: taskUUID)
                
                let newTaskStartTime = formatter.stringFromDate(estimatedDateCompleted!)
//                print("New Task Start Time: \(newTaskStartTime) == \(date)")
                
                if (newTaskStartTime == date && !taskArray.contains{ $0.UUID == taskItem.UUID}){
//                    print("Array Date: \(date)")
//                    print("Array Contains Task item with name: \(taskItem.taskTitle)")
                    taskArray.append(taskItem)
                }
            }
        }
        catch let err as NSError{
            print("Get Task By Date ERROR: \(err.localizedDescription)")
        }
        return taskArray
    }
    
    // Get Journal By Date
    func getJournalByDate(journalDate:String, formatter: NSDateFormatter)-> [JournalItem]{
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        var journalArray:[JournalItem] = []
        
        do{
            let fetchJournalByDateStatement = "SELECT date, journal, deleted, uuid FROM Journals WHERE deleted=?"
            let journal = try db.executeQuery(fetchJournalByDateStatement, values: [false])
            
            while journal.next(){
                let date = dateFormat.dateFromString(journal.objectForColumnName("date") as! String)
                let entry = journal.objectForColumnName("journal") as! String
                let deleted = journal.boolForColumn("deleted")
                let uuid = journal.objectForColumnName("uuid") as! String
                
                let journalItem = JournalItem(journal: entry,
                                              UUID: uuid,
                                              date: date!,
                                              deleted: deleted,
                                              deleteReason: nil)
                
                let newJournalStartTime = formatter.stringFromDate(date!)
//                print("Journal Date: \(date)")
//                print("New Journal Start Time: \(newJournalStartTime)")
                
                if (newJournalStartTime == journalDate && !journalArray.contains{ $0.journalUUID == journalItem.journalUUID}){
//                    print("Array Date: \(date)")
//                    print("Array Contains Journal item with name: \(journalItem.journalEntry)")
                    journalArray.append(journalItem)
                }
            }
        }
        catch let err as NSError{
            print("Get Journal By Date ERROR: \(err.localizedDescription)")
        }
        return journalArray
    }


    
    // Get all appointments from the database and return them as an array.
    func getAllAppointments() -> [AppointmentItem] {
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }

        var appointmentArray:[AppointmentItem] = []
//        let dateFormat = NSDateFormatter().universalFormatter()
        
        do{
            let appointment:FMResultSet = try db.executeQuery("SELECT title, type, start_date, end_date, location, additional, completed, canceled, deleted, date_completed, cancel_reason, delete_reason, uuid FROM Appointments WHERE deleted=?", values: [false])
            
            while appointment.next(){
                let appointmentTitle = appointment.objectForColumnName("title") as! String
                let appointmentType = appointment.objectForColumnName("type") as! String
                let appointmentStart = dateFormat.dateFromString(appointment.objectForColumnName("start_date") as! String)
                let appointmentEnd = dateFormat.dateFromString(appointment.objectForColumnName("end_date") as! String)
                let appointmentLocation = appointment.objectForColumnName("location") as! String
                let appointmentAdditional = appointment.objectForColumnName("additional") as! String
                let appointmentComplete = appointment.objectForColumnName("completed") as! Bool
                let appointmentCanceled = appointment.objectForColumnName("canceled") as! Bool
                let appointmentDeleted = appointment.objectForColumnName("deleted") as! Bool
                let appointmentDone = appointment.objectForColumnName("date_completed") as? String
                let appointmentCancelReason = appointment.objectForColumnName("cancel_reason") as? String
                let appointmentDeleteReason = appointment.objectForColumnName("delete_reason") as? String
                let appointmentUUID = appointment.objectForColumnName("uuid") as! String

                
                let appointmentItem = AppointmentItem(type: appointmentType,
                                                      startTime: appointmentStart! ,
                                                      endTime: appointmentEnd!,
                                                      title: appointmentTitle,
                                                      location: appointmentLocation,
                                                      additional: appointmentAdditional,
                                                      isComplete: appointmentComplete,
                                                      isCanceled: appointmentCanceled,
                                                      isDeleted: appointmentDeleted,
                                                      dateFinished: appointmentDone,
                                                      cancelReason:  appointmentCancelReason,
                                                      deleteReason:  appointmentDeleteReason,
                                                      UUID: appointmentUUID)
                appointmentArray.append(appointmentItem)
                appointmentArray = appointmentArray.sort({$0.title < $1.title})

            }
        }
        catch let err as NSError{
            print("All Appointments: ERROR \(err.localizedDescription)")
        }
        return appointmentArray
    }
    
    // Get all tasks from the database and return them as an array.
    func getAllTasks() -> [TaskItem]{
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        let dateFormat = NSDateFormatter().universalFormatter
        
        var taskArray: [TaskItem] = []
        do{
            let task:FMResultSet = try db.executeQuery("SELECT date_created,task, additional, estimated_completed_date, completed, canceled, deleted, date_completed, cancel_reason, delete_reason, uuid FROM Tasks WHERE deleted=?", values: [false])
            while task.next(){
//                print("Task Item from database.")
                let taskMade = dateFormat.dateFromString(task.objectForColumnName("date_created") as! String)
                let taskTitle = task.objectForColumnName("task") as! String
                let taskAdditional = task.objectForColumnName("additional") as! String
                let estimatedDateCompleted = NSDateFormatter().dateWithTime.dateFromString(task.objectForColumnName("estimated_completed_date") as! String)
                let taskCompleted = task.boolForColumn("completed")
                let taskCanceled = task.boolForColumn("canceled")
                let taskDeleted = task.boolForColumn("deleted")
                let taskDone = task.objectForColumnName("date_completed") as? String
                let taskCancelReason = task.objectForColumnName("cancel_reason") as? String
                let taskDeleteReason = task.objectForColumnName("delete_reason") as? String
                let taskUUID = task.objectForColumnName("uuid") as! String
//                print("Task: \(taskTitle) date created: \(taskMade)")
                
                let taskItem = TaskItem(dateMade: taskMade!,
                                        title: taskTitle,
                                        info: taskAdditional,
                                        estimatedCompletion: estimatedDateCompleted!,
                                        completed: taskCompleted,
                                        canceled: taskCanceled,
                                        deleted:  taskDeleted,
                                        dateFinished: taskDone,
                                        cancelReason: taskCancelReason,
                                        deleteReason: taskDeleteReason,
                                        UUID: taskUUID)
                
                taskArray.append(taskItem)
                taskArray = taskArray.sort({$0.taskTitle < $1.taskTitle})
            }
            
        }
        catch let err as NSError{
            print("All Tasks: ERROR \(err.localizedDescription)")
        }
        return taskArray
    }
    
    // Get all journals from the database and return them as an array
    func getAllJournals() -> [JournalItem]{
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }

        var journalArray: [JournalItem] = []
        let dateFormat = NSDateFormatter().universalFormatter
        
        do{
            let journal:FMResultSet = try db.executeQuery("SELECT date, journal, deleted, uuid FROM Journals WHERE deleted=?", values: [false])
            while journal.next(){
                let date = dateFormat.dateFromString(journal.objectForColumnName("date") as! String)
                let entry = journal.objectForColumnName("journal") as! String
                let deleted = journal.boolForColumn("deleted")
                let uuid = journal.objectForColumnName("uuid") as! String
                
                let journalItem = JournalItem(journal: entry,
                                              UUID: uuid,
                                              date: date!,
                                              deleted: deleted,
                                              deleteReason: nil)

                journalArray.append(journalItem)
            }
        }
        catch let err as NSError{
            print("All Journals: ERROR \(err.localizedDescription)")
        }
        return journalArray
    }
    
    // MARK - Batch Delete Methods
    
    func removeAllAppointmentsOfSameType(item:AppointmentItem){
        let db = makeDb
        
        if !(db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        let currentDate = NSDate()
        
        do{
            let selectTask = "SELECT * FROM Appointments"
//            let canceledStatement = "UPDATE Appointments SET canceled=?, date_canceled=?, cancel_reason=? WHERE uuid=?"
//            let deletedStatement = "UPDATE Appointments SET deleted=?, date_deleted=?, delete_reason=? WHERE uuid=?"
//            let appointment = try db.executeQuery(selectTask, values: [item.canceled, currentDate, item.canceledReason!])
        }
        
    }
    
    func removeAllTasksOfSameType(item: TaskItem, option: String){
        let db = makeDb
        
        if !(db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        let date = NSDate()
        let currentDateAsString = dateFormat.stringFromDate(date)
        
        do{
            let selectTask = "SELECT completed, canceled, deleted FROM Tasks WHERE title=? AND additional=?"
            let task = try db.executeQuery(selectTask, values: [item.taskTitle, item.taskInfo])
            let canceledStatement = "UPDATE Tasks SET canceled=?, date_canceled=?, cancel_reason=? WHERE title=? AND additional=?"
            let deletedStatement = "UPDATE Tasks SET deleted=?, date_deleted=?, delete_reason=? WHERE title=? AND additional=?"
            
            while(task.next()){
                switch(option){
                    case "cancel":
                        try db.executeUpdate(canceledStatement, values: [true, currentDateAsString, item.canceledReason!, item.taskTitle, item.taskInfo])
                    
                    case "delete":
                        try db.executeUpdate(deletedStatement, values: [true, currentDateAsString, item.deletedReason!, item.taskTitle, item.taskInfo])
                    default:
                        break
                }
            }
        }
        catch let err as NSError{
            print("Remove All Tasks: Error \(err.localizedDescription)")
        }

    }
    
    // MARK - Notification Methods
    
    // Set the notification time for an appointment based on the uuid
    func setAppointmentNotification(item: AppointmentItem){
        print("Appointment Notification: \(item.startingTime)")
        
        // create a corresponding local notification
        let notification =  UILocalNotification()
        notification.alertBody = "Appointment \"\(item.title)\" Has Started"
        notification.alertAction = "open"
        notification.fireDate = item.startingTime
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["UUID": item.UUID, ]
        notification.category = "APPOINTMENT_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    // Remove an appointment notification using its unique identifier or title
    func removeAppointmentNotification(item:AppointmentItem){
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            let identifier = notification.userInfo!["UUID"] as! String
            
            if (identifier == item.UUID || identifier == item.title){
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
    
    // Set a notification for a task based on uuid
    func setTaskNotification(item: TaskItem){
        print("Task Notification: \(item.estimateCompletionDate)")
        
        // create local notification
        let notification = UILocalNotification()
        notification.alertBody = "Task \"\(item.taskTitle)\" Has Started"
        notification.alertAction = "open"
        notification.fireDate = item.estimateCompletionDate
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.userInfo = ["UUID": item.UUID]
        notification.category = "TASK_CATEGORY"
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
    }
    
    // Remove a task notification using its unique identifier or title
    func removeTaskNotification(item: TaskItem){
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications!{
            let identifier = notification.userInfo!["UUID"] as! String
            
            if (identifier == item.UUID || identifier == item.taskTitle){
                UIApplication.sharedApplication().cancelLocalNotification(notification)
            }
        }
    }
        
    // MARK - Clear Function
    
    // Only used in testing for clearing out everything in the database.
    func clearTable(tableName: String){
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }

        defer{
            db.close()
        }
        
        do{
            let clearTableStatement = "DELETE FROM " + tableName
            try db.executeUpdate(clearTableStatement, values: nil)
        }
        catch let err as NSError{
            print("ERROR CLEARING TABLE: \(err.localizedDescription)")
        }
    }
}
