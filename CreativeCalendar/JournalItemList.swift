//
//  JournalItemList.swift
//  CreativeCalendar
//
//  Created by Wes on 5/20/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import Foundation
import UIKit
// Global singleton declaration so this class can be instantiated only once
private let sharedJournalList = JournalItemList()

class JournalItemList{
    private let JOURNAL_KEY = "journalItems"
    // New singleton code
    static let sharedInstance = sharedJournalList

    // Add item to the dictionary
    // I think the key for the journal entry should be the date 
    // so we can get the entry based on what day it is
    func addItem(item: JournalItem){
        // Create the dictionary object to hold journal item objects
        var journalDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(JOURNAL_KEY) ?? Dictionary()
        
        journalDictionary[item.journalDate] = ["journal" : item.journalEntry,
                                               "UUID" : item.journalUUID,
                                               "date" : item.journalDate]
        
        //print("Journal Keys: \(journalDictionary.keys) Journal Values: \(journalDictionary.values)")
        
        // Save or Overwrite information in the dictionary
        NSUserDefaults.standardUserDefaults().setObject(journalDictionary, forKey: JOURNAL_KEY)

    }
    
    // remove a journal item
    func removeItem(item: JournalItem){

        if var journals = NSUserDefaults.standardUserDefaults().dictionaryForKey(JOURNAL_KEY){
            journals.removeValueForKey(item.journalUUID)
            // Save item
            NSUserDefaults.standardUserDefaults().setObject(journals, forKey: JOURNAL_KEY)
        }
    }
    
    func getTodaysJournals(date:String) {
        let journalDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(JOURNAL_KEY) ?? [:]
        let todays_journals = journalDictionary[date]
        print("Todays Journals: \(todays_journals)")
    }
    
    func removeAllJournals() {
        var journalDictionary = NSUserDefaults.standardUserDefaults().dictionaryForKey(JOURNAL_KEY) ?? [:]
        journalDictionary.removeAll()
    }
    
    // Return items for the user to see in the table view
    func allJournals() -> [JournalItem] {
        let journalDict = NSUserDefaults.standardUserDefaults().dictionaryForKey(JOURNAL_KEY) ?? [:]
        // Use the key to get the journal items out of the dictionary
        let journal_items = Array(journalDict.values)
        //print("All journals is not being saved throughout multiple instances of the application.")
        //print("All Journal Items \(journal_items)")
        return journal_items.map({JournalItem(journal: $0["journal"] as! String,
                                                 UUID: $0["UUID"] as! String,
                                                 date: $0["date"] as! String)})
        
    }
}