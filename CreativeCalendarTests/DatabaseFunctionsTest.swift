//
//  DatabaseFunctionsTest.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 6/24/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//


import XCTest

@testable import CreativeCalendar

class DatabaseFunctionsTest: XCTestCase {
    let databaseFunctions = DatabaseFunctions.sharedInstance
    let db = DatabaseFunctions.sharedInstance.makeDb
    let currentDate = Date()
    var dateComponents = DateComponents()
    let calendar = Calendar.current
    let dateFormat = DateFormatter()
    var startDate = Date()
    var endDate = Date()
    var appointmentOne: AppointmentItem? = nil
    var taskOne: TaskItem? = nil
    var journalOne: JournalItem? = nil

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        dateComponents.day = 24
        dateComponents.year = 2016
        dateComponents.month = 8
        dateComponents.hour = 12
        dateComponents.minute = 10
        dateComponents.second = 0
        startDate = calendar.date(from: dateComponents)!
        
        dateComponents.day = 24
        dateComponents.year = 2016
        dateComponents.month = 8
        dateComponents.hour = 12
        dateComponents.minute = 40
        dateComponents.second = 0
        endDate = calendar.date(from: dateComponents)!
        
        appointmentOne = AppointmentItem(type:      "Family",
                                             startTime: startDate,
                                             endTime:   endDate,
                                             title:     "Unit Test Appointment 1",
                                             location:  "8 1/2 Canal Street",
                                             additional:"This is only a test",
                                             repeatTime: "Never",
                                             alertTime:     "At Time Of Event",
                                             isComplete: false,
                                             isCanceled: false,
                                             isDeleted:  false,
                                             dateFinished:  nil,
                                             cancelReason: nil,
                                             deleteReason:  nil ,
                                             UUID: NSUUID().uuidString)
        
        taskOne = TaskItem(title: "Unit Test Appointment",
                           info:  "Unit Test Additional Info",
                           estimatedCompletion: startDate,
                           repeatTime: "Never",
                           alertTime:  "At Time of Event",
                           isComplete: false,
                           isCanceled: false,
                           isDeleted:  false,
                           dateFinished: nil,
                           cancelReason: nil,
                           deleteReason: nil,
                           UUID: UUID().uuidString)
        
