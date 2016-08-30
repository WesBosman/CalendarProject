//
//  ConsentViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 7/27/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit
import ResearchKit

public var consentForm: ORKConsentDocument{
    let consentForm = ORKConsentDocument()
    consentForm.title = "Consent Form"
    
    // Consent Sections
    let consentSectionTypes: [ORKConsentSectionType] = [
        .Overview,
        .DataGathering,
        .Privacy,
        .DataUse,
        .TimeCommitment,
        .StudySurvey,
        .StudyTasks,
        .Withdrawing
    ]
    
    let consentSections: [ORKConsentSection] = consentSectionTypes.map { contentSectionType in
        let consentSection = ORKConsentSection(type: contentSectionType)
        consentSection.summary = "If you wish to complete this study..."
        consentSection.content = "In this study you will be asked five (wait, no, three!) questions. You will also have your voice recorded for ten seconds."
        return consentSection
    }
    
    consentForm.sections = consentSections
    
    // Consent Signature
    consentForm.addSignature(ORKConsentSignature(forPersonWithTitle: nil, dateFormatString: nil, identifier: "ConsentDocumentParticipantSignature"))
    
    return consentForm
}

public var Consent: ORKOrderedTask {
    
    var steps = [ORKStep]()
    
    // Consent Visual Step
    let consentDocument = consentForm
    let visualConsentStep = ORKVisualConsentStep(identifier: "VisualConsentStep", document: consentDocument)
    steps += [visualConsentStep]
    
    //Consent Review Step
    let signature = consentDocument.signatures!.first! as ORKConsentSignature
    
    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, inDocument: consentDocument)
    
    reviewConsentStep.text = "Review Consent!"
    reviewConsentStep.reasonForConsent = "Consent to join study"
    
    steps += [reviewConsentStep]
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}


class ConsentViewController: UIViewController, ORKTaskViewControllerDelegate, ORKPasscodeDelegate {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    let defaultsConsentKey = "UserConsent"
    let loginKey = "UserLogin"
    let forgotLoginKey = "UserForgotLogin"
    let passcodeStep:ORKPasscodeStep = ORKPasscodeStep.init(identifier: "PassCode")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        clearAllUserDefaults()
        
        // Do any additional setup after loading the view.
        passcodeStep.passcodeType = ORKPasscodeType.Type4Digit
        startButton.hidden = true
        headingLabel.numberOfLines = 0
        headingLabel.lineBreakMode = .ByWordWrapping
        greetingLabel.hidden = true
        greetingLabel.lineBreakMode = .ByWordWrapping
        greetingLabel.numberOfLines = 0
        greetingLabel.text = "Thank you for completing the consent form for this study.\nPlease press the start button to enter the application."
        startButton.layer.cornerRadius = 30
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor().defaultButtonColor.CGColor
        startButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        startButton.backgroundColor = UIColor().defaultButtonColor
        // Make the user login everytime they enter the application
        defaults.removeObjectForKey(loginKey)
    }
    
    // Clear all NSUser Defaults
    func clearAllUserDefaults(){
        //The below two lines of code can clear out NSUser Defaults
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
    }
    
    override func viewDidAppear(animated: Bool) {
        // Print the values of stored login booleans
        print("defaults bool for key: UserConsent -> \(defaults.boolForKey(defaultsConsentKey))")
        print("defaults bool for key: UserLogin -> \(defaults.boolForKey(loginKey))")
        print("defaults bool for key: UserForgotLogin -> \(defaults.boolForKey(forgotLoginKey))")
        
        // Need a server to do logins and send emails.
//        let registrationStep = ORKRegistrationStep.init(identifier: "RegistrationStep", title: "Registration", text: "Please set up an account")
//        let task = ORKOrderedTask.init(identifier:"Registration", steps: [registrationStep])
//        let registrationViewController = ORKTaskViewController.init(task: task, taskRunUUID: nil)
//        registrationViewController.delegate = self
//        self.presentViewController(registrationViewController, animated: true, completion: nil)

          // This code is for consent
//        if defaults.boolForKey(defaultsConsentKey) == false{
//            let taskViewController = ORKTaskViewController(task: Consent, taskRunUUID: nil)
//            taskViewController.delegate = self
//            self.presentViewController(taskViewController, animated: true, completion: nil)
//        }
//        else{
//            startButton.hidden = false
//            greetingLabel.hidden = false
//            headingLabel.hidden = false
//        }
        
        
        // Is the passcode already stored in the keychain
        if PasscodeViewController.isPasscodeStoredInKeychain() == true{
            print("Passcode is stored in the keychain")
            let userIsLoggedIn = defaults.boolForKey(loginKey)
            let userForgotLogin = defaults.boolForKey(forgotLoginKey)
            startButton.hidden = true
            greetingLabel.hidden = true
            headingLabel.hidden = true
            
            if !userIsLoggedIn == true{
                print("User must log in")
                if userForgotLogin == true{
                    print("User forgot their login passcode")
                    startButton.hidden = false
                    greetingLabel.hidden = false
                    headingLabel.hidden = false
                }
                else{
                    print("User did not forget their login and their login is in the keychain")
                    let passcodeViewController = ORKPasscodeViewController.passcodeAuthenticationViewControllerWithText("After Authentication you will be Able to Enter the Application", delegate: self)
                    self.presentViewController(passcodeViewController, animated: true, completion: nil)
                    startButton.hidden = true
                    greetingLabel.hidden = true
                    headingLabel.hidden = false
                }
            }
            else{
                print("User is logged in")
                startButton.hidden = false
                greetingLabel.hidden = false
                headingLabel.hidden = false
            }

        }
        else{
            // Passcode step for creating a new passcode
            let task: ORKOrderedTask = ORKOrderedTask.init(identifier: "PassCodeStep", steps: [passcodeStep])
            let controller: ORKTaskViewController = ORKTaskViewController.init(task: task, taskRunUUID: nil)
            controller.delegate = self
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        //Handle results with taskViewController.result
        
//        defaults.setBool(true, forKey: defaultsConsentKey)
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Upon completion dismiss the current passcode view controller.
    func passcodeViewControllerDidFinishWithSuccess(viewController: UIViewController) {
        print("Passcode authentication succeeded!")
        defaults.setBool(true, forKey: loginKey)
        viewController.dismissViewControllerAnimated(true, completion: nil)
        headingLabel.hidden = false
        greetingLabel.hidden = false
        startButton.hidden = false
    }
    
    // User fails authentication
    func passcodeViewControllerDidFailAuthentication(viewController: UIViewController) {
        print("Passcode authentication failed")
    }
    
    // If the user presses the cancel button
    func passcodeViewControllerDidCancel(viewController: UIViewController) {
        print("Cancel button tapped")
    }
    
    // If the user forgot their passcode present them with a way to create a new passcode
    func passcodeViewControllerForgotPasscodeTapped(viewController: UIViewController) {
        print("Forgot passcode tapped")
        if (PasscodeViewController.isPasscodeStoredInKeychain() == true){
            let forgotPasscodeController = ORKPasscodeViewController.passcodeEditingViewControllerWithText("Enter A Passcode that you will easily remember", delegate: self, passcodeType: .Type4Digit)
            defaults.setBool(true, forKey: forgotLoginKey)
            self.dismissViewControllerAnimated(true, completion: nil)
            self.presentViewController(forgotPasscodeController, animated: false, completion: nil)
        }
    }
    
    func passcodeViewControllerTextForForgotPasscode(viewController: UIViewController) -> String {
        return "Forgot your passcode?"
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         //Get the new view controller using segue.destinationViewController.
//         //Pass the selected object to the new view controller.
//    }
    

}
