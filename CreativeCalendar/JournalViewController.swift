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
    var date = NSDate()
    let dateFormat = NSDateFormatter()
    var currentDate: String = ""
    var journalText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalLabel.text = "Make a Journal Entry"
        journalLabel.textColor = UIColor.whiteColor()
        dateFormat.dateStyle = NSDateFormatterStyle.FullStyle
        currentDate = dateFormat.stringFromDate(date)
        journalTextBox.text = "\(currentDate) : "
        journalTextBox.delegate = self
        let nav = self.navigationController?.navigationBar
        let barColor = UIColor(red:0.90, green:0.93, blue:0.98, alpha:1.00)
        nav?.barTintColor = barColor
        nav?.tintColor = UIColor.blueColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        journalText = textView.text
//        print("Text View Did End Editing")
//        print(journalText)
    }

    
    // When the save button is clicked pass the information to a journal item.
    @IBAction func saveJournalEntryIsPressed(sender: AnyObject) {
        date = NSDate()
        dateFormat.dateFormat = "EEEE, MMMM dd, yyyy - hh:mm:ss"
        let currentDate = dateFormat.stringFromDate(date)
        journalText = journalTextBox.text
        
        let journalItem = JournalItem(journal: journalText, UUID: NSUUID().UUIDString, date: currentDate)
//        JournalItemList.sharedInstance.addItem(journalItem)
        
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
