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
        .overview,
        .dataGathering,
        .privacy,
        .dataUse,
        .timeCommitment,
        .studySurvey,
        .studyTasks,
        .withdrawing
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
    
    let reviewConsentStep = ORKConsentReviewStep(identifier: "ConsentReviewStep", signature: signature, in: consentDocument)
    
    reviewConsentStep.text = "Review Consent!"
    reviewConsentStep.reasonForConsent = "Consent to join study"
    
    steps += [reviewConsentStep]
    
    return ORKOrderedTask(identifier: "ConsentTask", steps: steps)
}


class ConsentViewController: UIViewController, ORKTaskViewControllerDelegate, ORKPasscodeDelegate {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    let defaults = UserDefaults.standard
    let defaultsConsentKey = "UserConsent"
    let loginKey = "UserLogin"
//    let forgotLoginKey = "UserForgotLogin"
    let passcodeStep:ORKPasscodeStep = ORKPasscodeStep.init(identifier: "PassCode")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        clearAllUserDefaults()
        
        // Do any additional setup after loading the view.
        passcodeStep.passcodeType = ORKPasscodeType.type4Digit
        startButton.isHidden = true
        headingLabel.numberOfLines = 0
        headingLabel.lineBreakMode = .byWordWrapping
        greetingLabel.isHidden = true
        greetingLabel.lineBreakMode = .byWordWrapping
        greetingLabel.numberOfLines = 0
        greetingLabel.text = "Thank you for completing the consent form for this study.\nPlease press the start button to enter the application."
        startButton.layer.cornerRadius = 30
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor().defaultButtonColor.cgColor
        startButton.setTitleColor(UIColor.white, for: UIControlState())
        startButton.backgroundColor = UIColor().defaultButtonColor
        
        // Make the user login everytime they enter the application
        defaults.removeObject(forKey: loginKey)
    }
    
    // Clear all NSUser Defaults
    func clearAllUserDefaults(){
        //The below two lines of code can clear out NSUser Defaults
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Print the values of stored login booleans
        print("defaults bool for key: UserConsent -> \(defaults.bool(forKey: defaultsConsentKey))")
        print("defaults bool for key: UserLogin -> \(defaults.bool(forKey: loginKey))")
        
         startButton.isHidden = false
        
//        startButton.isHidden = true
//        greetingLabel.isHidden = true
//        headingLabel.isHidden = true
//        
//        // Is the passcode already stored in the keychain
//        if PasscodeViewController.isPasscodeStoredInKeychain() == true{
//            print("Passcode is stored in the keychain")
//            let userIsLoggedIn = defaults.bool(forKey: loginKey)
//            startButton.isHidden = true
//            greetingLabel.isHidden = true
//            headingLabel.isHidden = true
//            
//            if !userIsLoggedIn == true{
//                print("User must log in. Authentication Step")
//                let passcodeViewController = ORKPasscodeViewController.passcodeAuthenticationViewController(withText: "After Authentication you will be Able to Enter the Application", delegate: self)
//                self.present(passcodeViewController, animated: true, completion: nil)
//                startButton.isHidden = true
//                greetingLabel.isHidden = true
//                headingLabel.isHidden = true
//            }
//            else{
//                print("User is logged in")
//                startButton.isHidden = false
//                greetingLabel.isHidden = false
//                headingLabel.isHidden = false
//            }
//
//        }
//        else{
//            // Passcode step for creating a new passcode
//            let task: ORKOrderedTask = ORKOrderedTask.init(identifier: "PassCodeStep", steps: [passcodeStep])
//            let controller: ORKTaskViewController = ORKTaskViewController.init(task: task, taskRun: nil)
//            controller.delegate = self
//            self.present(controller, animated: true, completion: nil)
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        //Handle results with taskViewController.result
        
        //        defaults.setBool(true, forKey: defaultsConsentKey)
        taskViewController.dismiss(animated: true, completion: nil)
    }
    
    // Upon completion dismiss the current passcode view controller.
    func passcodeViewControllerDidFinish(withSuccess viewController: UIViewController) {
        print("Passcode authentication succeeded!")
        defaults.set(true, forKey: loginKey)
        viewController.dismiss(animated: true, completion: nil)
        headingLabel.isHidden = false
        greetingLabel.isHidden = false
        startButton.isHidden = false
    }
    
    // User fails authentication
    func passcodeViewControllerDidFailAuthentication(_ viewController: UIViewController) {
        print("Passcode authentication failed")
    }
    
    // If the user presses the cancel button
    func passcodeViewControllerDidCancel(_ viewController: UIViewController) {
        print("Cancel button tapped")
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         //Get the new view controller using segue.destinationViewController.
//         //Pass the selected object to the new view controller.
//    }
    

}
