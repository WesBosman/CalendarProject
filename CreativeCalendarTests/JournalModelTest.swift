//
//  AppointmentModelTest.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 12/24/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import XCTest

@testable import CreativeCalendar

class JournalModelTest: XCTestCase {
    let sut = GlobalJournals()
    let date = Date()
    let calendar = Calendar.current
    let dateComp = DateComponents()
    let dateformat = DateFormatter().dateWithoutTime
    let journalEntry = "This is a Unit test of a Journal Entry"
    var journalOne: JournalItem? = nil
        
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let dateAsString = dateformat.string(from: date)
        print("Set up Journal By Adding a Journal for Today's date \(dateAsString)")
        let journalItemForTesting = JournalItem(date: date,
                                                journal: "To Help With Testing",
                                                deleted: false,
                                                deleteReason: nil,
                                                UUID: UUID().uuidString)
        journalOne = journalItemForTesting
        print("Journal Item -> \(journalItemForTesting)")
        sut.addJournalToGlobalDictionary(item: journalItemForTesting)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func printJournalDictionary(){
        for (key, value) in GlobalJournalStructures.journalDictionary{
            print("Journal Key == \(key) \nJournal Item == \(value)")
        }
    }
    
    // Do I really need a get simplified date in the journal item???
    // Probably not
    func testJournalGetSimplifiedDate(){
        if let journalOne = journalOne{
            let journalDate = journalOne.getSimplifiedDate()
            XCTAssert(journalDate == DateFormatter().journalFormat.string(from: journalOne.journalDate))
        }
    }
    
    func testSetUpJournalDictionary(){
        sut.setUpJournalDictionary()
        print("")
        print("Journal Dictionary after calling set up")
        print("")
        printJournalDictionary()
    }
    
    // Add a journal to the global dictionary when the dictionary does already contain that key
    // Does not add item to the database YET
    func testAddJournalToDictionary_WhenKeyIsInDictionary(){
        print("")
        print("TEST ADD JOURNAL TO DICT WHILE KEY IS PRESENT")
        printJournalDictionary()
        
        // A date an hour in the future
        let newDate = calendar.date(byAdding: .hour, value: 1, to: date)!
        let newStringDate = dateformat.string(from: newDate)
        let journalItem = JournalItem(date: newDate,
                                      journal: journalEntry,
                                      deleted: false,
                                      deleteReason: nil,
                                      UUID: UUID().uuidString)
        sut.addJournalToGlobalDictionary(item: journalItem)
        let journalArray = GlobalJournalStructures.journalDictionary[newStringDate]
        XCTAssert(journalArray!.contains(where: {$0.journalUUID == journalItem.journalUUID} ))
        
        printJournalDictionary()
    }
    
    // Add a journal to the global dictionary that doesn't have a key that exists in the dictionary
    // This does not add the item to the database YET
    func testAddJournalToDictionary_WhenKeyIsNotInDictionary(){
        print("")
        print("TEST ADD KEY TO DICT WHEN KEY IS NOT PRESENT")
        printJournalDictionary()
        
        let newDate = calendar.date(byAdding: .month, value:1, to: date)!
        let newStringDate = dateformat.string(from:newDate)
        let journalItem = JournalItem(date:newDate,
                                      journal:"Key not in dict",
                                      deleted: false,
                                      deleteReason: nil,
                                      UUID: UUID().uuidString)
        // Add the journal and assert that it made it to the dictionary
        sut.addJournalToGlobalDictionary(item: journalItem)
        let journalArray = GlobalJournalStructures.journalDictionary[newStringDate]
        XCTAssert(journalArray!.contains(where: {$0.journalUUID == journalItem.journalUUID}))
        
        printJournalDictionary()
    }
    
    func testUpdateJournalFromGlobalDictionary_WhenKeyIsNotInDictionary(item: JournalItem){
        print("")
        print("TEST UPDATE JOURNAL IN DICT WHEN KEY IS NOT PRESENT")
        printJournalDictionary()
        
        // 2 Months ahead the key should not exist
        let newDate = calendar.date(byAdding: .month, value: 2, to: date)!
        let entryBefore = "Test Update Journal in Global Dictionary when Key DNE"
        let entryAfter  = "Edited the Test Journal when the key DNE"
        let newStringDate = dateformat.string(from: newDate)
        let journalItem = JournalItem(date: newDate,
                                      journal: entryBefore,
                                      deleted: false,
                                      deleteReason: nil,
                                      UUID: UUID().uuidString)
        // Add the Journal
        sut.addJournalToGlobalDictionary(item: journalItem)
        
        // Test that the journal is there 
        var journalArray = GlobalJournalStructures.journalDictionary[newStringDate]
        XCTAssert(journalArray!.contains(where: {$0.journalEntry == entryBefore}))

        // Edit the Journal
        journalItem.journalEntry = "Edited the Test Journal when key DNE"
        
        // Update the Journal
        sut.updateJournalFromGlobalDictionary(item: journalItem)
        journalArray = GlobalJournalStructures.journalDictionary[newStringDate]
        XCTAssert(journalArray!.contains(where: {$0.journalEntry == entryAfter}))
        
        printJournalDictionary()
    }
    
    func testUpdateJournalFromGlobalDictionary_WhenKeyIsInDictionary(){
        print("")
        print("TEST UPDATE JOURNAL IN DICT WHEN KEY IS PRESENT")
        let newDate = calendar.date(byAdding: .hour, value: 2, to: date)!
        let entryBefore = "Entry before updating global dict when key is in dict"
        let entryAfter  = "Entry after updating global dict when key is in dict"
        let newStringDate = dateformat.string(from: newDate)
        var journalToUpdate = JournalItem(date: newDate,
                                          journal: entryBefore,
                                          deleted: false,
                                          deleteReason: nil,
                                          UUID: UUID().uuidString)
        // Print the journal dictionary before adding to it
        printJournalDictionary()
        // Add Journal to Dictionary
        sut.addJournalToGlobalDictionary(item: journalToUpdate)
        // Test that the journal was added
        var journalArray = GlobalJournalStructures.journalDictionary[newStringDate]
        XCTAssert(journalArray!.contains(where: {$0.journalUUID == journalToUpdate.journalUUID && $0.journalEntry == entryBefore}))
        journalToUpdate.journalEntry = entryAfter
        // Update the item in the Dictionary
        sut.updateJournalFromGlobalDictionary(item: journalToUpdate)
        journalArray = GlobalJournalStructures.journalDictionary[newStringDate]
        // Print the Dictionary
        printJournalDictionary()
        // Test that the updated journal entry is in the dictionary with the same uuid
        XCTAssert(journalArray!.contains(where: {$0.journalEntry == entryAfter && $0.journalUUID == journalToUpdate.journalUUID}))
        
    }
    
    func testRemoveJournalFromGlobalDictionary(){
        print("")
        print("TESTING REMOVE JOURNAL FROM GLOBAL DICTIONARY")
        print("Try removing the journal that was added in the setup method")
        if let journalOne = journalOne{
            let journalStringDate = DateFormatter().string(from: journalOne.journalDate)
            sut.removeJournalFromGlobalDictionary(item: journalOne)
            XCTAssert(GlobalJournalStructures.journalDictionary[journalStringDate] == nil)
        }
        
    }
}
