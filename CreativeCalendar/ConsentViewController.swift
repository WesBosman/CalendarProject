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


class ConsentViewController: UIViewController, ORKTaskViewControllerDelegate {
    var consentHasBeenGiven = false
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        startButton.hidden = true
        greetingLabel.hidden = true
        greetingLabel.text = "Thank you for completing the consent form for this study.\nPlease press the start button to enter the application."
        greetingLabel.lineBreakMode = .ByWordWrapping
        greetingLabel.numberOfLines = 0
        startButton.layer.borderWidth = 2
        startButton.layer.borderColor = UIColor.blackColor().CGColor
        startButton.layer.cornerRadius = 10
    }
    
    override func viewDidAppear(animated: Bool) {
        if consentHasBeenGiven == false{
            let taskViewController = ORKTaskViewController(task: Consent, taskRunUUID: nil)
            taskViewController.delegate = self
            self.presentViewController(taskViewController, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startButtonPressed(sender: AnyObject) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRunUUID: nil)
        taskViewController.delegate = self
        presentViewController(taskViewController, animated: true, completion: nil)
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        //Handle results with taskViewController.result
        consentHasBeenGiven = true
        startButton.hidden = false
        greetingLabel.hidden = false
        taskViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//         //Get the new view controller using segue.destinationViewController.
//         //Pass the selected object to the new view controller.
//    }
    

}
