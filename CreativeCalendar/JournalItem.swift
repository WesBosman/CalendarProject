//
//  JournalItem.swift
//  CreativeCalendar
//
//  Created by Wes on 5/18/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//


// These structures are global so that the database doesn't constantly have to be accessed
struct GlobalJournalStructures{
    static var journalHeightDictionary: Dictionary<Int, [Float]> = [:]
    static var journalDictionary: Dictionary<String, [JournalItem]> = [:]
    static var journalSections: [String] = []
    static var journalItems: [JournalItem] = []
    static var journalHeightArray: [Float] = []
}

class GlobalJournals{
    private let db = DatabaseFunctions.sharedInstance
    private let journalDateFormatter = NSDateFormatter().dateWithoutTime
    
    func setUpJournalDictionary(){
        GlobalJournalStructures.journalItems = db.getAllJournals()
        
        // Sort the journals based on their dates
        GlobalJournalStructures.journalItems = GlobalJournalStructures.journalItems.sort({$0.journalDate.compare($1.journalDate) == NSComparisonResult.OrderedAscending})
    
        for journal in GlobalJournalStructures.journalItems{
            let journalDate = journalDateFormatter.stringFromDate(journal.journalDate)
    
            // If the journal sections array does not contain the date then add it
            if(!GlobalJournalStructures.journalSections.contains(journalDate)){
                GlobalJournalStructures.journalSections.append(journalDate)
            }
        }
    
        for section in GlobalJournalStructures.journalSections{
            // Get journal items based on the date
            GlobalJournalStructures.journalItems = db.getJournalByDate(section, formatter: journalDateFormatter)
    
            // Set the table view controllers dictionary
            GlobalJournalStructures.journalDictionary.updateValue(GlobalJournalStructures.journalItems, forKey: section)
        }
    }
}

class JournalItem{
    var journalEntry: String = String()
    var journalUUID: String = String()
    var journalDate: NSDate = NSDate()
    var journalDeleted: Bool
    var journalDeletedReason: String?
    let dateFormat = NSDateFormatter().journalFormat
    
    init(journal: String, UUID: String, date: NSDate, deleted: Bool, deleteReason:String?){
        self.journalEntry = journal
        self.journalUUID = UUID
        self.journalDate = date
        self.journalDeleted = deleted
        self.journalDeletedReason = deleteReason
    }
    
    // Get a simplified date that does not contain the hours and seconds
    func getSimplifiedDate() -> String{
        let journalStringForDate = dateFormat.stringFromDate(journalDate)
        return journalStringForDate
    }
}