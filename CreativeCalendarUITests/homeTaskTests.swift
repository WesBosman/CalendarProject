//
//  homeTaskTests.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 8/9/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import XCTest

class homeTaskTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHomeTask() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        app.buttons["Start"].tap()
        app.tabBars.buttons["Tasks"].tap()
        app.navigationBars["Tasks"].buttons["Add"].tap()
        
        let calendar = NSCalendar.currentCalendar()
        let dateFormatter = NSDateFormatter()
        let todaysDate = NSDate()
        let calendarComponents = calendar.components([.Month, .Day, .Year], fromDate: todaysDate)
        let thisDay = calendarComponents.day
        let thisMonth = calendarComponents.month
        let thisYear = calendarComponents.year
        let todaysUpdatedDate = calendar.dateFromComponents(calendarComponents)
        print("This day: \(thisDay)")
        print("This Month: \(thisMonth)")
        print("This Year: \(thisYear)")
        print("Todays Updated Date: \(todaysUpdatedDate)")
        
        dateFormatter.dateFormat = "MMMM"
        let stringMonth = dateFormatter.stringFromDate(todaysUpdatedDate!)
        dateFormatter.dateFormat = "d"
        let stringDay = dateFormatter.stringFromDate(todaysUpdatedDate!)
        dateFormatter.dateFormat = "yyyy"
        let stringYear = dateFormatter.stringFromDate(todaysUpdatedDate!)
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let stringFullDate = dateFormatter.stringFromDate(todaysUpdatedDate!)
        
        let taskName = app.tables.cells.textFields["Task Name"]
        taskName.tap()
        taskName.typeText("UI Automated Home Task To Complete")
        
        
        let additionalInformation = app.tables.cells.textFields["Additional Information"]
        additionalInformation.tap()
        additionalInformation.typeText("UI Automated Home Task Additional Information")
        
        let month = app.tables.pickerWheels.elementBoundByIndex(0)
        let day = app.tables.pickerWheels.elementBoundByIndex(1)
        let year = app.tables.pickerWheels.elementBoundByIndex(2)
        let estimatedCompletionDate = app.tables.staticTexts["Estimated Task Completion Date"]
        
        month.adjustToPickerWheelValue(stringMonth)
        day.adjustToPickerWheelValue(stringDay)
        year.adjustToPickerWheelValue(stringYear)
        estimatedCompletionDate.tap()
        
        let saveTaskButton = app.tables.buttons["Save Task"]
        saveTaskButton.tap()
        
        let homeButton = app.tabBars.buttons["Home"]
        homeButton.tap()
        
        let myTask = app.tables.staticTexts["\(stringFullDate)"]
        myTask.tap()
        
        let alertView = app.alerts["Hello"].collectionViews
        alertView.buttons["Complete Task"].tap()
        
        let alertView2 = app.alerts["Confirmation"].collectionViews
        alertView2.buttons["Complete"].tap()
        
        myTask.tap()
        
        alertView.buttons["Cancel Task"].tap()
        let cancelText = alertView2.textFields["Reason for cancel"]
        cancelText.typeText("This was only a home task test")
        alertView2.buttons["Cancel"].tap()
        
        myTask.tap()
        
        alertView.buttons["Exit Menu"].tap()
        
        myTask.tap()
        alertView.buttons["Delete Task"].tap()
        let deleteText = alertView2.textFields["Reason for delete"]
        deleteText.typeText("This was only a home task test")
        alertView2.buttons["Delete"].tap()
        
        
    }
    
    func testHomeAppointment(){
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()
        
        app.tabBars.buttons["Appointments"].tap()
        app.navigationBars["Appointments"].buttons["Add"].tap()
        let nameOfAppointment = app.tables.cells.textFields["Name of Appointment"]
        nameOfAppointment.tap()
        nameOfAppointment.typeText("UI Home Test Appointment")
        let typeOfAppointment = app.tables.cells.staticTexts["Type of Appointment"]
        typeOfAppointment.tap()
        
        let appPicker = app.tables.cells.pickerWheels.elementBoundByIndex(0)
        appPicker.adjustToPickerWheelValue("Medical")
        XCTAssertTrue(app.tables.cells.staticTexts["Medical"].exists)
        
        appPicker.adjustToPickerWheelValue("Recreational")
        XCTAssertTrue(app.tables.cells.staticTexts["Recreational"].exists)
        
        appPicker.adjustToPickerWheelValue("Exercise")
        XCTAssertTrue(app.tables.cells.staticTexts["Exercise"].exists)
        
        typeOfAppointment.tap()
        
        let startTime = app.tables.cells.staticTexts["Start Time"]
        startTime.tap()
        let startDay = app.tables.containingType(.Other, identifier:"APPOINTMENT TIME *").childrenMatchingType(.Cell).elementBoundByIndex(5).pickerWheels["Today"]
        startDay.tap()
        
        let endTime = app.tables.cells.staticTexts["End Time"]
        endTime.tap()
        
        let appointmentLocation = app.tables.cells.textFields["Location of Appointment"]
        appointmentLocation.tap()
        appointmentLocation.typeText("UI Location of Appointment")
        
        let additionalInformation = app.tables.cells.textViews["Additional Information..."]
        additionalInformation.tap()
//        additionalInformation.typeText("UI Additional Information")

        let repeatAppointment = app.tables.cells.staticTexts["Schedule a repeating Appointment"]
        repeatAppointment.tap()
        
        let saveButton = app.tables.cells.buttons["Save Appointment"]
        saveButton.tap()
 
        app.tabBars.buttons["Home"].tap()
        let myAppointment = app.tables.staticTexts["UI Home Test Appointment"]
        myAppointment.tap()
        
        
        let alertView = app.alerts["Hello"].collectionViews
        alertView.buttons["Complete Appointment"].tap()
        
        let alertView2 = app.alerts["Confirmation"].collectionViews
        alertView2.buttons["Complete"].tap()
        
        myAppointment.tap()
        alertView.buttons["Cancel Appointment"].tap()
        
        let cancelText = alertView2.textFields["Reason for cancel"]
        cancelText.tap()
        cancelText.typeText("This is a home appointment test")
        alertView2.buttons["Cancel"].tap()
        
        myAppointment.tap()
        alertView.buttons["Exit Menu"].tap()
        
        myAppointment.tap()
        alertView.buttons["Delete Appointment"].tap()
        let deleteText = alertView2.textFields["Reason for delete"]
        deleteText.tap()
        deleteText.typeText("This is a home appointment test")
        alertView2.buttons["Delete"].tap()
        
    }
    
}
