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
    
    // Make the database and store it in the documents section
    func makeDb() -> FMDatabase{
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Database.sqlite")
        let db = FMDatabase(path: fileURL.path)
        // If the database is not open for editing then make it editable
        if(!db.open()){
            db.open()
        }
        // Create the three tables for storing our information.
        do{
            db.beginTransaction()
            try db.executeUpdate("create table if not exists Appointments(id integer primary key autoincrement, date date, title text, type text, start date, end date, location text, additional text, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Tasks(id integer primary key autoincrement, date_created text, task text, additional text, completed bool, date_finished text, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Journals(id integer primary key autoincrement, date text, journal text, uuid text)", values: nil)
//            print("Database File Path: \(fileURL.path!)")
            db.commit()
        }
        catch let err as NSError{
            print("Creating Database Error: \(err.localizedDescription)")
        }
        return db
    }
    
    // Add an item to the appointment table
    func addToAppointmentDatabase(item: AppointmentItem){
        let db = makeDb()
        let current = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        let currentDateString = dateFormat.stringFromDate(current)
        let startDateString = dateFormat.stringFromDate(item.startingTime)
        let endDateString = dateFormat.stringFromDate(item.endingTime)
        
        do{
            db.beginTransaction()
            let rs = try db.executeQuery("SELECT date, title, type, start, end, location, additional FROM Appointments", values: nil)
            var count: Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Appointments Table database: \(count)")
            try db.executeUpdate("INSERT into Appointments( date, title, type, start, end, location, additional, uuid) values( ?, ?, ?, ?, ?, ?, ?, ?)", values:[currentDateString, item.title, item.type, startDateString, endDateString, item.appLocation, item.additionalInfo, item.UUID])
            // Add a notification for the item.
            setAppointmentNotification(item)
            db.commit()
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()
    }
    
    // Add a task to the task table
    func addToTaskDatabase(item: TaskItem){
        let db = makeDb()
        
        do{
            db.beginTransaction()
            let rs = try db.executeQuery("SELECT date_created, task, additional, completed uuid FROM Tasks", values: nil)
            var count:Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Task Table database: \(count)")
            
            try db.executeUpdate("INSERT into Tasks(date_created, task, additional, completed, uuid) values(?, ?, ?, ?, ?)", values:[ item.dateCreated, item.taskTitle, item.taskInfo, item.completed, item.UUID])
            db.commit()
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()
    }
    
// Update the task item to be able to change the image associated with the task
    func updateTask(item: TaskItem){
        let db = makeDb()
        let current = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        let currentDateString = dateFormat.stringFromDate(current)
        
        // If date completed equals false then do this...
        do{
            db.beginTransaction()
            let updateStatement = "UPDATE OR REPLACE Tasks SET completed = \(true), SET date_finished = \(currentDateString)  WHERE uuid = \(item.UUID)"
            print()
            print("UPDATE STATEMENT: \(updateStatement)")
            print()
            try db.executeUpdate("UPDATE OR REPLACE Tasks SET completed = \(true), SET date_finished = \(currentDateString)  WHERE uuid = \(item.UUID)",  values: nil )
            db.commit()
        }
        catch let err as NSError{
            if let descript = err.localizedFailureReason{
                print("Task Update Failure Reason: \(descript)")
            }
            print("Task Update Error: \(err.localizedDescription)")
        }
        db.close()
    }
    
    // Add journal to the journal table
    func addToJournalDatabase(journal:JournalItem){
        let db = makeDb()
        
        do{
            let rs = try db.executeQuery("SELECT date, journal FROM Journals", values: nil)
            var count:Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Journal Table database: \(count)")
            db.beginTransaction()
            try db.executeUpdate("INSERT into Journals(date, journal, uuid) values(?, ?, ?)", values:[ journal.journalDate, journal.journalEntry, journal.journalUUID])
            db.commit()
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()

    }
    
    // Get all appointments from the database and return them as an array.
    func getAllAppointments() -> [AppointmentItem] {
        let db = makeDb()
        var appointmentArray:[AppointmentItem] = []
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"

        do{
            db.beginTransaction()
            let appointment:FMResultSet = try db.executeQuery("SELECT title, type, start, end, location, additional, uuid FROM Appointments", values: nil)
            while appointment.next(){
                let appointmentTitle = appointment.objectForColumnName("title")
                let appointmentType = appointment.objectForColumnName("type")
                let appointmentStart = dateFormat.dateFromString(appointment.objectForColumnName("start") as! String)
                let appointmentEnd = dateFormat.dateFromString(appointment.objectForColumnName("end") as! String)
                let appointmentLocation = appointment.objectForColumnName("location")
                let appointmentAdditional = appointment.objectForColumnName("additional")
                let appointmentUUID = appointment.objectForColumnName("uuid")
//                print("Appointment Title: \(appointmentTitle) type: \(appointmentType) start: \(appointmentStart) end: \(appointmentEnd) location: \(appointmentLocation) additional: \(appointmentAdditional) uuid: \(appointmentUUID)")
                let appointmentItem = AppointmentItem(type: appointmentType as! String,
                                                      startTime: appointmentStart! ,
                                                      endTime: appointmentEnd!,
                                                      title: appointmentTitle as! String,
                                                      location: appointmentLocation as! String,
                                                      additional: appointmentAdditional as! String,
                                                      UUID: appointmentUUID as! String)
                appointmentArray.append(appointmentItem)
                db.commit()

            }
        }
        catch let err as NSError{
            print("All Appointments: ERROR \(err.localizedDescription)")
        }
        return appointmentArray
    }
    
    // Get all tasks from the database and return them as an array.
    func getAllTasks() -> [TaskItem]{
        let db = makeDb()
        var taskArray: [TaskItem] = []
        do{
            db.beginTransaction()
            let task:FMResultSet = try db.executeQuery("SELECT date_created, task, additional, completed, date_finished, uuid FROM Tasks", values: nil)
            while task.next(){
//                print("Task Item from database.")
                let taskMade = task.objectForColumnName("date_created")
                let taskTitle = task.objectForColumnName("task")
                let taskAdditional = task.objectForColumnName("additional")
                let taskCompleted = task.objectForColumnName("completed")
                let taskDone = task.objectForColumnName("date_finished")
                let taskUUID = task.objectForColumnName("uuid")
//                print("Task: \(taskTitle) additional: \(taskAdditional) completed: \(taskCompleted) uuid: \(taskUUID)")
                let taskItem = TaskItem(dateMade: taskMade as! String, title: taskTitle as! String, info: taskAdditional as! String, completed: taskCompleted as! Bool, dateFinished: taskDone as? String ,UUID: taskUUID as! String)
                taskArray.append(taskItem)
                db.commit()
            }
            
        }
        catch let err as NSError{
            print("All Tasks: ERROR \(err.localizedDescription)")
        }
        
        return taskArray
        
    }
    
    // Get all journals from the database and return them as an array
    func getAllJournals() -> [JournalItem]{
        let db = makeDb()
        var journalArray: [JournalItem] = []
        
        do{
            db.beginTransaction()
            let journal:FMResultSet = try db.executeQuery("SELECT date, journal, uuid FROM Journals", values: nil)
            while journal.next(){
//                print("Journal From Database: ")
                let date = journal.objectForColumnName("date")
                let entry = journal.objectForColumnName("journal")
                let uuid = journal.objectForColumnName("uuid")
                let journalItem = JournalItem(journal: entry as! String, UUID: uuid as! String, date: date as! String)
//                print(journalItem.journalDate + " " + journalItem.journalEntry + " " + journalItem.journalUUID)
                journalArray.append(journalItem)
                db.commit()
            }
        }
        catch let err as NSError{
            print("All Journals: ERROR \(err.localizedDescription)")
        }
        return journalArray
        
    }
    
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
    func removeAppointmentNotification(item: AppointmentItem){
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            // Retrieve the notification based on the unique identifier
            if notification.userInfo!["UUID"] as! String == item.UUID{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
//                break
                }
            }

    }
    
    // Delete an appointment and delete its corresponding notification
    func deleteAppointmentAndNotification(tableName: String, item:AppointmentItem){
        let db = makeDb()
            
        if(!db.open()){
            db.open()
        }
        do{
            db.beginTransaction()
            let deleteStatement = "DELETE FROM " + tableName + " WHERE uuid = ?"
            try db.executeUpdate(deleteStatement, values: [item.UUID])
//            print("Appointment Delete was successful. \(db.commit())")
//            print("Appointment Delete Statement: \(deleteStatement) + \(item.UUID)")
            removeAppointmentNotification(item)
            db.commit()
                
        }
        catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        db.close()
    }
    
    // Need a function to allow items to be deleted from the database. 
    func deleteFromDatabase(tableName:String, uuid:String){
        let db = makeDb()
        
        if(!db.open()){
            db.open()
        }
        do{
            db.beginTransaction()
            let deleteStatement = "DELETE FROM " + tableName + " WHERE uuid = ?"
            try db.executeUpdate(deleteStatement, values: [uuid])
//            print("Delete was successful. \(db.commit())")
//            print("Delete Statement: \(deleteStatement) + \(uuid)"
            db.commit()
        }
        catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        db.close()
    }
}
