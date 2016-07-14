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
    let currentDate = NSDate()
    let dateComponents = NSDateComponents()
    let calendar = NSCalendar.currentCalendar()
    let dateFormat = NSDateFormatter()

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        db.close()
        super.tearDown()
    }
    
    func testAppointments(){
        print("Appointment Current Date: \(currentDate)")
        dateComponents.day = 24
        dateComponents.year = 2016
        dateComponents.month = 6

        dateComponents.hour = 12
        dateComponents.minute = 10
        dateComponents.second = 0
        let startDate = calendar.dateFromComponents(dateComponents)
        print("Appointment Start Date: \(startDate)")
        dateComponents.day = 24
        dateComponents.year = 2016
        dateComponents.month = 6

        dateComponents.hour = 12
        dateComponents.minute = 40
        dateComponents.second = 0
        let endDate = calendar.dateFromComponents(dateComponents)
        print("Appointment End Date: \(endDate)")
        
        let appointmentOne = AppointmentItem(type: "Family", startTime: startDate!, endTime: endDate!, title: "Unit Test Appointment 1", location: "8 1/2 Canal Street", additional: "This is only a test", isComplete: false, isCanceled: false, isDeleted: false, dateFinished: nil , UUID: NSUUID().UUIDString)
        
        // Clearing any item that may be in the database first.
        databaseFunctions.clearTable("Appointments")
        
        // Try clearing database table that doesnt exist.
        databaseFunctions.clearTable("WrongAppointmentsTable")
        
        // Get the items from the appointment table there shouldn't be anything there.
        var appointmentList: [AppointmentItem] = databaseFunctions.getAllAppointments()

        XCTAssertTrue(appointmentList.count == 0, "The Appointment Table was correctly cleared.")
        
        // Adding the new appointment to the database
        databaseFunctions.addToAppointmentDatabase(appointmentOne)
        
        // Adding the new appointment a notification
        databaseFunctions.setAppointmentNotification(appointmentOne)
        
        // Since the new appointment is the only appointment in the database
        // It should be equal to the original appointment we passed in.
        appointmentList = databaseFunctions.getAllAppointments()
        
        XCTAssertTrue(appointmentList.count == 1, "Our appointment was successfully added and retrieved from the database.")
        
        for appointment in appointmentList{
            XCTAssertTrue(appointment.UUID == appointmentOne.UUID, "The UUID of the appointment passed in matches the one recieved.")
            XCTAssertTrue(appointment.isOverdue == true, "The starting time of the appointment has passed.")
            XCTAssertTrue(appointment.title == appointmentOne.title, "Appointment Titles Match.")
            XCTAssertTrue(appointment.type == appointmentOne.type, "Appointment Types Match.")
            XCTAssertTrue(appointment.additionalInfo == appointmentOne.additionalInfo, "Appointment Additional Infos Match.")
            XCTAssertTrue(appointment.appLocation == appointmentOne.appLocation, "Appointment Locations Match.")
            XCTAssertTrue(appointmentOne.startingTime == startDate!, "Appointment Start Date matches the one passed in.")
            XCTAssertTrue(appointmentOne.endingTime == endDate!, "Appointment End Date matches the one passed in.")

        }
        
        // Delete the appointment from the database.
        databaseFunctions.deleteFromDatabase("Appointments", uuid: appointmentOne.UUID)
        
        // Get the appointments from the database there should be none.
        appointmentList = databaseFunctions.getAllAppointments()
        
        // Count should be set back to zero.
        XCTAssertTrue(appointmentList.count == 0, "Appointment Database is empty again.")
    }
    
    func testCompleteAppointment(){
        dateComponents.day = 13
        dateComponents.year = 2016
        dateComponents.month = 7
        dateComponents.hour = 12
        dateComponents.minute = 10
        dateComponents.second = 0
        let startDate = calendar.dateFromComponents(dateComponents)
        //        print("Appointment Delete Start Date: \(startDate)")
        
        dateComponents.day = 13
        dateComponents.year = 2016
        dateComponents.month = 7
        dateComponents.hour = 12
        dateComponents.minute = 40
        dateComponents.second = 0
        let endDate = calendar.dateFromComponents(dateComponents)
        //        print("Appointment Delete End Date: \(endDate)")
        
        var appointmentOne = AppointmentItem(type: "Family", startTime: startDate!, endTime: endDate!, title: "Unit Test Appointment 1", location: "8 1/2 Canal Street", additional: "This is only a test", isComplete: false, isCanceled: false, isDeleted: false, dateFinished: nil , UUID: NSUUID().UUIDString)
        
        // Add the appointment to the database.
        databaseFunctions.addToAppointmentDatabase(appointmentOne)
        
        // Cancel the appointment
        appointmentOne.completed = true
        let completedDate = NSDate()
        let completedStringDate = dateFormat.stringFromDate(completedDate)
        databaseFunctions.updateAppointment(appointmentOne)
        
        let appointmentList = databaseFunctions.getAllAppointments()
        
        for appointment in appointmentList{
            XCTAssert(appointment.canceled == appointmentOne.canceled)
            let db = databaseFunctions.makeDb
            do{
                let query = try db.executeQuery("Select completed, date_completed FROM Appointments", values: nil)
                
                while query.next(){
                    let completedValue = query.objectForColumnName("completed") as! Bool
                    let dateCompleted = query.objectForColumnName("date_completed") as! String
                    
                    XCTAssert(completedValue == true, "Complete Value should be set to true")
                    XCTAssert(dateCompleted == completedStringDate, "Date Complete is correct")
                }
            }
            catch let err as NSError{
                print("Appointment Delete Error in Testing: " + err.localizedDescription)
            }
        }
        databaseFunctions.deleteFromDatabase("Appointments", uuid: appointmentOne.UUID)
    }


    func testCancelAppointment(){
        dateComponents.day = 13
        dateComponents.year = 2016
        dateComponents.month = 7
        dateComponents.hour = 12
        dateComponents.minute = 10
        dateComponents.second = 0
        let startDate = calendar.dateFromComponents(dateComponents)
//        print("Appointment Delete Start Date: \(startDate)")
        
        dateComponents.day = 13
        dateComponents.year = 2016
        dateComponents.month = 7
        dateComponents.hour = 12
        dateComponents.minute = 40
        dateComponents.second = 0
        let endDate = calendar.dateFromComponents(dateComponents)
//        print("Appointment Delete End Date: \(endDate)")
        
        var appointmentOne = AppointmentItem(type: "Family", startTime: startDate!, endTime: endDate!, title: "Unit Test Appointment 1", location: "8 1/2 Canal Street", additional: "This is only a test", isComplete: false, isCanceled: false, isDeleted: false, dateFinished: nil , UUID: NSUUID().UUIDString)
        
        // Add the appointment to the database.
        databaseFunctions.addToAppointmentDatabase(appointmentOne)
        
        // Cancel the appointment
        appointmentOne.canceled = true
        let canceledDate = NSDate()
        let canceledStringDate = dateFormat.stringFromDate(canceledDate)
        databaseFunctions.updateAppointment(appointmentOne)
        
        let appointmentList = databaseFunctions.getAllAppointments()
        
        for appointment in appointmentList{
            XCTAssert(appointment.canceled == appointmentOne.canceled)
            let db = databaseFunctions.makeDb
            do{
                let query = try db.executeQuery("Select canceled, date_canceled FROM Appointments", values: nil)
                
                while query.next(){
                    let canceledValue = query.objectForColumnName("canceled") as! Bool
                    let dateCanceled = query.objectForColumnName("date_canceled") as! String
                    
                    XCTAssert(canceledValue == true, "Canceled Value should be set to true")
                    XCTAssert(dateCanceled == canceledStringDate, "Date Canceled is correct")
                }
            }
            catch let err as NSError{
                print("Appointment Delete Error in Testing: " + err.localizedDescription)
            }
        }
        databaseFunctions.deleteFromDatabase("Appointments", uuid: appointmentOne.UUID)
    }
    
    func testDeleteAppointment(){
        dateComponents.day = 24
        dateComponents.year = 2016
        dateComponents.month = 6
        dateComponents.hour = 12
        dateComponents.minute = 10
        dateComponents.second = 0
        let startDate = calendar.dateFromComponents(dateComponents)
//        print("Appointment Delete Start Date: \(startDate)")
        
        dateComponents.day = 24
        dateComponents.year = 2016
        dateComponents.month = 6
        dateComponents.hour = 12
        dateComponents.minute = 40
        dateComponents.second = 0
        let endDate = calendar.dateFromComponents(dateComponents)
//        print("Appointment Delete End Date: \(endDate)")
        
        var appointmentOne = AppointmentItem(type: "Family", startTime: startDate!, endTime: endDate!, title: "Unit Test Appointment 1", location: "8 1/2 Canal Street", additional: "This is only a test", isComplete: false, isCanceled: false, isDeleted: false, dateFinished: nil , UUID: NSUUID().UUIDString)
        
        // Add the appointment to the database.
        databaseFunctions.addToAppointmentDatabase(appointmentOne)
        
        // Delete the item from the database
        appointmentOne.deleted = true
        let deletedDate = NSDate()
        let deletedStringDate = dateFormat.stringFromDate(deletedDate)
        databaseFunctions.updateAppointment(appointmentOne)
        
        let appointmentList = databaseFunctions.getAllAppointments()
        
        for appointment in appointmentList{
            XCTAssert(appointment.deleted == appointmentOne.deleted)
            let db = databaseFunctions.makeDb
            do{
                let query = try db.executeQuery("Select deleted, date_deleted FROM Appointments", values: nil)
                
                while query.next(){
                    let deletedValue = query.objectForColumnName("deleted") as! Bool
                    let dateDeleted = query.objectForColumnName("date_deleted") as! String
                    
                    XCTAssert(deletedValue == true, "Deleted Value should be set to true")
                    XCTAssert(dateDeleted == deletedStringDate, "Date Deleted is correct")
                    }
                }
                catch let err as NSError{
                    print("Appointment Delete Error in Testing: " + err.localizedDescription)
                }
            }
        databaseFunctions.deleteFromDatabase("Appointments", uuid: appointmentOne.UUID)
        }
    
    func testTasks(){
        print("Task Current Date: \(currentDate)")
        dateComponents.day = 24
        dateComponents.year = 2016
        dateComponents.month = 6
        dateComponents.hour = 12
        dateComponents.minute = 30
        dateComponents.second = 0
        let taskUpdatedDate = calendar.dateFromComponents(dateComponents)
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        
        // Convert the date to a string in order to put it into the task table.
        let taskUpdatedDateAsString = dateFormat.stringFromDate(taskUpdatedDate!)
        print("Changed Task Date: \(taskUpdatedDate)")
        
        let taskOne :TaskItem = TaskItem(dateMade: taskUpdatedDateAsString, title: "Unit Test Task 1", info: "This is only a test.", completed: false, dateFinished: nil, UUID: NSUUID().UUIDString)
        
        // Clear the task database if there is anything in there that could make this test fail.
        databaseFunctions.clearTable("Tasks")
        
        // Try clearing database table that doesnt exist.
        databaseFunctions.clearTable("WrongTasksTable")
        
        // Get the items in the task table there should be none.
        var taskList: [TaskItem] = databaseFunctions.getAllTasks()
        XCTAssertTrue(taskList.count == 0, "The Task Table was correctly cleared out.")
        
        // Add the new task to the database
        databaseFunctions.addToTaskDatabase(taskOne)
        
        // Get the items from the task database table
        taskList = databaseFunctions.getAllTasks()
        XCTAssertTrue(taskList.count == 1 , "The Task Table Should have the one item we added to it.")
        
        // Run through the tasks in the list.
        for tasked in taskList{
            XCTAssertTrue(tasked.taskTitle == taskOne.taskTitle, "Task Titles match.")
            XCTAssertTrue(tasked.taskInfo == taskOne.taskInfo, "Task Info matches.")
            XCTAssertTrue(tasked.dateCreated == taskUpdatedDateAsString, "Task Date Made matches the date that was passed in as a string. Do we want to keep this as a string?")
            XCTAssertTrue(tasked.completed == false, "Task has not been completed yet.")
            XCTAssertTrue(tasked.dateCompleted == nil, "Task date completed has not yet been set.")
        }
        
        // Get the current date and time and set that as the date completed.
        let taskCompletedDate = NSDate()
        dateFormat.dateFormat = "EEEE MM/dd/yyyy hh:mm:ss a"
        let taskCompletedDateAsString = dateFormat.stringFromDate(taskCompletedDate)
        print("Task Completed Date: \(taskCompletedDate)")
        print("Task Completed String \(taskCompletedDateAsString)")
        
        // Create a new task changing the completed and date finished parameters.
        let updatedTask: TaskItem = TaskItem(dateMade: taskOne.dateCreated, title: taskOne.taskTitle, info: taskOne.taskInfo, completed: true, dateFinished: taskCompletedDateAsString, UUID: taskOne.UUID)
        
        // Update the entry for that task in the database.
        databaseFunctions.updateTask(updatedTask)
        
        // Get all entries in the task table again
        taskList = databaseFunctions.getAllTasks()
        XCTAssertTrue(taskList.count == 1 , "The Task Update should not have affected the count it should still be one.")
        
        for task in taskList{
            XCTAssertTrue(task.taskTitle == updatedTask.taskTitle, "Updated task title matched the one in the database.")
            XCTAssertTrue(task.taskInfo == updatedTask.taskInfo, "Updated task info matched the one found in the database.")
            XCTAssertTrue(task.completed == true, "Updated task has been completed.")
            XCTAssertTrue(task.dateCompleted == taskCompletedDateAsString, "Updated task date completed matches.")
            XCTAssertTrue(task.dateCreated == taskOne.dateCreated, "Updated task date created matched what was found in the database.")
            XCTAssertTrue(task.UUID == updatedTask.UUID, "Updated UUID matched the one found in the database.")
        }
        
//         Delete the task item from the database
        databaseFunctions.deleteFromDatabase("Tasks", uuid: updatedTask.UUID)
        
        // Try to delete an item from a non existing table
        databaseFunctions.deleteFromDatabase("WrongTasksTable", uuid: updatedTask.UUID)

        
//         Get the tasks from the database there should be none
        taskList = databaseFunctions.getAllTasks()
        
        XCTAssertTrue(taskList.count == 0, "Task Database is empty again")
    }
    
    func testJournals(){
        print("Journal Current Date: \(currentDate)")
        dateComponents.day = 24
        dateComponents.year = 2016
        dateComponents.month = 6

        dateComponents.hour = 12
        dateComponents.minute = 40
        dateComponents.second = 0
        let journalDate = calendar.dateFromComponents(dateComponents)
        print("Journal Date: \(journalDate)")
        let journalDateAsString = dateFormat.stringFromDate(journalDate!)
        print("Journal Date As String: \(journalDateAsString)")
        
        let journalItem: JournalItem = JournalItem(journal: "This is a unit test journal item", UUID: NSUUID().UUIDString, date: journalDateAsString)
        
        // Clear anything in the journal database first.
        databaseFunctions.clearTable("Journals")
        
        // Try clearing database table that doesnt exist.
        databaseFunctions.clearTable("WrongJournalTable")
        
        var journalList: [JournalItem] = databaseFunctions.getAllJournals()
        
        // Journal List should have a count of 0
        XCTAssertTrue(journalList.count == 0, "The Journal Database was cleared out correctly.")
        
        // Add journal item to the database
        databaseFunctions.addToJournalDatabase(journalItem)
        
        // Get all items in the journal database.
        journalList = databaseFunctions.getAllJournals()
        
        // There should be 1 item in the journal table now.
        XCTAssertTrue(journalList.count == 1, "The Journal item was successfully added to the database.")
        
        for journal in journalList{
            XCTAssertTrue(journal.journalEntry == "This is a unit test journal item", "The Journal entry matches")
            XCTAssertTrue(journal.journalDate == journalDateAsString, "The journal Date Strings match")
            XCTAssertTrue(journal.journalUUID == journalItem.journalUUID, "The journal UUID's match")
            XCTAssertTrue(journalList.count == 1, "The Journal table has one item in it.")
        }
        
        // Delete the test data from the database.
        databaseFunctions.deleteFromDatabase("Journals", uuid: journalItem.journalUUID)
        
        // Try to delete an item from a non existing table
        databaseFunctions.deleteFromDatabase("WrongJournalsTable", uuid: journalItem.journalUUID)

        
        // Get the journal items from the database there should be none.
        journalList = databaseFunctions.getAllJournals()
        
        XCTAssertTrue(journalList.count == 0 , "Journal Database is empty again.")
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
            
            self.databaseFunctions.getAllAppointments()
            
            self.databaseFunctions.getAllTasks()
            
            self.databaseFunctions.getAllJournals()
            
        }
    }
}
