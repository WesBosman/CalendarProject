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
            try db.executeUpdate("create table if not exists Appointments(id integer primary key autoincrement, date_created text, title text, type text, start_date text, end_date text, location text, additional text, completed bool, canceled bool, deleted bool, date_completed text, date_canceled text, date_deleted, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Tasks(id integer primary key autoincrement, date_created text, task text, additional text, completed bool, canceled bool, deleted bool, estimated_completed_date text, date_completed text, date_canceled text, date_deleted text, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Journals(id integer primary key autoincrement, date text, journal text, deleted bool, date_deleted, uuid text)", values: nil)
            
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
        
        do{
            let rs = try db.executeQuery("SELECT date_created, task, additional, completed, canceled, deleted, estimated_completed_date, uuid FROM Tasks", values: nil)
            var count:Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Task Table database: \(count)")
            try db.executeUpdate("INSERT into Tasks(date_created, task, additional, completed, canceled, deleted, estimated_completed_date, uuid) values(?, ?, ?, ?, ?, ?, ?, ?)", values:[ dateCreatedAsString, item.taskTitle, item.taskInfo, item.completed, item.canceled, item.deleted, item.estimateCompletionDate, item.UUID])
            
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
    
    // Update the appointment item when it gets completed.
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
                let updateCancelStatement = "UPDATE Appointments SET canceled=?, date_canceled=? WHERE uuid=?"
                let updateDeleteStatement = "UPDATE Appointments SET deleted=?, date_deleted=? WHERE uuid=?"
//                print("Appointment Name \(item.title) completed: \(item.completed)")
                
                // Appointment Completed
                if isComplete == true{
                    print("Appointment Completed")
                    try db.executeUpdate(updateCompleteStatement, values: [isComplete, currentDateString, item.UUID])
                }
                // If the appointment was already completed turn it off
                else{
                    print("Appointment Incomplete")
                    try db.executeUpdate(updateCompleteStatement, values: [isComplete, "" ,  item.UUID])
                }
                
                // Appointment Canceled
                if isCanceled == true{
                    print("Appointment Canceled")
                    try db.executeUpdate(updateCancelStatement, values: [true, currentDateString, item.UUID])
                }
                else{
                    print("Appointment no longer Canceled")
                    try db.executeUpdate(updateCancelStatement, values: [false, "", item.UUID])
                }
                
                // Appointment Deleted
                if isDeleted == true{
                    print("Appointment Deleted")
                    try db.executeUpdate(updateDeleteStatement, values: [true, currentDateString, item.UUID])
                    removeAppointmentNotification(item.UUID)
                }
                else{
                    print("Appointment no longer Deleted")
                    try db.executeUpdate(updateDeleteStatement, values: [false, "", item.UUID])
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
            let selectStatement = "SELECT completed FROM Tasks WHERE uuid=?"
            let selectResult = try db.executeQuery(selectStatement, values: [item.UUID])
            
            while selectResult.next(){
                let isComplete = item.completed
                let isCanceled = item.canceled
                let isDeleted = item.deleted
                
                let completedStatement = "UPDATE Tasks SET completed=?, date_completed=? WHERE uuid=?"
                let canceledStatement = "UPDATE Tasks SET canceled=?, date_canceled=? WHERE uuid=?"
                let deletedStatement = "UPDATE Tasks SET deleted=?, date_deleted=? WHERE uuid=?"
                print("Task Name: \(item.taskTitle) Completed: \(item.completed)")

                // Complete the Task
                if isComplete == true{
                    print("Task Completed")
                    try db.executeUpdate(completedStatement, values: [isComplete, currentDateString, item.UUID])
                }
                else{
                    print("Task Not Completed")
                    try db.executeUpdate(completedStatement, values: [isComplete, "" ,  item.UUID])
                }
                
                // Cancel the Task
                if isCanceled == true{
                    print("Task Canceled")
                    try db.executeUpdate(canceledStatement, values: [isCanceled, currentDateString , item.UUID])
                }
                else{
                    print("Task Not Canceled")
                    try db.executeUpdate(canceledStatement, values: [isCanceled, "", item.UUID])
                }
                
                // Delete the Task
                if isDeleted == true{
                    print("Task Deleted")
                    try db.executeUpdate(deletedStatement, values: [isDeleted, currentDateString, item.UUID])
                }
                else{
                    print("Task Not Deleted")
                    try db.executeUpdate(deletedStatement, values: [isDeleted, "", item.UUID])
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
        //        let dateFormat = NSDateFormatter().universalFormatter()
        let currentDateString = dateFormat.stringFromDate(current)
        
        // If date completed equals false then do this...
        do{
            // Get the value of the completed column for the task with the given uuid
            let selectStatement = "SELECT deleted FROM Journals WHERE uuid=?"
            let selectResult = try db.executeQuery(selectStatement, values: [item.journalUUID])
            
            while selectResult.next(){
                let isDeleted = item.journalDeleted
                let deletedStatement = "UPDATE Journals SET deleted=?, date_deleted=? WHERE uuid=?"
                
                // Delete the Journal
                if isDeleted == true{
                    print("Journal Deleted")
                    try db.executeUpdate(deletedStatement, values: [isDeleted, currentDateString, item.journalUUID])
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
    func getAppointmentByDate(date:String)-> [AppointmentItem]{
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
//        var title = ""
        var appointmentArray: [AppointmentItem] = []

        do{
            let fetchAppointmentByDateStatement = "SELECT title, type, start_date, end_date, location, additional, completed, canceled, deleted, date_completed, uuid FROM Appointments WHERE deleted=?"
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
                                                      UUID: appointmentUUID)
                
                let newDateFormatter = NSDateFormatter().dateWithoutTime
                let newAppointmentStartTime = newDateFormatter.stringFromDate(appointmentStart!)
                
                if (newAppointmentStartTime == date && !appointmentArray.contains{ $0.UUID == appointmentItem.UUID}){
                    print("Array Date: \(date)")
                    print("Array Contains appointment item with name: \(appointmentItem.title)")
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
    func getTaskByDate(date:String)-> [TaskItem]{
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        var taskArray:[TaskItem] = []
        
        do{
            let fetchTaskByDateStatement = "SELECT * FROM Tasks WHERE estimated_completed_date=? AND deleted=?"
            let task = try db.executeQuery(fetchTaskByDateStatement, values: [date, false])
            
            while task.next(){
                let taskMade = dateFormat.dateFromString(task.objectForColumnName("date_created") as! String)
                let taskTitle = task.objectForColumnName("task") as! String
                let taskAdditional = task.objectForColumnName("additional") as! String
                let estimatedDateCompleted = task.objectForColumnName("estimated_completed_date") as! String
                let taskCompleted = task.boolForColumn("completed")
                let taskCanceled = task.boolForColumn("canceled")
                let taskDeleted = task.boolForColumn("deleted")
                let taskDone = task.objectForColumnName("date_completed") as! String
                let taskUUID = task.objectForColumnName("uuid") as! String
                
                let taskItem = TaskItem(dateMade: taskMade!,
                                        title: taskTitle,
                                        info: taskAdditional,
                                        estimatedCompletion: estimatedDateCompleted,
                                        completed: taskCompleted,
                                        canceled: taskCanceled,
                                        deleted:  taskDeleted,
                                        dateFinished: taskDone,
                                        UUID: taskUUID)
                
                let newTaskStartTime = estimatedDateCompleted
                
                if (newTaskStartTime == date && !taskArray.contains{ $0.UUID == taskItem.UUID}){
                    print("Array Date: \(date)")
                    print("Array Contains Task item with name: \(taskItem.taskTitle)")
                    taskArray.append(taskItem)
                }
                
//                print("Task Item from Db: \(taskItem)")
            }
        }
        catch let err as NSError{
            print("Get Task By Date ERROR: \(err.localizedDescription)")
        }
        return taskArray
    }
    
    // Get Journal By Date
    func getJournalByDate(journalDate:String)-> [JournalItem]{
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
                                              deleted: deleted)
                
                let newDateFormatter = NSDateFormatter().dateWithoutTime
                let newJournalStartTime = newDateFormatter.stringFromDate(date!)
                print("Journal Date: \(date)")
                print("New Journal Start Time: \(newJournalStartTime)")
                
                if (newJournalStartTime == journalDate && !journalArray.contains{ $0.journalUUID == journalItem.journalUUID}){
                    print("Array Date: \(date)")
                    print("Array Contains Journal item with name: \(journalItem.journalEntry)")
                    journalArray.append(journalItem)
                }

//                journalArray.append(journalItem)
//                print("JournalItem from Db: \(journalItem)")
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
            let appointment:FMResultSet = try db.executeQuery("SELECT title, type, start_date, end_date, location, additional, completed, canceled, deleted, date_completed, uuid FROM Appointments WHERE deleted=?", values: [false])
            
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
                let appointmentUUID = appointment.objectForColumnName("uuid") as! String
                
//                print("Appointment Title: \(appointmentTitle) type: \(appointmentType) start: \(appointmentStart) end: \(appointmentEnd) location: \(appointmentLocation) additional: \(appointmentAdditional) uuid: \(appointmentUUID)")
                
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
            let task:FMResultSet = try db.executeQuery("SELECT date_created,task, additional, estimated_completed_date, completed, canceled, deleted, date_completed, uuid FROM Tasks WHERE deleted=?", values: [false])
            while task.next(){
//                print("Task Item from database.")
                let taskMade = dateFormat.dateFromString(task.objectForColumnName("date_created") as! String)
                let taskTitle = task.objectForColumnName("task") as! String
                let taskAdditional = task.objectForColumnName("additional") as! String
                let estimatedDateCompleted = task.objectForColumnName("estimated_completed_date") as! String
                let taskCompleted = task.boolForColumn("completed")
                let taskCanceled = task.boolForColumn("canceled")
                let taskDeleted = task.boolForColumn("deleted")
                let taskDone = task.objectForColumnName("date_completed") as? String
                let taskUUID = task.objectForColumnName("uuid") as! String
//                print("Task: \(taskTitle) date created: \(taskMade)")
                
                let taskItem = TaskItem(dateMade: taskMade!,
                                        title: taskTitle,
                                        info: taskAdditional,
                                        estimatedCompletion: estimatedDateCompleted,
                                        completed: taskCompleted,
                                        canceled: taskCanceled,
                                        deleted:  taskDeleted,
                                        dateFinished: taskDone,
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
                                              deleted: deleted)

                journalArray.append(journalItem)
            }
        }
        catch let err as NSError{
            print("All Journals: ERROR \(err.localizedDescription)")
        }
        return journalArray
    }
    
    // MARK - Notification Methods
    
    // Set the notification time for an appointment based on the starting time
    func setAppointmentNotification(item: AppointmentItem){
        print("Appointment starting time Notification!!!: \(item.startingTime)")
        
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
    
    // Remove an appointment notification using its unique identifier
    func removeAppointmentNotification(uuid: String){
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            // Retrieve the notification based on the unique identifier
            if notification.userInfo!["UUID"] as! String == uuid{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
//                break
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
