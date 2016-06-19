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
    var journalEntry: String = ""
    var journalUUID: String = ""
    var journalDate: String = ""
    
    init(journal: String, UUID: String, date: String){
        self.journalEntry = journal
        self.journalUUID = UUID
        self.journalDate = date
    }
    
    // Get a simplified date that does not contain the hours and seconds
    func getSimplifiedDate() -> String{
        var newMatchDate:String
        if let range = journalDate.characters.indexOf("-"){
            newMatchDate = self.journalDate.substringToIndex(range)
            print("New Match Date: \(newMatchDate)")
            return newMatchDate
        }
        else{
            return ""
        }
    }
}