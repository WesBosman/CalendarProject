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
    let newDateFormat = DateFormatter().dateWithoutTime
    var journalTitle: String = String()
    var journalText:String = String()
    var journalItemToEdit:JournalItem? = nil
    let db = DatabaseFunctions.sharedInstance
    
    @IBOutlet weak var journalTitleTextField: UITextField!
    @IBOutlet weak var saveJournalNavBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTextBox.delegate = self
        journalLabel.text = "Make a Journal Entry"
        journalLabel.textColor = UIColor.white
        
        if journalItemToEdit != nil{
            journalTitleTextField.text = journalItemToEdit?.journalTitle
            journalTextBox.text = journalItemToEdit?.journalEntry
        }
        else{
            journalTextBox.text = "Journal Entry : "
            journalTextBox.textColor = UIColor.lightGray
        }
                
        // Set up background gradient
        let background = CAGradientLayer().makeGradientBackground()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, at: 0)
        
    }
    
    @IBAction func saveButtonInNavBarPressed(_ sender: AnyObject) {
        print("Save button pressed in navigation bar")
        
        // Journal Item is already in the database just update it
        if let journalItem = journalItemToEdit{
            print("Journal Text \(journalText)")
            
            // Should I also update the time when I update the journal entry?
            journalItem.journalTitle = journalTitleTextField.text!
            journalItem.journalEntry = journalText
            db.updateJournal(journalItem, option: "edit")
            
            // Add the item to the global dictionary
            let journalDate = newDateFormat.string(from: journalItem.journalDate)
            var journalArray = JournalStructures.journalDictionary[journalDate]
            
            if let found = journalArray?.index(where: {$0.journalUUID == journalItem.journalUUID}){
                print("Found: \(found)")
                journalArray?.insert(journalItem, at: found)
            }
            
            // Pop to previous view controller
            _ = self.navigationController?.popViewController(animated: true)
        }
            
            // Else Add a new Journal Item
        else{
            print("Journal Item to Edit is null")
            print("Journal Text: \(journalText)")
            
            if journalTitleTextField.text?.isEmpty == false &&
                journalTextBox.text != "Journal Entry : "   &&
                journalTextBox.text != nil {
                let journalTitle = journalTitleTextField.text!
                
                let journalItem = JournalItem(dateCreated: Date(),
                                              journalTitle: journalTitle,
                                              journal: journalText,
                                              deleted: false,
                                              deleteReason: nil,
                                              UUID: UUID().uuidString)
                
                db.addToJournalDatabase(journalItem)
                
                // Get the key and value from the dictionary
                let journalDate = newDateFormat.string(from: journalItem.journalDate)
                var journalArray = JournalStructures.journalDictionary[journalDate]
                print("Journal Date: \(journalDate)")
//                print("Journal Array: \(journalArray)")
                
                // Add the journal item to the Global Dictionary
                // If the journal array we get from the dictionary is nil
                // Create it
                if journalArray == nil{
                    var journalArray:[JournalItem] = []
                    journalArray.append(journalItem)
                    JournalStructures.journalSections.append(journalDate)
                    JournalStructures.journalDictionary.updateValue(journalArray, forKey: journalDate)
                }
                else{
                    journalArray?.append(journalItem)
                    JournalStructures.journalDictionary.updateValue(journalArray!, forKey: journalDate)
                }
                // Only pop to the previous view controller in the case that
                // The text fields are correctly filled
                _ = self.navigationController?.popViewController(animated: true)
                
            }
            else{
                print("Journal Text Field Should be empty")
                let alertController = UIAlertController(title: "Alert", message: "A Journal must have a Title and a Journal Entry in order to be saved", preferredStyle: .alert)
                let dismissAction   = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
                alertController.addAction(dismissAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if journalTextBox.text == "Journal Entry : "{
            journalTextBox.text = nil
        }
        // The color of the journal entry should always be black easier to see
        journalTextBox.textColor = UIColor.black
    }
    
    func textViewDidChange(_ textView: UITextView) {
        journalText = textView.text
    }
}
