//
//  TabViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/5/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//
import UIKit


class JournalViewController: UIViewController, UITextViewDelegate {

    // Text box for user to enter journal enteries
    @IBOutlet weak var journalTextBox: UITextView!
    @IBOutlet weak var journalLabel: UILabel!
    fileprivate var date = Date()
    fileprivate let dateFormat = DateFormatter().journalFormat
    var journalText:String = String()
    var journalItemToEdit:JournalItem? = nil
    let db = DatabaseFunctions.sharedInstance
    @IBOutlet weak var saveJournal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTextBox.delegate = self
        journalLabel.text = "Make a Journal Entry"
        journalLabel.textColor = UIColor.white
        
        if journalItemToEdit != nil{
            journalTextBox.text = journalItemToEdit?.journalEntry
        }
        else{
            let currentDateAsString = dateFormat.string(from: date)
            journalTextBox.text = "\(currentDateAsString) : "
        }
        
        // Navigation bar
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blue
        
        // Set up background gradient
        let background = CAGradientLayer().makeGradientBackground()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
        // Set up the Save Journal Button colors and border
        saveJournal.layer.cornerRadius = 10
        saveJournal.layer.borderWidth = 2
        saveJournal.layer.borderColor = UIColor.white.cgColor
        saveJournal.setTitleColor(UIColor().defaultButtonColor, for: UIControlState())
        saveJournal.backgroundColor = UIColor.white
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidChange(_ textView: UITextView) {
        journalText = textView.text
    }
    
    // When the save button is clicked pass the information to a journal item.
    @IBAction func saveJournalEntryIsPressed(_ sender: AnyObject) {
        
        // The date format that works with the global journal dictionary
        let newDateFormat = DateFormatter().dateWithoutTime
        
        
        // Journal Item is already in the database just update it
        if let journalItem = journalItemToEdit{
            print("Journal Text \(journalText)")
            print("Journal Item To Edit is not null")
            
            journalItem.journalEntry = journalText
            db.updateJournal(journalItem, option: "edit")
            
            // Add the item to the global dictionary
            let journalDate = newDateFormat.string(from: journalItem.journalDate)
            var journalArray = GlobalJournalStructures.journalDictionary[journalDate]
            
            if let found = journalArray?.index(where: {$0.journalUUID == journalItem.journalUUID}){
                print("Found: \(found)")
                journalArray?.insert(journalItem, at: found)
            }
//            GlobalJournalStructures.journalDictionary.updateValue(journalArray!, forKey: journalDate)
        }
            
        // Else Add a new Journal Item
        else{
            print("Journal Item to Edit is null")
            print("Journal Text: \(journalText)")
            
            let journalItem = JournalItem(date: Date(),
                                          journal: journalText,
                                          deleted: false,
                                          deleteReason: nil,
                                          UUID: UUID().uuidString)
            
            db.addToJournalDatabase(journalItem)
            
            // Get the key and value from the dictionary
            let journalDate = newDateFormat.string(from: journalItem.journalDate)
            var journalArray = GlobalJournalStructures.journalDictionary[journalDate]
            print("Journal Date: \(journalDate)")
            print("Journal Array: \(journalArray)")
            
            // Add the journal item to the Global Dictionary
            // If the journal array we get from the dictionary is nil
            // Create it
            if journalArray == nil{
                var journalArray:[JournalItem] = []
                journalArray.append(journalItem)
                GlobalJournalStructures.journalSections.append(journalDate)
                GlobalJournalStructures.journalDictionary.updateValue(journalArray, forKey: journalDate)
            }
            else{
                journalArray?.append(journalItem)
                GlobalJournalStructures.journalDictionary.updateValue(journalArray!, forKey: journalDate)
            }
            
        }
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
