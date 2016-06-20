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
            try db.executeUpdate("create table if not exists Appointments(id integer primary key autoincrement, date date, title text, type text, start date, end date, location text, additional text, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Tasks(id integer primary key autoincrement, date text, task text, additional text, completed bool, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Journals(id integer primary key autoincrement, date text, journal text, uuid text)", values: nil)
//            print("Database File Path: \(fileURL.path!)")
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
            let rs = try db.executeQuery("select date, title, type, start, end, location, additional from Appointments", values: nil)
            var count: Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Appointments Table database: \(count)")
            try db.executeUpdate("insert into Appointments( date, title, type, start, end, location, additional, uuid) values( ?, ?, ?, ?, ?, ?, ?, ?)", values:[currentDateString, item.title, item.type, startDateString, endDateString, item.appLocation, item.additionalInfo, item.UUID])
            // Add a notification for the item.
            setAppointmentNotification(item)
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()
    }
    
    // Add a task to the task table
    func addToTaskDatabase(item: TaskItem){
        let db = makeDb()
        let current = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        let currentDateString = dateFormat.stringFromDate(current)
        
        do{
            let rs = try db.executeQuery("select date, task, additional, completed uuid from Tasks", values: nil)
            var count:Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Task Table database: \(count)")

            try db.executeUpdate("insert into Tasks(date, task, additional, completed, uuid) values(?, ?, ?, ?, ?)", values:[ currentDateString, item.taskTitle, item.taskInfo, item.completed, item.UUID])
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()
    }
    
    // Add journal to the journal table
    func addToJournalDatabase(journal:JournalItem){
        let db = makeDb()
        
        do{
            let rs = try db.executeQuery("select date, journal from Journals", values: nil)
            var count:Int = 1
            while rs.next(){
                count += 1
                if rs.hasAnotherRow(){
                    print("Another row")
                }
            }
            print("Number of items in Journal Table database: \(count)")
            try db.executeUpdate("insert into Journals(date, journal, uuid) values(?, ?, ?)", values:[ journal.journalDate, journal.journalEntry, journal.journalUUID])
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()

    }
    
    func getAllAppointments() -> [AppointmentItem] {
        let db = makeDb()
        var appointmentArray:[AppointmentItem] = []
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"

        do{
            let appointment:FMResultSet = try db.executeQuery("select title, type, start, end, location, additional, uuid from Appointments", values: nil)
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

            }
        }
        catch let err as NSError{
            print("All Appointments: ERROR \(err.localizedDescription)")
        }
        return appointmentArray
    }
    
    func getAllTasks() -> [TaskItem]{
        let db = makeDb()
        var taskArray: [TaskItem] = []
        do{
            let task:FMResultSet = try db.executeQuery("select task, additional, completed, uuid from Tasks", values: nil)
            while task.next(){
//                print("Task Item from database.")
                let taskTitle = task.objectForColumnName("task")
                let taskAdditional = task.objectForColumnName("additional")
                let taskCompleted = task.objectForColumnName("completed")
                let taskUUID = task.objectForColumnName("uuid")
//                print("Task: \(taskTitle) additional: \(taskAdditional) completed: \(taskCompleted) uuid: \(taskUUID)")
                let taskItem = TaskItem(title: taskTitle as! String, info: taskAdditional as! String, completed: taskCompleted as! Bool, UUID: taskUUID as! String)
                taskArray.append(taskItem)
            }
            
        }
        catch let err as NSError{
            print("All Tasks: ERROR \(err.localizedDescription)")
        }
        
        return taskArray
        
    }
    
    func getAllJournals() -> [JournalItem]{
        let db = makeDb()
        var journalArray: [JournalItem] = []
        
        do{
            let journal:FMResultSet = try db.executeQuery("select date, journal, uuid from Journals", values: nil)
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
    
    func removeAppointmentNotification(item: AppointmentItem){
        for notification in UIApplication.sharedApplication().scheduledLocalNotifications! {
            // Retrieve the notification based on the unique identifier
            if notification.userInfo!["UUID"] as! String == item.UUID{
                UIApplication.sharedApplication().cancelLocalNotification(notification)
//                break
                }
            }

    }
    
    func deleteAppointmentAndNotification(tableName: String, item:AppointmentItem){
        let db = makeDb()
            
        if(!db.open()){
            db.open()
        }
        do{
            let deleteStatement = "DELETE FROM " + tableName + " WHERE uuid = ?"
            try db.executeUpdate(deleteStatement, values: [item.UUID])
            print("Appointment Delete was successful. \(db.commit())")
            print("Appointment Delete Statement: \(deleteStatement) + \(item.UUID)")
            removeAppointmentNotification(item)
                
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
            let deleteStatement = "DELETE FROM " + tableName + " WHERE uuid = ?"
            try db.executeUpdate(deleteStatement, values: [uuid])
            print("Delete was successful. \(db.commit())")
            print("Delete Statement: \(deleteStatement) + \(uuid)")
            
        }
        catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        db.close()
    }
}
