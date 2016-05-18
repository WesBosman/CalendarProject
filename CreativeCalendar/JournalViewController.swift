//
//  TabViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/5/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {

    // Text box for user to enter journal enteries
    @IBOutlet weak var journalTextBox: UITextView!
    @IBOutlet weak var journalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        journalLabel.text = "Make a Journal Entry"
        journalLabel.textColor = UIColor.whiteColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // When the save button is clicked pass the information to a journal item.
    @IBAction func saveJournalEntryIsPressed(sender: AnyObject) {
        let journalItem = JournalItem(journal: journalTextBox.text)
        //self.tabBarController?.popToRootViewControllerAnimated(true)
        //self.tabBarController?.presentViewController(HomeViewController(), animated: true, completion: nil)

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
