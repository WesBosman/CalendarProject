//
//  DatabaseFunctions.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/18/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//
//  MARK - FMDB

import Foundation

// This class will be used to communicate with the sqlite database on the device.
private let database = DatabaseFunctions()

class DatabaseFunctions{
    static let sharedInstance = database
    
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
            
            try db.executeUpdate("create table if not exists Tasks(id integer primary key autoincrement, date text, task text, additional text, uuid text)", values: nil)
            
            try db.executeUpdate("create table if not exists Journals(id integer primary key autoincrement, date text, journal text, uuid text)", values: nil)
        }
        catch let err as NSError{
            print("Creating Database Error: \(err.localizedDescription)")
        }
        return db
    }
    
    // Add an item to the appointment table
    func addToAppointmentDatabase(type: String, start: NSDate, end:NSDate, title: String, location:String, additional:String, uuid:String){
        let db = makeDb()
        let current = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss"
        let currentDateString = dateFormat.stringFromDate(current)
        let startDateString = dateFormat.stringFromDate(start)
        let endDateString = dateFormat.stringFromDate(end)
        
        if(!db.open()){
            print("Sorry but we were unable to open the database.")
            return
        }
        
        do{
            let rs = try db.executeQuery("select date, title, type, start, end, location, additional from Appointments", values: nil)
            print("AAAAAAAAAAAAAAAAAAAAAAAAAAA")
            var count: Int = 1
            while rs.next(){
                count += 1
            }
            print("Number of items in Appointments Table database: \(count)")
            try db.executeUpdate("insert into Appointments( date, title, type, start, end, location, additional, uuid) values( ?, ?, ?, ?, ?, ?, ?, ?)", values:[currentDateString, title, type, startDateString, endDateString, location, additional, uuid])
            print("AAAAAAAAAAAAAAAAAAAAAAAAAAA")

            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()
    }
    
    // Add a task to the task table
    func addToTaskDatabase(taskTitle: String, taskAdditional:String, uuid:String){
        let db = makeDb()
        let current = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss"
        let currentDateString = dateFormat.stringFromDate(current)
        
        if(!db.open()){
            print("Sorry but we were unable to open the database.")
            return
        }
        
        do{
            let rs = try db.executeQuery("select date, task, additional, uuid from Tasks", values: nil)
            print("TTTTTTTTTTTTTTTTTTTTTTTTTTTT")
            
            var count:Int = 1
            
            while rs.next(){
                count += 1
            }
            print("Number of items in Task Table database: \(count)")

            try db.executeUpdate("insert into Tasks(date, task, additional, uuid) values(?, ?, ?, ?)", values:[ currentDateString, taskTitle, taskAdditional, uuid])
            print("TTTTTTTTTTTTTTTTTTTTTTTTTTTT")
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()
    }
    
    // Add journal to the journal table
    func addToJournalDatabase(journal:String, uuid:String){
        let db = makeDb()
        let current = NSDate()
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss"
        let currentDateString = dateFormat.stringFromDate(current)
        
        if(!db.open()){
            print("Sorry but we were unable to open the database.")
            return
        }
        
        do{
            let rs = try db.executeQuery("select date, journal from Journals", values: nil)
            print("JJJJJJJJJJJJJJJJJJJJJJJJJJJ")
            
            var count:Int = 1
            while rs.next(){
                count += 1
                if rs.hasAnotherRow(){
                    print("Another row")
                }
            }
            print("Number of items in Journal Table database: \(count)")
            try db.executeUpdate("insert into Journals(date, journal, uuid) values(?, ?, ?)", values:[ currentDateString, journal, uuid])
            print("JJJJJJJJJJJJJJJJJJJJJJJJJJJJ")
            
            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()

    }
    
    // Need a function to allow items to be deleted from the database. 
    func deleteFromDatabase(tableName:String, uuid:String ){
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
