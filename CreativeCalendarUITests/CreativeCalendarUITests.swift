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
        let defaults = UserDefaults.standard.bool(forKey: defaultsConsentKey)
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
    
    func testAddAndCompleteAppointment(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("aaaaaaaa")
        app.buttons["Login"].tap()
        app.buttons["Start"].tap()
        app.tabBars.buttons["Appointments"].tap()
        app.navigationBars["Appointments"].buttons["Add"].tap()
        let nameOfAppointment = app.tables.cells.textFields["Name of Appointment"]
        nameOfAppointment.tap()
        nameOfAppointment.typeText("UI Test Appointment")
        
        // Try to save the appointment without adding all the information
        app.tables.buttons["Save Appointment"].tap()
        app.alerts["Missing Required Fields"].collectionViews.buttons["OK"].tap()
        
        
        // Click the type of appointment cell and adjust the picker
        let typeOfAppointment = app.tables.cells.staticTexts["Type of Appointment"]
        typeOfAppointment.tap()
        
        let appPicker = app.tables.cells.pickerWheels.element(boundBy: 0)
        appPicker.adjust(toPickerWheelValue: "Medical")
        XCTAssertTrue(app.tables.cells.staticTexts["Medical"].exists)
        
        appPicker.adjust(toPickerWheelValue: "Recreational")
        XCTAssertTrue(app.tables.cells.staticTexts["Recreational"].exists)

        appPicker.adjust(toPickerWheelValue: "Exercise")
        XCTAssertTrue(app.tables.cells.staticTexts["Exercise"].exists)

        appPicker.adjust(toPickerWheelValue: "Medication Times")
        XCTAssertTrue(app.tables.cells.staticTexts["Medication Times"].exists)

        appPicker.adjust(toPickerWheelValue: "Social Event")
        XCTAssertTrue(app.tables.cells.staticTexts["Social Event"].exists)

        appPicker.adjust(toPickerWheelValue: "Leisure")
        XCTAssertTrue(app.tables.cells.staticTexts["Leisure"].exists)

        appPicker.adjust(toPickerWheelValue: "Household")
        XCTAssertTrue(app.tables.cells.staticTexts["Household"].exists)

        appPicker.adjust(toPickerWheelValue: "Work")
        XCTAssertTrue(app.tables.cells.staticTexts["Work"].exists)

        appPicker.adjust(toPickerWheelValue: "Physical Therapy")
        XCTAssertTrue(app.tables.cells.staticTexts["Physical Therapy"].exists)

        appPicker.adjust(toPickerWheelValue: "Occupational Therapy")
        XCTAssertTrue(app.tables.cells.staticTexts["Occupational Therapy"].exists)

        appPicker.adjust(toPickerWheelValue: "Speech Therapy")
        XCTAssertTrue(app.tables.cells.staticTexts["Speech Therapy"].exists)
        
        // Check that the cell to type in other appointment types comes up
        appPicker.adjust(toPickerWheelValue: "Class")
        XCTAssertTrue(app.tables.cells.textFields["Please enter the type of appointment"].exists)
        XCTAssertTrue(app.tables.cells.buttons["Enter"].exists)
        
        appPicker.adjust(toPickerWheelValue: "Self Care")
        XCTAssertTrue(app.tables.cells.textFields["Please enter the type of appointment"].exists)
        XCTAssertTrue(app.tables.cells.buttons["Enter"].exists)

        appPicker.adjust(toPickerWheelValue: "Other")
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
        let startDay = app.tables.containing(.other, identifier:"APPOINTMENT TIME *").children(matching: .cell).element(boundBy: 5).pickerWheels["Today"]
        let startHour = app.tables.containing(.other, identifier: "APPOINTMENT TIME *").children(matching: .cell).element(boundBy: 5).pickerWheels["12"]
        let startMinute = app.tables.containing(.other, identifier: "APPOINTMENT TIME *").children(matching: .cell).element(boundBy: 5).pickerWheels["27"]
        
        startDay.tap()
        startHour.tap() //adjustToPickerWheelValue("1")
        startMinute.tap() //adjustToPickerWheelValue("30")
        
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
        
        
        let appointmentsNavigationBar = app.navigationBars["Appointments"]
        appointmentsNavigationBar.buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.buttons["Delete Event: UI Test Appointment, Type: Other: Other, Starting Time:  Aug 30 at 9:59 PM, Ending Time:   Aug 08 at 9:59 PM, Location: UI Location of Appointment, Additional Info:"].tap()
        tablesQuery.buttons["Complete"].tap()
        app.alerts["Complete Appointment"].collectionViews.buttons["Complete Appointment"].tap()
        appointmentsNavigationBar.buttons["Done"].tap()
        app.tabBars.buttons["Home"].tap()
        
        
        
    }
    
    func testAddAndCompleteTask(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        
        
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("aaaaaaaa")
        app.buttons["Login"].tap()
        
        
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        let todaysDate = Date()
        let calendarComponents = (calendar as NSCalendar).components([.month, .day, .year], from: todaysDate)
        let thisDay = calendarComponents.day
        let thisMonth = calendarComponents.month
        let thisYear = calendarComponents.year
        let todaysUpdatedDate = calendar.date(from: calendarComponents)
        print("This day: \(thisDay)")
        print("This Month: \(thisMonth)")
        print("This Year: \(thisYear)")
        print("Todays Updated Date: \(todaysUpdatedDate)")
        
        dateFormatter.dateFormat = "MMMM"
        let stringMonth = dateFormatter.string(from: todaysUpdatedDate!)
        dateFormatter.dateFormat = "d"
        let stringDay = dateFormatter.string(from: todaysUpdatedDate!)
        dateFormatter.dateFormat = "yyyy"
        let stringYear = dateFormatter.string(from: todaysUpdatedDate!)
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let stringFullDate = dateFormatter.string(from: todaysUpdatedDate!)
        
        
        print("String Day: \(stringDay)")
        print("String Month: \(stringMonth)")
        print("String Year: \(stringYear)")
        print("String Full Date: \(stringFullDate)")
        
//        XCTAssert(stringDay == "2", "Todays Day is correct")
//        XCTAssert(stringMonth == "August", "Todays Month is correct")
//        XCTAssert(stringYear == "2016", "Todays Year is correct")
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tasks"].tap()
        
        // Add task
        let tasksNavigationBar = app.navigationBars["Tasks"]
        tasksNavigationBar.buttons["Add"].tap()
        
        // Try to save the task without filling in all the information
        app.tables.buttons["Save Task"].tap()
        app.alerts["Missing Task Title or Date"].collectionViews.buttons["OK"].tap()
        
        
        // Add task name
        let tablesQuery = app.tables
        let taskName = tablesQuery.textFields["Task Name"]
        taskName.tap()
        taskName.typeText("UI Automated Test To Complete")

        // Add Additional Information
        let additionalInformation = app.textFields["Additional Information"]
        additionalInformation.tap()
        additionalInformation.typeText("UI Additional Information")
        
        let month = app.tables.pickerWheels.element(boundBy: 0)
        let day = app.tables.pickerWheels.element(boundBy: 1)
        let year = app.tables.pickerWheels.element(boundBy: 2)
        let estimatedCompletionDate = app.tables.staticTexts["Estimated Task Completion Date"]
        
        month.adjust(toPickerWheelValue: stringMonth)
        day.adjust(toPickerWheelValue: stringDay)
        year.adjust(toPickerWheelValue: stringYear)
        estimatedCompletionDate.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        let editButton = tasksNavigationBar.buttons["Edit"]
        editButton.tap()
        
        // Complete the event
app.tables.buttons["Delete Event: UI Automated Test To Complete, Complete by: \(stringFullDate), Additional Info: UI Additional Information"].tap()
        tablesQuery.buttons["Complete"].tap()
        app.alerts["Complete Task"].collectionViews.buttons["Complete Task"].tap()
        tasksNavigationBar.buttons["Done"].tap()
        
        // Go to the home screen
        app.tabBars.buttons["Home"].tap()
        
        app.tables.cells.containing(.staticText, identifier:"UI Automated Test To Complete").staticTexts["\(stringFullDate)"].tap()
        
        let exitMenuButton = app.alerts["Hello"].collectionViews.buttons["Exit Menu"]
        exitMenuButton.tap()
    }

    
    func testAddAndCancelTask(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("aaaaaaaa")
        app.buttons["Login"].tap()
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        let todaysDate = Date()
        let calendarComponents = (calendar as NSCalendar).components([.month, .day, .year], from: todaysDate)
        let thisDay = calendarComponents.day
        let thisMonth = calendarComponents.month
        let thisYear = calendarComponents.year
        let todaysUpdatedDate = calendar.date(from: calendarComponents)
        print("This day: \(thisDay)")
        print("This Month: \(thisMonth)")
        print("This Year: \(thisYear)")
        print("Todays Updated Date: \(todaysUpdatedDate)")
        
        dateFormatter.dateFormat = "MMMM"
        let stringMonth = dateFormatter.string(from: todaysUpdatedDate!)
        dateFormatter.dateFormat = "d"
        let stringDay = dateFormatter.string(from: todaysUpdatedDate!)
        dateFormatter.dateFormat = "yyyy"
        let stringYear = dateFormatter.string(from: todaysUpdatedDate!)
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let stringFullDate = dateFormatter.string(from: todaysUpdatedDate!)
        
        print("String Day: \(stringDay)")
        print("String Month: \(stringMonth)")
        print("String Year: \(stringYear)")
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Tasks"].tap()
        let tasksNavigationBar = app.navigationBars["Tasks"]
        tasksNavigationBar.buttons["Add"].tap()
        
        // Add task name
        let tablesQuery = app.tables
        let taskName = tablesQuery.textFields["Task Name"]
        taskName.tap()
        taskName.typeText("UI Automated Test To Cancel")
        
        // Add additional information
        let additionalInformation = app.textFields["Additional Information"]
        additionalInformation.tap()
        additionalInformation.typeText("Additional Information for Task to Cancel")
        
        let month = app.tables.pickerWheels.element(boundBy: 0)
        let day = app.tables.pickerWheels.element(boundBy: 1)
        let year = app.tables.pickerWheels.element(boundBy: 2)
        let estimatedCompletionDate = app.tables.staticTexts["Estimated Task Completion Date"]
        
        month.adjust(toPickerWheelValue: stringMonth)
        day.adjust(toPickerWheelValue: stringDay)
        year.adjust(toPickerWheelValue: stringYear)
        estimatedCompletionDate.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        let editButton = tasksNavigationBar.buttons["Edit"]
        editButton.tap()
        
        tablesQuery.buttons["Delete Event: UI Automated Test To Cancel, Complete by: \(stringFullDate), Additional Info: Additional Information for Task to Cancel"].tap()

        tablesQuery.buttons["Cancel"].tap()
        
        
        let cancelTaskButton = app.alerts["Cancel Task"].collectionViews.buttons["Cancel Task"]
        XCTAssert(cancelTaskButton.isEnabled == false, "Cancel Task Button should be disabled")
        
        
        let collectionViewsQuery = app.alerts["Cancel Task"].collectionViews
        let cancelReason = collectionViewsQuery.textFields["Reason for Cancel"]
        cancelReason.typeText("Reason to Cancel Task")
        collectionViewsQuery.buttons["Cancel Task"].tap()
        tasksNavigationBar.buttons["Done"].tap()
        app.tabBars.buttons["Home"].tap()
    }
    
    func testAddAndDeleteTask() {
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("aaaaaaaa")
        app.buttons["Login"].tap()
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        let todaysDate = Date()
        let calendarComponents = (calendar as NSCalendar).components([.month, .day, .year], from: todaysDate)
        let thisDay = calendarComponents.day
        let thisMonth = calendarComponents.month
        let thisYear = calendarComponents.year
        let todaysUpdatedDate = calendar.date(from: calendarComponents)
        print("This day: \(thisDay)")
        print("This Month: \(thisMonth)")
        print("This Year: \(thisYear)")
        print("Todays Updated Date: \(todaysUpdatedDate)")
        
        dateFormatter.dateFormat = "MMMM"
        let stringMonth = dateFormatter.string(from: todaysUpdatedDate!)
        dateFormatter.dateFormat = "d"
        let stringDay = dateFormatter.string(from: todaysUpdatedDate!)
        dateFormatter.dateFormat = "yyyy"
        let stringYear = dateFormatter.string(from: todaysUpdatedDate!)
        dateFormatter.dateFormat = "MMMM dd yyyy"
        let stringFullDate = dateFormatter.string(from: todaysUpdatedDate!)
        
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
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.children(matching: .textField).element
        app.buttons["Return"].tap()
        cell.children(matching: .textField).element
        let hideKeyboardButton = app.buttons["Hide keyboard"]
        hideKeyboardButton.tap()
        
        
        let additionalInformation = tablesQuery.textFields["Additional Information"]
        additionalInformation.tap()
        additionalInformation.typeText("UI Additional Information")
        
        let month = app.tables.pickerWheels.element(boundBy: 0)
        let day = app.tables.pickerWheels.element(boundBy: 1)
        let year = app.tables.pickerWheels.element(boundBy: 2)
        let estimatedCompletionDate = app.tables.staticTexts["Estimated Task Completion Date"]
        
        month.adjust(toPickerWheelValue: "\(stringMonth)")
        day.adjust(toPickerWheelValue: "\(stringDay)")
        year.adjust(toPickerWheelValue: "\(stringYear)")
        estimatedCompletionDate.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        let editButton = tasksNavigationBar.buttons["Edit"]
        editButton.tap()
        
        tablesQuery.buttons["Delete Event: UI Automated Test To Delete, Complete by: \(stringFullDate), Additional Info: UI Additional Information"].tap()
        tablesQuery.buttons["Delete"].tap()
        
        let collectionViewsQuery = app.alerts["Delete Task"].collectionViews
        let deleteTaskButton = collectionViewsQuery.buttons["Delete Task"]
        let deleteReason = collectionViewsQuery.textFields["Reason for Delete"]
        XCTAssertTrue(deleteTaskButton.isEnabled == false, "Delete button is not yet enabled for tasks")
        deleteReason.tap()
        deleteReason.typeText("Reason to delete task")
        XCTAssertTrue(deleteTaskButton.isEnabled == true, "Delete button is now enabled for tasks")
        
        deleteTaskButton.tap()
        app.navigationBars["Tasks"].buttons["Done"].tap()
        app.buttons["Home"].tap()
    }
    
    func testAddAndDeleteJournal(){
        
        let app = XCUIApplication()
        app.staticTexts["Welcome to Dr. Lageman's App Study for Parkinson's Disease Research"].tap()
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("aaaaaaaa")
        app.buttons["Login"].tap()
        
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        let todaysDate = Date()
        let calendarComponents = (calendar as NSCalendar).components([.month, .day, .year], from: todaysDate)
        let thisDay = calendarComponents.day
        let thisMonth = calendarComponents.month
        let thisYear = calendarComponents.year
        let todaysUpdatedDate = calendar.date(from: calendarComponents)
        print("This day: \(thisDay)")
        print("This Month: \(thisMonth)")
        print("This Year: \(thisYear)")
        print("Todays Updated Date: \(todaysUpdatedDate)")
        
        dateFormatter.dateFormat = "EEEE, MMMM dd, yyyy"
        let stringFullDate = dateFormatter.string(from: todaysUpdatedDate!)
        app.tabBars.buttons["Journals"].tap()
        app.navigationBars.buttons["Add"].tap()
        let textView = app.textViews["\(stringFullDate) : "]
        textView.tap()
        textView.typeText("Click Click Click ")
        app.buttons["Hide keyboard"].tap()
        app.buttons["Save Journal Entry"].tap()
        
        
        let journalsNavigationBar = app.navigationBars["Journals"]
        journalsNavigationBar.buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.buttons["Delete \(stringFullDate), Click Click Click \(stringFullDate) :"].tap()
        let deleteJournal = tablesQuery.buttons["Delete"]
        deleteJournal.tap()
        let collectionViewsQuery = app.alerts["Delete Journal"].collectionViews
        let reasonToDelete = collectionViewsQuery.textFields["Reason for Delete"]
        reasonToDelete.tap()
        reasonToDelete.typeText("Reason To Delete Journal")
        collectionViewsQuery.buttons["Delete Journal"].tap()
        app.navigationBars["Journals"].buttons["Done"].tap()
        
    }
    
    func testCalendar(){
        
        let app = XCUIApplication()
        
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("aaaaaaaa")
        app.buttons["Login"].tap()
        app.tabBars.buttons["Calendar"].tap()
        
        let moreButton = app.buttons["More"]
        moreButton.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let firstView = elementsQuery.staticTexts["Appointments"]
        firstView.swipeLeft()
        let secondView = elementsQuery.staticTexts["Tasks"]
        secondView.swipeLeft()
        let thirdView = elementsQuery.staticTexts["Journals"]
        thirdView.swipeRight()
        secondView.swipeRight()
        XCUIApplication().children(matching: .window).element(boundBy: 0).children(matching: .other).element(boundBy: 1).children(matching: .other).element(boundBy: 1).children(matching: .image).element(boundBy: 3).tap()
        
        
        let rightarrowdarkButton = app.buttons["RightArrowDark"]
        rightarrowdarkButton.tap()
        rightarrowdarkButton.tap()
        rightarrowdarkButton.tap()
        
        let leftarrowdarkButton = app.buttons["LeftArrowDark"]
        leftarrowdarkButton.tap()
        leftarrowdarkButton.tap()
        leftarrowdarkButton.tap()
        app.tabBars.buttons["Home"].tap()
        
    }
    
}
