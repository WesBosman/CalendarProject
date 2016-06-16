//
//  CreativeCalendarUITests.swift
//  CreativeCalendarUITests
//
//  Created by Wes Bosman on 6/14/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import XCTest

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
    
    func testAppointments(){
        
        let app = XCUIApplication()
        app.tabBars.buttons["Appointments"].tap()
        app.navigationBars["Appointments"].buttons["Add"].tap()
        
        app.tables.cells.textFields["Name of Appointment"].tap()
        app.tables.childrenMatchingType(.Cell).elementBoundByIndex(0).childrenMatchingType(.TextField).element
        app.keyboards.buttons["Hide keyboard"].tap()
        
        let tablesQuery = XCUIApplication().tables
        tablesQuery.pickerWheels["Family"].tap()
        tablesQuery.pickerWheels["Doctor"].tap()
        tablesQuery.pickerWheels["Recreational"].tap()
        tablesQuery.pickerWheels["Exercise"].tap()
        tablesQuery.pickerWheels["Medications times"].tap()
        tablesQuery.pickerWheels["Social Event"].tap()
        tablesQuery.pickerWheels["Leisure"].tap()
        tablesQuery.pickerWheels["Household"].tap()
        tablesQuery.textFields["Please enter the type of appointment"].tap()
        tablesQuery.cells.containingType(.Button, identifier:"Enter").childrenMatchingType(.TextField).element
        tablesQuery.buttons["Enter"].tap()
        
        
//        let tablesQuery1 = XCUIApplication().tables
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(5).pickerWheels["28 minutes"].tap()
        tablesQuery.pickerWheels["30 minutes"].tap()
        
        
//        let tablesQuery2 = XCUIApplication().tables
        tablesQuery.pickerWheels["28 minutes"].tap()
        tablesQuery.pickerWheels["30 minutes"].tap()
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(7).pickerWheels["32 minutes"].tap()
        
        
//        let app = XCUIApplication()
//        let tablesQuery = app.tables
        tablesQuery.textFields["Location of Appointment"].tap()
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(8).childrenMatchingType(.TextField).element
        
        let cell = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(9)
        cell.childrenMatchingType(.TextView).element.tap()
        cell.childrenMatchingType(.TextView).element
        app.buttons["Hide keyboard"].tap()
        tablesQuery.buttons["Save Appointment"].tap()
        
        let tabBarsQuery = app.tabBars
        let homeButton = tabBarsQuery.buttons["Home"]
        homeButton.tap()
        
        let appointmentsButton = tabBarsQuery.buttons["Appointments"]
        appointmentsButton.tap()
        
        let appointmentsNavigationBar = app.navigationBars["Appointments"]
        appointmentsNavigationBar.buttons["Edit"].tap()
        tablesQuery.buttons["Delete Event: name of appointment, Starting Time:  Jun 14 at 3:32 PM, Ending Time:   Jun 14 at 3:34 PM, Location:        south grace street, Additional Info: Bring wallet"].tap()
        
        let deleteButton = tablesQuery.buttons["Delete"]
        deleteButton.tap()
        appointmentsNavigationBar.buttons["Done"].tap()
        homeButton.tap()
        appointmentsButton.tap()
        
        let ipadElement = app.statusBars.otherElements["iPad"]
        ipadElement.tap()
        tablesQuery.buttons["Delete Event: name of app, Starting Time:  Jun 13 at 11:45 PM, Ending Time:   Jun 13 at 11:49 PM, Location:        lock of app, Additional Info: Add info app"].tap()
        deleteButton.tap()
        ipadElement.tap()
        homeButton.tap()
        
        
        
        
    }
    
    func testTasks() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Appointments"].tap()
        tabBarsQuery.buttons["Tasks"].tap()
        
        let tasksNavigationBar = app.navigationBars["Tasks"]
        tasksNavigationBar.buttons["Add"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.textFields["Task Name"].tap()
        
        let cell = tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(0)
        cell.childrenMatchingType(.TextField).element
        app.buttons["Return"].tap()
        cell.childrenMatchingType(.TextField).element
        
        let hideKeyboardButton = app.buttons["Hide keyboard"]
        hideKeyboardButton.tap()
        tablesQuery.textFields["Additional Information"].tap()
        tablesQuery.childrenMatchingType(.Cell).elementBoundByIndex(1).childrenMatchingType(.TextField).element
        hideKeyboardButton.tap()
        
        let saveTaskButton = tablesQuery.buttons["Save Task"]
        saveTaskButton.tap()
        tasksNavigationBar.buttons["Edit"].tap()
        tablesQuery.buttons["Delete Event: Aston Martin music, Additional Info: Rick Ross"].tap()
        
        let deleteButton = tablesQuery.buttons["Delete"]
        deleteButton.tap()
        tablesQuery.buttons["Delete Event: task title, Additional Info: task info"].tap()
        deleteButton.tap()
        tasksNavigationBar.buttons["Done"].tap()
        tabBarsQuery.buttons["Home"].tap()
        
        let nameOfTaskStaticText = app.tables.staticTexts["name of task"]
        nameOfTaskStaticText.tap()
        
        let collectionViewsQuery = app.alerts["Hello"].collectionViews
        let yesButton = collectionViewsQuery.buttons["yes"]
        yesButton.tap()
        nameOfTaskStaticText.tap()
        
        let noButton = collectionViewsQuery.buttons["no"]
        noButton.tap()
        noButton.tap()
        app.tables.staticTexts["example task"].tap()
        yesButton.tap()
        app.tables.staticTexts["do this thing"].tap()
        noButton.tap()
        noButton.tap()
        
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