        journalOne = JournalItem(date: startDate,
                                 journal: "Unit Test of a Journal for DB",
                                 deleted: false,
                                 deleteReason: nil,
                                 UUID: UUID().uuidString)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        db.close()
        super.tearDown()
    }
    
    // A function to test clearing the database
    func testClearDB(){
        databaseFunctions.clearTable("Appointments")
        databaseFunctions.clearTable("Tasks")
        databaseFunctions.clearTable("Journals")
        // Try to clear a table that does not exist
        databaseFunctions.clearTable("Underwear")
    }
    
    // MARK - Adding Methods
    
    // Test adding an appointment to the database table
    func testAddingAnAppointmentToDB(){
        // Unwrap optional and add it to the database
        if let appointmentOne = appointmentOne{
            databaseFunctions.addToAppointmentDatabase(appointmentOne)
            do{
                let result = try db.executeQuery("Select * from Appointments where uuid=?", values: [appointmentOne.UUID])
                while result.hasAnotherRow(){
                    let uuid = result.string(forColumn: "uuid")
                    XCTAssert(uuid == appointmentOne.UUID)
                }
            }
            catch let err as NSError{
                print("Error \(err.localizedDescription)")
            }
        }
    }
    
    // Test adding to the task database table
    func testAddingATaskToDB(){
        if let taskOne = taskOne{
            databaseFunctions.addToTaskDatabase(taskOne)
            
            do{
                let result = try db.executeQuery("Select * from Tasks where uuid=?", values: [taskOne.UUID])
                while result.hasAnotherRow(){
                    let uuid = result.string(forColumn: "uuid")
                    XCTAssert(uuid == taskOne.UUID)
                }
            }
            catch let err as NSError{
                print("Error \(err.localizedDescription)")
            }
        }
        
    }
    
    // Test adding to the journal database table
    func testAddingAJournalToDB(){
        if let journalOne = journalOne{
            databaseFunctions.addToJournalDatabase(journalOne)
            
            do{
                let result = try db.executeQuery("Select * from Journals where uuid=?", values: [journalOne.journalUUID])
                while result.hasAnotherRow(){
                    let uuid = result.string(forColumn: "uuid")
                    XCTAssert(uuid == journalOne.journalUUID)
                }
            }
            catch let err as NSError{
                print("Error \(err.localizedDescription)")
            }
        }
    }
    
    // MARK - Update Methods
    
    // Update an appointments title and additional info
    func testUpdatingAnAppointmentInDB(){
        // Clear the Appointments Table first
        databaseFunctions.clearTable("Appointments")
        
        // Then add a appointment one
        if var appointmentOne = appointmentOne{
            databaseFunctions.addToAppointmentDatabase(appointmentOne)
            
            // Update appointment one
            let newTitle = "Updated Appointment One Title"
            let newInfo  = "Updated Appointment One Info"
            appointmentOne.title = newTitle
            appointmentOne.additionalInfo = newInfo
            databaseFunctions.updateAppointment(appointmentOne)
            
            do{
                let result = try db.executeQuery("Select * from Appointments where title=?, additional=?", values: [newTitle, newInfo])
                while(result.hasAnotherRow()){
                    let title = result.string(forColumn: "title")
                    let info  = result.string(forColumn: "additional")
                    XCTAssert(title == newTitle)
                    XCTAssert(info  == newInfo)
                }
            }
            catch let err as NSError{
                print("Error \(err.localizedDescription)")
            }
        }
    }
    
    // Test updating a tasks info and title
    func testUpdatingATaskInDB(){
        // Clear the Tasks Table first
        databaseFunctions.clearTable("Tasks")
        
        // Then add a task one
        if var taskOne = taskOne{
            databaseFunctions.addToTaskDatabase(taskOne)
            
            // Update task one
            let newTitle = "Updated Task One Title"
            let newInfo  = "Updated Task One Info"
            taskOne.taskTitle = newTitle
            taskOne.taskInfo  = newInfo
            databaseFunctions.updateTask(taskOne)
            
            do{
                let result = try db.executeQuery("Select * from Tasks where title=?, additional=?", values: [newTitle, newInfo])
                while(result.hasAnotherRow()){
                    let title = result.string(forColumn: "title")
                    let info  = result.string(forColumn: "additional")
                    XCTAssert(title == newTitle)
                    XCTAssert(info  == newInfo)
                }
            }
            catch let err as NSError{
                print("Error \(err.localizedDescription)")
            }
        }
    }
    
    // Test updating a journal entry
    func testUpdatingAJournalInDB(){
        // Clear the Journals Table first
        databaseFunctions.clearTable("Journals")
        
        // Then add a journal one
        if var journalOne = journalOne{
            databaseFunctions.addToJournalDatabase(journalOne)
            
            // Update journal one
            let newEntry = "Updated Journal One Entry"
            journalOne.journalEntry = newEntry
            databaseFunctions.updateJournal(journalOne, option: "edit")
            
            do{
                let result = try db.executeQuery("Select * from Journals where journal=?", values: [newEntry])
                
                while(result.hasAnotherRow()){
                    let title = result.string(forColumn: "journal")
                    XCTAssert(title == newEntry)
                }
            }
            catch let err as NSError{
                print("Error \(err.localizedDescription)")
            }
        }
    }
    
    // MARK - Get Functions
    // Test getting an appointment by date
    func testGetAppointmentByDate(){
        // First clear the table
        databaseFunctions.clearTable("Appointments")
        
        // Add appointment one
        if let appointmentOne = appointmentOne{
            databaseFunctions.addToAppointmentDatabase(appointmentOne)
            
            let dateForAppointment = appointmentOne.startingTime
            let stringDate = dateFormat.dateWithTime.string(from:dateForAppointment)
            let app = databaseFunctions.getAppointmentByDate(stringDate, formatter: dateFormat.dateWithTime)
            
            XCTAssert(app[0].title == appointmentOne.title)
            XCTAssert(app[0].UUID == appointmentOne.UUID)
        }
    }
    
    // Test getting a task by date
    func testGetTaskByDate(){
        databaseFunctions.clearTable("Tasks")
        
        if let taskOne = taskOne{
            databaseFunctions.addToTaskDatabase(taskOne)
            
            let dateForTask = taskOne.estimateCompletionDate
            let stringDate = dateFormat.dateWithTime.string(from: dateForTask)
            let task = databaseFunctions.getTaskByDate(stringDate, formatter: dateFormat.dateWithTime)
            
            XCTAssert(task[0].taskTitle == taskOne.taskTitle)
            XCTAssert(task[0].UUID == taskOne.UUID)
        }
    }
    
    // Test getting a journal by date
    func testGetJournalByDate(){
        databaseFunctions.clearTable("Journals")
        
        if let journalOne = journalOne{
            databaseFunctions.addToJournalDatabase(journalOne)
            
            let dateForJournal = journalOne.journalDate
            let stringDate = dateFormat.dateWithoutTime.string(from:dateForJournal)
            let journal = databaseFunctions.getJournalByDate(stringDate, formatter: dateFormat.dateWithoutTime)
            
            XCTAssert(journal[0].journalEntry == journalOne.journalEntry)
            XCTAssert(journal[0].journalUUID  == journalOne.journalUUID)
        }
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
//            self.databaseFunctions.getAllAppointments()
//            
//            self.databaseFunctions.getAllTasks()
//            
//            self.databaseFunctions.getAllJournals()
            
        }
    }
}
