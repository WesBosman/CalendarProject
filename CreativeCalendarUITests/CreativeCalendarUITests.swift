//
//  CreativeCalendarUITests.swift
//  CreativeCalendarUITests
//
//  Created by Wes Bosman on 6/14/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import XCTest

extension CreativeCalendarUITests{
    var welcomeSurveyComplete:Bool {
        let defaultsConsentKey = "UserConsent"
        let defaults = NSUserDefaults.standardUserDefaults().boolForKey(defaultsConsentKey)
        return defaults
    }
}

class CreativeCalendarUITests: XCTestCase {
        
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
        XCUIApplication().terminate()
    }
    
    func testAddAppointment(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()
        app.tabBars.buttons["Appointments"].tap()
        app.navigationBars["Appointments"].buttons["Add"].tap()
        let nameOfAppointment = app.tables.cells.textFields["Name of Appointment"]
        nameOfAppointment.tap()
        nameOfAppointment.typeText("UI Test Appointment")
        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).childrenMatchingType(.TextField).element
        app.keyboards.buttons["Hide keyboard"].tap()
        
        
        // Click the type of appointment cell and adjust the picker
        let typeOfAppointment = app.tables.cells.staticTexts["Type of Appointment"]
        typeOfAppointment.tap()
        
        let appPicker = app.tables.cells.pickerWheels.elementBoundByIndex(0)
        appPicker.adjustToPickerWheelValue("Medical")
        XCTAssertTrue(app.tables.cells.staticTexts["Medical"].exists)
        
        appPicker.adjustToPickerWheelValue("Recreational")
        XCTAssertTrue(app.tables.cells.staticTexts["Recreational"].exists)

        appPicker.adjustToPickerWheelValue("Exercise")
        XCTAssertTrue(app.tables.cells.staticTexts["Exercise"].exists)

        appPicker.adjustToPickerWheelValue("Medication Times")
        XCTAssertTrue(app.tables.cells.staticTexts["Medication Times"].exists)

        appPicker.adjustToPickerWheelValue("Social Event")
        XCTAssertTrue(app.tables.cells.staticTexts["Social Event"].exists)

        appPicker.adjustToPickerWheelValue("Leisure")
        XCTAssertTrue(app.tables.cells.staticTexts["Leisure"].exists)

        appPicker.adjustToPickerWheelValue("Household")
        XCTAssertTrue(app.tables.cells.staticTexts["Household"].exists)

        appPicker.adjustToPickerWheelValue("Work")
        XCTAssertTrue(app.tables.cells.staticTexts["Work"].exists)

        appPicker.adjustToPickerWheelValue("Physical Therapy")
        XCTAssertTrue(app.tables.cells.staticTexts["Physical Therapy"].exists)

        appPicker.adjustToPickerWheelValue("Occupational Therapy")
        XCTAssertTrue(app.tables.cells.staticTexts["Occupational Therapy"].exists)

        appPicker.adjustToPickerWheelValue("Speech Therapy")
        XCTAssertTrue(app.tables.cells.staticTexts["Speech Therapy"].exists)
        
        // Check that the cell to type in other appointment types comes up
        appPicker.adjustToPickerWheelValue("Class")
        XCTAssertTrue(app.tables.cells.textFields["Please enter the type of appointment"].exists)
        XCTAssertTrue(app.tables.cells.buttons["Enter"].exists)
        
        appPicker.adjustToPickerWheelValue("Self Care")
        XCTAssertTrue(app.tables.cells.textFields["Please enter the type of appointment"].exists)
        XCTAssertTrue(app.tables.cells.buttons["Enter"].exists)

        appPicker.adjustToPickerWheelValue("Other")
        XCTAssertTrue(app.tables.cells.textFields["Please enter the type of appointment"].exists)
        XCTAssertTrue(app.tables.cells.buttons["Enter"].exists)
        
        let otherTypeOfAppointment = app.textFields["Please enter the type of appointment"]
        otherTypeOfAppointment.tap()
        otherTypeOfAppointment.typeText("UI Type Of Appointment")

        let enterButton = app.tables.cells.buttons["Enter"]
        enterButton.tap()
        XCTAssertTrue(app.tables.cells.textFields["UI Type Of Appointment"].exists)
        
        let startTime = app.tables.cells.staticTexts["Start Time"]
        startTime.tap()
        let startDay = app.tables.containingType(.Other, identifier:"APPOINTMENT TIME *").childrenMatchingType(.Cell).elementBoundByIndex(5).pickerWheels["Today"]
        startDay.tap()
        startDay.adjustToPickerWheelValue("Jul 30")
        
        let endTime = app.tables.cells.staticTexts["End Time"]
        endTime.tap()
    }
    
    func testAddAndCompleteTask(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()
        
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
        
        
        print("String Day: \(stringDay)")
        print("String Month: \(stringMonth)")
        print("String Year: \(stringYear)")
        print("String Full Date: \(stringFullDate)")
        
//        XCTAssert(stringDay == "2", "Todays Day is correct")
//        XCTAssert(stringMonth == "August", "Todays Month is correct")
//        XCTAssert(stringYear == "2016", "Todays Year is correct")
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tasks"].tap()
        
        let tasksNavigationBar = app.navigationBars["Tasks"]
        tasksNavigationBar.buttons["Add"].tap()
        
        let tablesQuery = app.tables
        let taskName = tablesQuery.textFields["Task Name"]
        taskName.tap()
        taskName.typeText("UI Automated Test To Complete")
        
//        let cell = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0)
//        cell.childrenMatchingType(.TextField).element
//        app.buttons["Return"].tap()
//        cell.childrenMatchingType(.TextField).element
//        let hideKeyboardButton = app.buttons["Hide keyboard"]
//        hideKeyboardButton.tap()
        
        
        let additionalInformation = app.textFields["Additional Information"]
        additionalInformation.tap()
        additionalInformation.typeText("UI Additional Information")
        
        let month = app.tables.pickerWheels.elementBoundByIndex(0)
        let day = app.tables.pickerWheels.elementBoundByIndex(1)
        let year = app.tables.pickerWheels.elementBoundByIndex(2)
        let estimatedCompletionDate = app.tables.staticTexts["Estimated Task Completion Date"]
        
        month.adjustToPickerWheelValue(stringMonth)
        day.adjustToPickerWheelValue(stringDay)
        year.adjustToPickerWheelValue(stringYear)
        estimatedCompletionDate.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        let editButton = tasksNavigationBar.buttons["Edit"]
        editButton.tap()
        
app.tables.buttons["Delete Event: UI Automated Test To Complete, Complete by: \(stringFullDate), Additional Info: UI Additional Information"].tap()
        
        
//        tablesQuery.buttons["Delete Event: UI Automated Test To Complete, Complete by: \(stringFullDate), Additional Info: UI Additional Information"].tap()
        tablesQuery.buttons["Complete"].tap()
        app.alerts["Complete Task"].collectionViews.buttons["Complete Task"].tap()
        tasksNavigationBar.buttons["Done"].tap()
        app.tabBars.buttons["Home"].tap()
        app.tables.staticTexts["\(stringFullDate)"].tap()
        app.alerts["Hello"].collectionViews.buttons["Exit Menu"].tap()
    }

    
    func testAddAndCancelTask(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()
        
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
        dateFormatter.dateFormat = "EEEE M/dd/yyyy"
        let stringFullDate = dateFormatter.stringFromDate(todaysUpdatedDate!)
        
        print("String Day: \(stringDay)")
        print("String Month: \(stringMonth)")
        print("String Year: \(stringYear)")

        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tasks"].tap()
        
        let tasksNavigationBar = app.navigationBars["Tasks"]
        tasksNavigationBar.buttons["Add"].tap()
        
        let tablesQuery = app.tables
        let taskName = tablesQuery.textFields["Task Name"]
        taskName.tap()
        taskName.typeText("UI Automated Test To Cancel")
        
        let cell = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0)
        cell.childrenMatchingType(.TextField).element
        app.buttons["Return"].tap()
        cell.childrenMatchingType(.TextField).element
        let hideKeyboardButton = app.buttons["Hide keyboard"]
        hideKeyboardButton.tap()
        
        
        let additionalInformation = app.textFields["Additional Information"]
        additionalInformation.tap()
        
        let month = app.tables.pickerWheels.elementBoundByIndex(0)
        let day = app.tables.pickerWheels.elementBoundByIndex(1)
        let year = app.tables.pickerWheels.elementBoundByIndex(2)
        let estimatedCompletionDate = app.tables.staticTexts["Estimated Task Completion Date"]
        
        month.adjustToPickerWheelValue(stringMonth)
        day.adjustToPickerWheelValue(stringDay)
        year.adjustToPickerWheelValue(stringYear)
        estimatedCompletionDate.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        let editButton = tasksNavigationBar.buttons["Edit"]
        editButton.tap()
        
        tablesQuery.buttons["Delete Event: UI Automated Test To Cancel, Complete by: \(stringFullDate), Additional Info:"].tap()
        tablesQuery.buttons["Cancel"].tap()
        app.alerts["Cancel Task"].collectionViews.buttons["Cancel Task"].tap()
        tasksNavigationBar.buttons["Done"].tap()
        app.tabBars.buttons["Home"].tap()
        app.tables.staticTexts["\(stringFullDate)"].tap()
        app.alerts["Hello"].collectionViews.buttons["Exit Menu"].tap()
    }
    
    func testAddAndDeleteTask() {
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()
        
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
        
        print("String Day: \(stringDay)")
        print("String Month: \(stringMonth)")
        print("String Year: \(stringYear)")

        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tasks"].tap()
        
        let tasksNavigationBar = app.navigationBars["Tasks"]
        tasksNavigationBar.buttons["Add"].tap()
        
        let tablesQuery = app.tables
        let taskName = tablesQuery.textFields["Task Name"]
        taskName.tap()
        taskName.typeText("UI Automated Test To Delete")
        
        let cell = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0)
        cell.childrenMatchingType(.TextField).element
        app.buttons["Return"].tap()
        cell.childrenMatchingType(.TextField).element
        let hideKeyboardButton = app.buttons["Hide keyboard"]
        hideKeyboardButton.tap()
        
        
        let additionalInformation = tablesQuery.textFields["Additional Information"]
        additionalInformation.tap()
        additionalInformation.typeText("UI Additional Information")
        
        let month = app.tables.pickerWheels.elementBoundByIndex(0)
        let day = app.tables.pickerWheels.elementBoundByIndex(1)
        let year = app.tables.pickerWheels.elementBoundByIndex(2)
        let estimatedCompletionDate = app.tables.staticTexts["Estimated Task Completion Date"]
        
        month.adjustToPickerWheelValue("\(stringMonth)")
        day.adjustToPickerWheelValue("\(stringDay)")
        year.adjustToPickerWheelValue("\(stringYear)")
        estimatedCompletionDate.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        let editButton = tasksNavigationBar.buttons["Edit"]
        editButton.tap()
        
        tablesQuery.buttons["Delete Event: UI Automated Test To Delete, Complete by: \(stringFullDate), Additional Info:"].tap()
        tablesQuery.buttons["Delete"].tap()
        app.alerts["Delete Task"].collectionViews.buttons["Delete Task"].tap()
        tasksNavigationBar.buttons["Done"].tap()
    }
    
    func testAddAndDeleteJournal(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()
        
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
        
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let stringFullDate = dateFormatter.stringFromDate(todaysUpdatedDate!)
                
        let tabBarsQuery = app.tabBars
        let journalsButton = tabBarsQuery.buttons["Journals"]
        journalsButton.tap()
        
        let journalsNavigationBar = app.navigationBars["Journals"]
        let addButton = journalsNavigationBar.buttons["Add"]
        addButton.tap()
        
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        element.childrenMatchingType(.TextView).element.tap()
//        element.childrenMatchingType(.TextView).element.typeText("Journal Text Goes Here...")
        app.buttons["Save Journal Entry"].tap()
        
        let editButton = journalsNavigationBar.buttons["Edit"]
        editButton.tap()
        
        let tablesQuery = app.tables
        tablesQuery.buttons["Delete Tuesday, August 02, 2016, Tuesday, August 02, 2016 :"].tap()
        tablesQuery.buttons["Delete"].tap()
        app.alerts["Delete Journal"].collectionViews.buttons["Delete Journal"].tap()
        app.navigationBars["Journals"].buttons["Done"].tap()
        app.tabBars.buttons["Home"].tap()
    }
    
    func testCalendar(){
        
        let app = XCUIApplication()
        app.buttons["Start"].tap()
        app.tabBars.buttons["Calendar"].tap()
        app.collectionViews.staticTexts["20"].tap()
        
        let window = app.childrenMatchingType(.Window).elementBoundByIndex(0)
        window.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.tap()
        app.buttons["More"].tap()
        
        let element = window.childrenMatchingType(.Other).elementBoundByIndex(1).childrenMatchingType(.Other).elementBoundByIndex(2).childrenMatchingType(.Other).elementBoundByIndex(0).childrenMatchingType(.Other).element
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        element.tap()
        app.otherElements["PopoverDismissRegion"].tap()
        
        let rightarrowButton = app.buttons["RightArrow"]
        rightarrowButton.tap()
        rightarrowButton.tap()
        rightarrowButton.tap()
        rightarrowButton.tap()
        
        let leftarrowButton = app.buttons["LeftArrow"]
        leftarrowButton.tap()
        leftarrowButton.tap()
        leftarrowButton.tap()
        leftarrowButton.tap()
        
    }
    
}
