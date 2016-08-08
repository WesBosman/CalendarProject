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
    private var date = NSDate()
    private let dateFormat = NSDateFormatter().journalFormat
    private var journalText:String = String()
    @IBOutlet weak var saveJournal: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalTextBox.delegate = self
        journalLabel.text = "Make a Journal Entry"
        journalLabel.textColor = UIColor.whiteColor()
        let currentDateAsString = dateFormat.stringFromDate(date)
        journalTextBox.text = "\(currentDateAsString) : "
        
        // Navigation bar
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor().navigationBarColor
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blueColor()
        
        // Set up background gradient
        let background = CAGradientLayer().makeGradientBackground()
        background.frame = self.view.bounds
        self.view.layer.insertSublayer(background, atIndex: 0)
        
        // Set up the Save Journal Button colors and border
        saveJournal.layer.cornerRadius = 10
        saveJournal.layer.borderWidth = 2
        saveJournal.layer.borderColor = UIColor.whiteColor().CGColor
        saveJournal.setTitleColor(UIColor().defaultButtonColor, forState: .Normal)
        saveJournal.backgroundColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        journalText = textView.text
    }

    
    // When the save button is clicked pass the information to a journal item.
    @IBAction func saveJournalEntryIsPressed(sender: AnyObject) {
        date = NSDate()
        journalText = journalTextBox.text
        let journalItem = JournalItem(journal: journalText, UUID: NSUUID().UUIDString, date: date, deleted: false, deleteReason: nil)
        let db = DatabaseFunctions.sharedInstance
        db.addToJournalDatabase(journalItem)
        self.navigationController?.popViewControllerAnimated(true)
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
