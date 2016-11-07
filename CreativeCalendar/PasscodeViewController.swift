//
//  PasscodeViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 8/23/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit
import ResearchKit


class PasscodeViewController: ORKPasscodeViewController, ORKTaskViewControllerDelegate, ORKPasscodeDelegate {
    
    let passcodeStep:ORKPasscodeStep = ORKPasscodeStep.init(identifier: "PassCode")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passcodeStep.passcodeType = ORKPasscodeType.type4Digit
    }
    
    // Since this view gets presented modally do all the set up in the view did appear method
    override func viewDidAppear(_ animated: Bool) {
        let task: ORKOrderedTask = ORKOrderedTask.init(identifier: "PassCodeStep", steps: [passcodeStep])
        let controller: ORKTaskViewController = ORKTaskViewController.init(task: task, taskRun: nil)
        controller.delegate = self
        self.present(controller, animated: true, completion: nil)
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        taskViewController.dismiss(animated: true, completion: nil)
    }

    func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        print("Passcode authentication succeeded!")
    }
    
    func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
        print("Passcode authentication failed")
    }
    
    func passcodeViewControllerDidCancel(_ viewController: UIViewController) {
        print("Cancel button tapped")
    }
    
    func passcodeViewControllerForgotPasscodeTapped(_ viewController: UIViewController) {
        print("Forgot passcode tapped")
    }
    
    func passcodeViewControllerText(forForgotPasscode viewController: UIViewController) -> String {
        print("Text for forgotten password")
        return "Forgot Your Passcode?"
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
