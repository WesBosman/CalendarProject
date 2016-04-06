//
//  TabViewController.swift
//  CreativeCalendar
//
//  Created by Wes on 2/5/16.
//  Copyright (c) 2016 Wes Bosman. All rights reserved.
//

import UIKit

class JournalViewController: UIViewController {

    // Label that says type
    @IBOutlet weak var journalType: UILabel!
    // Picker that displays the same info from add appointment page
    @IBOutlet weak var journalPicker: UIPickerView!
    // Text box for user to enter journal enteries
    @IBOutlet weak var journalTextBox: UITextView!
    
    var journalData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        journalData = ["Diet", "Doctor", "Exercise", "Household Chores", "Mediction", "Leisure", "Project", "Self Care", "Social", "Travel"]
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
