//
//  TaskModelTest.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 12/24/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import XCTest

@testable import CreativeCalendar

class TaskModelTest: XCTestCase {
    var taskOverdue: TaskItem? = nil
    var taskNotOverdue: TaskItem? = nil
    var dateComp = DateComponents()
    let date = Date()
    let calendar = Calendar.current
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Previous day
        dateComp.day = -1
        let overdueDate = calendar.date(byAdding: dateComp, to: date)!
        
        // Day after tomorrow
        dateComp.day = 2
        let notOverdueDate = calendar.date(byAdding: dateComp, to: date)!
            
        taskOverdue = TaskItem(title: "Unit Test Task Overdue",
                           info: "Is this overdue?",
                           estimatedCompletion: overdueDate,
                           repeatTime: "Never",
                           alertTime: "At Time of Event",
                           isComplete: false,
                           isCanceled: false,
                           isDeleted:  false,
                           dateFinished: nil,
                           cancelReason: nil,
                           deleteReason: nil,
                           UUID: UUID().uuidString)
        
        taskNotOverdue = TaskItem(title: "Unit Task Task Not Overdue",
                                  info:  "No Overdue",
                                  estimatedCompletion: notOverdueDate,
                                  repeatTime: "Never",
                                  alertTime:  "At Time of Event",
                                  isComplete: false,
                                  isCanceled: false,
                                  isDeleted:  false,
                                  dateFinished: nil,
                                  cancelReason: nil,
                                  deleteReason: nil,
                                  UUID: UUID().uuidString)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    // Test if the task is overdue
    func testTaskItemIsOverdue(){
        if let taskOverdue = taskOverdue{
            XCTAssert(taskOverdue.isOverdue == true)
        }
    }
    
    // Test if the task is not overdue
    func testTaskItemIsNotOverdue(){
        if let taskNotOverdue = taskNotOverdue{
            XCTAssert(taskNotOverdue.isOverdue == false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
