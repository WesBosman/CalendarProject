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
class DatabaseFunctions{
    
    func makeDb() -> FMDatabase{
        let documents = try! NSFileManager.defaultManager().URLForDirectory(.DocumentDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
        let fileURL = documents.URLByAppendingPathComponent("Database.sqlite")
        let db = FMDatabase(path: fileURL.path)
        return db
    }
    
    func addToAppointmentDatabase(type: String, start: NSDate, end:NSDate, title: String, location:String, additional:String){
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
            var lastRow:Int = 0
            try db.executeUpdate("create table if not exists Appointments(id integer primary key autoincrement, date date, title text, type text, start date, end date, location text, additional text)", values: nil)

            let rs = try db.executeQuery("select date, title, type, start, end, location, additional from Appointments", values: nil)
            print("***************************")

            var count:Int = 0
            
            while rs.next(){
                count += 1
            }
            print("Number of items in database: \(count)")
            lastRow = count + 1
            try db.executeUpdate("insert into Appointments(id, date, title, type, start, end, location, additional) values(?, ?, ?, ?, ?, ?, ?, ?)", values:[lastRow, currentDateString, title, type, startDateString, endDateString, location, additional])
            print("***************************")

            
        } catch let err as NSError{
            print("ERROR: \(err.localizedDescription)")
        }
        // Always close the database after editing it.
        db.close()

    }
}
