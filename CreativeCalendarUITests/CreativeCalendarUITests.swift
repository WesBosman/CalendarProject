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
    }
    
    func testAddAppointments(){
        
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
    
    func testAddTasks() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
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
        taskName.typeText("Ui Automated Test")
        
        let cell = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0)
        cell.childrenMatchingType(.TextField).element
        app.buttons["Return"].tap()
        cell.childrenMatchingType(.TextField).element
        let hideKeyboardButton = app.buttons["Hide keyboard"]
        hideKeyboardButton.tap()
        
        
        tablesQuery.textFields["Additional Information"].tap()
        tablesQuery.textFields["Additional Information"].typeText("Ui Automated Test")
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(1).childrenMatchingType(.TextField).element
        app.buttons["Return"].tap()
        tablesQuery.staticTexts["Estimated Task Completion Date"].tap()
        cell.childrenMatchingType(.TextField).element
        hideKeyboardButton.tap()

        
        let month = app.tables.pickerWheels.elementBoundByIndex(0)
        let day = app.tables.pickerWheels.elementBoundByIndex(1)
        let year = app.tables.pickerWheels.elementBoundByIndex(2)
        
        month.adjustToPickerWheelValue("August")
        day.adjustToPickerWheelValue("2")
        year.adjustToPickerWheelValue("2016")
        tablesQuery.staticTexts["Estimated Task Completion Date"].tap()
        
        
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        
        tablesQuery.buttons["Delete Event: Ui Automated Test, Additional Info: Ui Automated Test"].tap()
        
        let deleteButton = tablesQuery.buttons["Delete"]
        deleteButton.tap()
        tablesQuery.buttons["Delete Event: task title, Additional Info: task info"].tap()
        deleteButton.tap()
        tasksNavigationBar.buttons["Done"].tap()
        tabBarsQuery.buttons["Home"].tap()
        
//        let nameOfTaskStaticText = app.tables.staticTexts["name of task"]
//        nameOfTaskStaticText.tap()
//        
//        let collectionViewsQuery = app.alerts["Hello"].collectionViews
//        let yesButton = collectionViewsQuery.buttons["yes"]
//        yesButton.tap()
//        nameOfTaskStaticText.tap()
//        
//        let noButton = collectionViewsQuery.buttons["no"]
//        noButton.tap()
//        noButton.tap()
//        app.tables.staticTexts["example task"].tap()
//        yesButton.tap()
//        app.tables.staticTexts["do this thing"].tap()
//        noButton.tap()
//        noButton.tap()

        
        /*
            let elementsQuery = app.scrollViews.otherElements
            elementsQuery.buttons["Get Started"].tap()
            
            let nextButton = elementsQuery.buttons["Next"]
            nextButton.tap()
            nextButton.tap()
            nextButton.tap()
            nextButton.tap()
            nextButton.tap()
            nextButton.tap()
            nextButton.tap()
            nextButton.tap()
            
            let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
            element.tap()
            element.tap()
            app.toolbars.buttons["Agree"].tap()
            app.alerts["Review"].collectionViews.buttons["Agree"].tap()
            
            let tablesQuery2 = app.tables
            let tablesQuery = tablesQuery2
            tablesQuery.textFields["First Name"].tap()
            
            let app2 = app
            app2.keys["W"].tap()
            tablesQuery.textFields["First Name"]
            tablesQuery.textFields["Last Name"].tap()
            app2.keys["B"].tap()
            tablesQuery.textFields["Last Name"]
            app2.buttons["Hide keyboard"].tap()
            tablesQuery2.buttons["Next"].tap()
            
            let designatedSignatureFieldElement = elementsQuery.otherElements["Designated signature field"]
            designatedSignatureFieldElement.tap()
            designatedSignatureFieldElement.tap()
            elementsQuery.buttons["Done"].tap()
            XCUIDevice.sharedDevice().orientation = .FaceUp
            */
    }
    
    func testJournals(){
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        let journalsButton = tabBarsQuery.buttons["Journals"]
        journalsButton.tap()
        
        let journalsNavigationBar = app.navigationBars["Journals"]
        let addButton = journalsNavigationBar.buttons["Add"]
        addButton.tap()
        
        let element = app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element
        let textView = element.childrenMatchingType(.TextView).element
        textView.tap()
        element.childrenMatchingType(.TextView).element
        
        let element2 = app.keyboards.childrenMatchingType(.Other).element.childrenMatchingType(.Other).elementBoundByIndex(2)
        let moreNumbersKey = element2.childrenMatchingType(.Key).matchingIdentifier("more, numbers").elementBoundByIndex(0)
        moreNumbersKey.tap()
        moreNumbersKey.tap()
        element.childrenMatchingType(.TextView).element
        
        let moreLettersKey = element2.childrenMatchingType(.Key).matchingIdentifier("more, letters").elementBoundByIndex(0)
        moreLettersKey.tap()
        moreLettersKey.tap()
        element.childrenMatchingType(.TextView).element
        
        let hideKeyboardButton = app.buttons["Hide keyboard"]
        hideKeyboardButton.tap()
        
        let saveJournalEntryButton = app.buttons["Save Journal Entry"]
        saveJournalEntryButton.tap()
        
        let homeButton = tabBarsQuery.buttons["Home"]
        homeButton.tap()
        
        let textView2 = app.otherElements["Home"].childrenMatchingType(.TextView).element
        textView2.tap()
        hideKeyboardButton.tap()
        journalsButton.tap()
        addButton.tap()
        textView.tap()
        element.childrenMatchingType(.TextView).element
        hideKeyboardButton.tap()
        saveJournalEntryButton.tap()
        homeButton.tap()
        textView2.tap()
        hideKeyboardButton.tap()
        journalsButton.tap()
        journalsNavigationBar.buttons["Edit"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.buttons["Delete Tuesday, June 14, 2016, Tuesday, June 14, 2016 : this is another entry"].tap()
        tablesQuery.buttons["Delete"].tap()
        journalsNavigationBar.buttons["Done"].tap()
        homeButton.tap()
        textView2.tap()
        hideKeyboardButton.tap()
        
    }
    
}
