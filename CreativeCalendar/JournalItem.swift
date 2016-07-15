//
//  JournalItem.swift
//  CreativeCalendar
//
//  Created by Wes on 5/18/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//
//  Very basic class for holding a journal item.

import Foundation

class JournalItem{
    var journalEntry: String = String()
    var journalUUID: String = String()
    var journalDate: NSDate = NSDate()
    
    init(journal: String, UUID: String, date: NSDate){
        self.journalEntry = journal
        self.journalUUID = UUID
        self.journalDate = date
    }
    
    // Get a simplified date that does not contain the hours and seconds
    func getSimplifiedDate() -> String{
        let dateFormat = NSDateFormatter()
        dateFormat.dateFormat = "EEEE, MMMM dd, yyyy"
        let journalStringForDate = dateFormat.stringFromDate(journalDate)
        print("Journal String For Date: \(journalStringForDate)")
        return journalStringForDate
    }
}