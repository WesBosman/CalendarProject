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
        
//        appPicker.adjustToPickerWheelValue("Class")
//        appPicker.adjustToPickerWheelValue("Speech Therapy")
//        XCTAssertTrue(app.tables.cells.textFields["Please enter the type of appointment"].accessibilityElementsHidden, "Enter Type of appointment should be hidden when speech therapy is selected")
//        XCTAssertTrue(app.tables.cells.buttons["Enter"].accessibilityElementsHidden, "Enter button should be hidden when speech therapy is selected")
        
        let otherTypeOfAppointment = app.textFields["Please enter the type of appointment"]
        otherTypeOfAppointment.tap()

        let enterButton = app.tables.cells.buttons["Enter"]
        enterButton.tap()
        XCTAssertTrue(app.tables.cells.textFields["Please enter the type of appointment here"].exists)
        
//        let newOtherTypeOfAppointment = app.tables.cells.textFields["Please enter the type of appointment here"]
//        XCTAssertTrue(newOtherTypeOfAppointment.exists)
//        newOtherTypeOfAppointment.tap()
//        newOtherTypeOfAppointment.typeText("UI Testing")
//        enterButton.tap()
        
        let startTime = app.tables.cells.staticTexts["Start Time"]
        startTime.tap()
        let startDay = app.tables.containingType(.Other, identifier:"APPOINTMENT TIME *").childrenMatchingType(.Cell).elementBoundByIndex(5).pickerWheels["Today"]
        startDay.tap()
        startDay.adjustToPickerWheelValue("Jul 30")
        
//        let satJul30ElementsQuery = app.tables.cells.otherElements.containingType(.PickerWheel, identifier:"Sat, Jul 30")
//        satJul30ElementsQuery.pickerWheels["9 o'clock"].tap()
//        satJul30ElementsQuery.pickerWheels["58 minutes"].tap()
//        satJul30ElementsQuery.pickerWheels["AM "].tap()
        
        let endTime = app.tables.cells.staticTexts["End Time"]
        endTime.tap()
    }
    
    func testAddAndCompleteTask(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tasks"].tap()
        
        let tasksNavigationBar = app.navigationBars["Tasks"]
        tasksNavigationBar.buttons["Add"].tap()
        
        let tablesQuery = app.tables
        let taskName = tablesQuery.textFields["Task Name"]
        taskName.tap()
        taskName.typeText("UI Automated Test To Complete")
        
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
        
        month.adjustToPickerWheelValue("August")
        day.adjustToPickerWheelValue("20")
        year.adjustToPickerWheelValue("2016")
        estimatedCompletionDate.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        let editButton = tasksNavigationBar.buttons["Edit"]
        editButton.tap()
        
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).buttons["Delete Event: UI Automated Test To Cancel, Additional Info:"].tap()
        
//        tablesQuery.buttons["Delete Event: UI Automated Test To Complete, Additional Info:"].tap()
        
        tablesQuery.buttons["Complete"].tap()
        app.alerts["Complete Task"].collectionViews.buttons["Complete Task"].tap()
        app.navigationBars["Tasks"].buttons["Done"].tap()
        
    }

    
    func testAddAndCancelTask(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()
        
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
        
        month.adjustToPickerWheelValue("August")
        day.adjustToPickerWheelValue("20")
        year.adjustToPickerWheelValue("2016")
        estimatedCompletionDate.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        let editButton = tasksNavigationBar.buttons["Edit"]
        editButton.tap()
        
        tablesQuery.buttons["Cancel Event: UI Automated Test To Cancel, Additional Info:"]
        
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).buttons["Delete Event: UI Automated Test To Cancel, Additional Info:"].tap()
        tablesQuery.buttons["Cancel"].tap()
        
        let deleteTaskButton = app.alerts["Cancel Task"].collectionViews.buttons["Cancel Task"]
        deleteTaskButton.tap()
    }
    
    func testAddAndDeleteTask() {
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()

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
        
        
        let additionalInformation = app.textFields["Additional Information"]
        additionalInformation.tap()
//        additionalInformation.typeText("Ui Test")
//        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(1).childrenMatchingType(.TextField).element
//        app.buttons["Return"].tap()
//        tablesQuery.staticTexts["Estimated Task Completion Date"].tap()
//        cell.childrenMatchingType(.TextField).element
//        hideKeyboardButton.tap()

        
        let month = app.tables.pickerWheels.elementBoundByIndex(0)
        let day = app.tables.pickerWheels.elementBoundByIndex(1)
        let year = app.tables.pickerWheels.elementBoundByIndex(2)
        let estimatedCompletionDate = app.tables.staticTexts["Estimated Task Completion Date"]
        
        month.adjustToPickerWheelValue("August")
        day.adjustToPickerWheelValue("20")
        year.adjustToPickerWheelValue("2016")
        estimatedCompletionDate.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        let editButton = tasksNavigationBar.buttons["Edit"]
        editButton.tap()

        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0).buttons["Delete Event: UI Automated Test To Delete, Additional Info:"].tap()
        tablesQuery.buttons["Delete"].tap()
        
        let deleteTaskButton = app.alerts["Delete Task"].collectionViews.buttons["Delete Task"]
        deleteTaskButton.tap()
    }
    
    func testAddAndDeleteJournal(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        app.staticTexts["Thank you for completing the consent form for this study. Please press the start button to enter the application."].tap()
        app.buttons["Start"].tap()
        
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
        
        let journalDeleteButton = app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).buttons["Delete Saturday, July 30, 2016, Saturday, July 30, 2016 :"]
        journalDeleteButton.tap()
        
        app.tables.buttons["Delete"].tap()
        let deleteJournalButton = app.alerts["Delete Journal"].collectionViews.buttons["Delete Journal"]
        deleteJournalButton.tap()
        app.navigationBars["Journals"].buttons["Done"].tap()
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
