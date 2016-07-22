//
//  PopoverViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/20/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit

class PopoverViewController: UIViewController {
    @IBOutlet weak var appointmentPopoverLabel: UILabel!
    @IBOutlet weak var taskPopoverLabel: UILabel!
    @IBOutlet weak var journalPopoverLabel: UILabel!
    var appointmentLabel:String = String()
    var taskLabel:String = String()
    var journalLabel:String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        appointmentPopoverLabel.text = appointmentLabel
        taskPopoverLabel.text = taskLabel
        journalPopoverLabel.text = journalLabel
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
