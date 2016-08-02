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
    var journalDeleted: Bool
    let dateFormat = NSDateFormatter().journalFormat
    
    init(journal: String, UUID: String, date: NSDate, deleted: Bool){
        self.journalEntry = journal
        self.journalUUID = UUID
        self.journalDate = date
        self.journalDeleted = deleted
    }
    
    // Get a simplified date that does not contain the hours and seconds
    func getSimplifiedDate() -> String{
        let journalStringForDate = dateFormat.stringFromDate(journalDate)
        return journalStringForDate
    }
}