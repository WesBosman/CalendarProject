//
//  AppointmentModelTest.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 12/24/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import XCTest

@testable import CreativeCalendar

class AppointmentModelTest: XCTestCase {
    var dateComp = DateComponents()
    let calendar = Calendar.current
    let date = Date()
    var appointmentOverdue: AppointmentItem? = nil
    var appointmentNotOverdue: AppointmentItem? = nil
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // Previous Day
        dateComp.day = -1
        let overdueDate = calendar.date(byAdding: dateComp, to: date)!
        dateComp.day = -1
        dateComp.hour = 1
        let overdueEndDate = calendar.date(byAdding: dateComp, to: date)!
        
        // Day after tomorrow
        dateComp.day = 2
        let notOverdueDate = calendar.date(byAdding: dateComp, to: date)!
        dateComp.day = 2
        dateComp.hour = 1
        let notOverdueEndDate = calendar.date(byAdding: dateComp, to: date)!
        
        
        appointmentOverdue = AppointmentItem(type: "Family",
                                             startTime: overdueDate,
                                             endTime: overdueEndDate,
                                             title: "Appointment Overdue",
                                             location: "House",
                                             additional: "None",
                                             repeatTime: "Never",
                                             alertTime: "At time of Event",
                                             isComplete: false,
                                             isCanceled: false,
                                             isDeleted: false,
                                             dateFinished: nil,
                                             cancelReason: nil,
                                             deleteReason: nil,
                                             UUID: UUID().uuidString)
        
        appointmentNotOverdue = AppointmentItem(type: "Family",
                                                startTime: notOverdueDate,
                                                endTime: notOverdueEndDate,
                                                title: "Not Overdue Appointment",
                                                location: "My House",
                                                additional: "N/A",
                                                repeatTime: "Never",
                                                alertTime: "At Time of Event",
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
    
    func testAppointmentIsOverdue(){
        if let appointmentOverdue = appointmentOverdue{
            XCTAssert(appointmentOverdue.isOverdue == true)
        }
    }
    
    func testAppointmentIsNotOverdue(){
        if let appointmentNotOverdue = appointmentNotOverdue{
            XCTAssert(appointmentNotOverdue.isOverdue == false)
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
