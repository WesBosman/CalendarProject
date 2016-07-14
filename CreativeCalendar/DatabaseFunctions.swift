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
            
            try db.executeUpdate("create table if not exists Tasks(id integer primary key autoincrement, date_created text, task text, additional text, completed bool, date_completed text, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Journals(id integer primary key autoincrement, date text, journal text, uuid text)", values: nil)
            
            // Get DatabasePath
            //NSLog("Database File Path: \(fileURL.path!)")
            
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
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
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
            print("ERROR: \(err.localizedDescription)")
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
        
        do{
            let rs = try db.executeQuery("SELECT date_created, task, additional, completed uuid FROM Tasks", values: nil)
            var count:Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Task Table database: \(count)")
            try db.executeUpdate("INSERT into Tasks(date_created, task, additional, completed, uuid) values(?, ?, ?, ?, ?)", values:[ item.dateCreated, item.taskTitle, item.taskInfo, item.completed, item.UUID])
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
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
        
        do{
            let rs = try db.executeQuery("SELECT date, journal FROM Journals", values: nil)
            var count:Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Journal Table database: \(count)")
            try db.executeUpdate("INSERT into Journals(date, journal, uuid) values(?, ?, ?)", values:[ journal.journalDate, journal.journalEntry, journal.journalUUID])
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
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
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
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
            print("ERROR updating Appointment \(err.localizedDescription)")
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
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        let currentDateString = dateFormat.stringFromDate(current)
        
        // If date completed equals false then do this...
        do{
            // Get the value of the completed column for the task with the given uuid
            let selectStatement = "SELECT completed FROM Tasks WHERE uuid=?"
            let selectResult = try db.executeQuery(selectStatement, values: [item.UUID])
            
            while selectResult.next(){
                let isComplete = item.completed
                let updateStatement = "UPDATE Tasks SET completed=?, date_completed=? WHERE uuid=?"
                print("Task Name: \(item.taskTitle) Completed: \(item.completed)")

                // If the task has not been completed then update completed to true and add completed date
                if isComplete == true{
                    print("Turn task on")
                    try db.executeUpdate(updateStatement, values: [isComplete, currentDateString, item.UUID])
                }
                    
                // If the task has already been completed then we are changing it back to incomplete.
                else if isComplete == false{
                    print("Turn task off")
                    try db.executeUpdate(updateStatement, values: [isComplete, "" ,  item.UUID])
                }
            }
        }
        catch let err as NSError{
            print("Task Update Error: \(err.localizedDescription)")
        }
    }
    
    // MARK - Getter Methods
    
    // Used for giving the user the title of the appointment when alert dialog box is delivered
    // and the user is inside of the application
    func getAppointmentByDate(date:String)-> String{
        let db = makeDb
        
        if (!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        var title = ""

        do{
            let sqlFetchStatement = "SELECT title FROM Appointments WHERE start_date=?"
            let query = try db.executeQuery(sqlFetchStatement, values: [date])
            
            while query.next(){
                let appointmentTitle = query.objectForColumnName("title")
                title = appointmentTitle as! String
            }
        }
        catch let err as NSError{
            print("Get Appointments By Date ERROR: \(err.localizedDescription)")
        }
        return title
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
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        
        do{
            let appointment:FMResultSet = try db.executeQuery("SELECT title, type, start_date, end_date, location, additional, completed, canceled, deleted, date_completed, uuid FROM Appointments WHERE deleted=?", values: [false])
            while appointment.next(){
                let appointmentTitle = appointment.objectForColumnName("title")
                let appointmentType = appointment.objectForColumnName("type")
                let appointmentStart = dateFormat.dateFromString(appointment.objectForColumnName("start_date") as! String)
                let appointmentEnd = dateFormat.dateFromString(appointment.objectForColumnName("end_date") as! String)
                let appointmentLocation = appointment.objectForColumnName("location")
                let appointmentAdditional = appointment.objectForColumnName("additional")
                let appointmentComplete = appointment.objectForColumnName("completed") as! Bool
                let appointmentCanceled = appointment.objectForColumnName("canceled") as! Bool
                let appointmentDeleted = appointment.objectForColumnName("deleted") as! Bool
                let appointmentDone = appointment.objectForColumnName("date_completed") as? String
                let appointmentUUID = appointment.objectForColumnName("uuid")
                
//                print("Appointment Title: \(appointmentTitle) type: \(appointmentType) start: \(appointmentStart) end: \(appointmentEnd) location: \(appointmentLocation) additional: \(appointmentAdditional) uuid: \(appointmentUUID)")
                
                let appointmentItem = AppointmentItem(type: appointmentType as! String,
                                                      startTime: appointmentStart! ,
                                                      endTime: appointmentEnd!,
                                                      title: appointmentTitle as! String,
                                                      location: appointmentLocation as! String,
                                                      additional: appointmentAdditional as! String,
                                                      isComplete: appointmentComplete,
                                                      isCanceled: appointmentCanceled,
                                                      isDeleted: appointmentDeleted,
                                                      dateFinished: appointmentDone,
                                                      UUID: appointmentUUID as! String)
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
        
        var taskArray: [TaskItem] = []
        do{
            let task:FMResultSet = try db.executeQuery("SELECT date_created, task, additional, completed, date_completed, uuid FROM Tasks", values: nil)
            while task.next(){
//                print("Task Item from database.")
                let taskMade = task.objectForColumnName("date_created")
                let taskTitle = task.objectForColumnName("task")
                let taskAdditional = task.objectForColumnName("additional")
                let taskCompleted = task.objectForColumnName("completed")
                let taskDone = task.objectForColumnName("date_completed")
                let taskUUID = task.objectForColumnName("uuid")
//                print("Task: \(taskTitle) additional: \(taskAdditional) completed: \(taskCompleted) uuid: \(taskUUID)")
                let taskItem = TaskItem(dateMade: taskMade as! String,
                                        title: taskTitle as! String,
                                        info: taskAdditional as! String,
                                        completed: taskCompleted as! Bool,
                                        dateFinished: taskDone as? String ,
                                        UUID: taskUUID as! String)
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
        
        do{
            let journal:FMResultSet = try db.executeQuery("SELECT date, journal, uuid FROM Journals", values: nil)
            while journal.next(){
//                print("Journal From Database: ")
                let date = journal.objectForColumnName("date")
                let entry = journal.objectForColumnName("journal")
                let uuid = journal.objectForColumnName("uuid")
                let journalItem = JournalItem(journal: entry as! String, UUID: uuid as! String, date: date as! String)
//                print(journalItem.journalDate + " " + journalItem.journalEntry + " " + journalItem.journalUUID)
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
    
    // MARK - Delete Methods
    
    // Does not delete the appointment from the database instead it hides it from the user.
    /**
    func deleteAppointmentAndNotification(tableName: String, uuid: String){
        let db = makeDb
            
        if(!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        do{
//            let deleteStatement = "DELETE FROM " + tableName + " WHERE uuid = ?"
            let deleteStatement = "UPDATE " + tableName + " SET deleted=? WHERE uuid = ?"
            try db.executeUpdate(deleteStatement, values: [true, uuid])
            
            // If the item is an appointment then delete its notification as well.
            if tableName == "Appointments"{
                removeAppointmentNotification(uuid)
            }
            
        }
        catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
    }
    */
    
    // May want to combine these two methods to DRY up the code.
    func deleteFromDatabase(tableName:String, uuid:String){
        let db = makeDb
        
        if(!db.open()){
            db.open()
        }
        
        defer{
            db.close()
        }
        
        do{
            let deleteStatement = "DELETE FROM " + tableName + " WHERE uuid = ?"
            try db.executeUpdate(deleteStatement, values: [uuid])
//            print("Delete was successful. \(db.commit())")
//            print("Delete Statement: \(deleteStatement) + \(uuid)"
        }
        catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
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
