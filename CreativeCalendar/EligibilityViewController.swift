//
//  EligibilityViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/27/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit
import ResearchKit

class EligibilityViewController: UIViewController, ORKTaskViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let step: ORKInstructionStep = ORKInstructionStep.init(identifier: "EligibilitySurvey")
        step.title = "Selection Survey"
        step.text = "This survey will help us understand whether or not you are eligible to participate in this study."

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
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
