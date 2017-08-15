//
//  JournalItem.swift
//  CreativeCalendar
//
//  Created by Wes on 5/18/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//


// Want to make global structures instead of pulling info from database all the time
struct JournalStructures{
    static var journalDictionary: Dictionary<String, [JournalItem]> = [:]
    static var journalSections: [String] = []
    static var journalItems: [JournalItem] = []
}

// Class for manipulating global structs
class Journals{
//    static var journalDictionary: Dictionary<String, [JournalItem]> = [:]
//    static var journalSections: [String] = []
//    fileprivate var journalItems: [JournalItem] = []
    fileprivate let db = DatabaseFunctions.sharedInstance
    fileprivate let journalDateFormatter = DateFormatter().dateWithoutTime
    
    
    // Get the Journals from the database and store them in a dictionary
    func setUpJournalDictionary(){
        // This is an expensive task to constantly hit the database
        JournalStructures.journalItems = db.getAllJournals()
        
        // Sort the journals based on their dates
        JournalStructures.journalItems = JournalStructures.journalItems.sorted(by: {
            $0.journalDate.compare($1.journalDate) == ComparisonResult.orderedAscending
        })
    
        for journal in JournalStructures.journalItems{
            let journalDate = journalDateFormatter.string(from: journal.journalDate)
    
            // If the journal sections array does not contain the date then add it
            if(!JournalStructures.journalSections.contains(journalDate)){
                JournalStructures.journalSections.append(journalDate)
            }
        }
    
        for section in JournalStructures.journalSections{
            // Get journal items based on the date
            JournalStructures.journalItems = db.getJournalByDate(section, formatter: journalDateFormatter)
    
            // Set the table view controllers dictionary
            JournalStructures.journalDictionary.updateValue(JournalStructures.journalItems, forKey: section)
        }
    }
    
    
    // Add the Journal to the Dictionary
    func addJournalToGlobalDictionary(item: JournalItem){
        let journalStringDate = journalDateFormatter.string(from: item.journalDate)
        print("Journal String Date -> \(journalStringDate)")
        
        // If there is not already a section in the dictionary for that date create one
        if !(JournalStructures.journalSections.contains(journalStringDate)){
            print("Journal date IS NOT already in the dictionary")
            
            JournalStructures.journalSections.append(journalStringDate)
            
            var journalArray: [JournalItem] = []
            journalArray.append(item)
            
            JournalStructures.journalDictionary.updateValue(journalArray, forKey: journalStringDate)
            
        }
        // Otherwise update an existing array
        else{
            print("Journal date IS already in the dictionary")
            
            var journalArray: [JournalItem] = JournalStructures.journalDictionary[journalStringDate]!
            journalArray.append(item)
            JournalStructures.journalDictionary.updateValue(journalArray, forKey: journalStringDate)
            
        }
    }
    
    
    // Update the journal in the Dictionary
    func updateJournalFromGlobalDictionary(item: JournalItem){
        let journalStringDate = journalDateFormatter.string(from: item.journalDate)
        print("Journal String Date -> \(journalStringDate)")
        var journalArray = JournalStructures.journalDictionary[journalStringDate]
        
        // Find the index of the journal in the dictionary 
        if let found = journalArray?.index(where: {$0.journalUUID == item.journalUUID}){
            print("Found Journal in the dictionary")
            journalArray?.insert(item, at: found)
        }
        
        // Update the dictionary
        JournalStructures.journalDictionary.updateValue(journalArray!, forKey: journalStringDate)
    }
    
    
    // Remove the journal from the Dictionary
    func removeJournalFromGlobalDictionary(item: JournalItem){
        let dictionaryKey = DateFormatter().journalFormat.string(from: item.journalDate)
        let journalArray = JournalStructures.journalDictionary[dictionaryKey]
        
        // If a journal array exists for a given key then remove it
        if var journalArray = journalArray{
            if let found = journalArray.index(where: {$0.journalUUID == item.journalUUID}){
                journalArray.remove(at: found)
                JournalStructures.journalDictionary.updateValue(journalArray, forKey: dictionaryKey)
            }
        }
    }
}

class JournalItem {
    var journalDate: Date    = Date()
    var journalTitle: String = String()
    var journalEntry: String = String()
    var journalDeleted: Bool
    var journalDeletedReason:  String?
    var journalUUID: String  = String()
    let dateFormat = DateFormatter().journalFormat
    
    init(dateCreated: Date,
         journalTitle: String,
         journal: String,
         deleted: Bool,
         deleteReason:String?,
         UUID: String){
        self.journalDate    = dateCreated
        self.journalTitle   = journalTitle
        self.journalEntry   = journal
        self.journalDeleted = deleted
        self.journalDeletedReason = deleteReason
        self.journalUUID    = UUID
    }
    
//    var description: String {
//        return "\nCreated Date = \(self.journalDate)\nJournal Title = \(self.journalTitle)\nJournal = \(self.journalEntry)\nDeleted = \(self.journalDeleted)\nDeleted Reason = \(self.journalDeletedReason)\nUUID = \(self.journalUUID)\n"
//    }
    
    // Get a simplified date that does not contain the hours and seconds
//    func getSimplifiedDate() -> String{
//        let journalStringForDate = dateFormat.string(from: journalDate)
//        return journalStringForDate
//    }
}


