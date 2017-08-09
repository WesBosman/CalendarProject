//
//  ForgotPasswordViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 11/7/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var forgotPasswordHeader: UILabel!
    @IBOutlet weak var forgotPasswordMessage: UILabel!
    @IBOutlet weak var forgotPasswordTextField: UITextField!
    @IBOutlet weak var sendEmailButton: UIButton!
    
    let defaults = UserDefaults.standard
    let emailKey = "Email"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We could keep a record of user emails in the database to 
        // help us securely understand who should be receiving the email.

        // Set up the header text.
        forgotPasswordHeader.text = "Please enter your email address and we will send you a message allowing you to reset your password. Note you must be connected to the internet to send a password reset email. Otherwise, please contact Dr. Lageman for help reseting your password."
        forgotPasswordHeader.lineBreakMode = .byWordWrapping
        forgotPasswordHeader.numberOfLines = 0
        
        // Hide the forgot password message until there is an error
        forgotPasswordMessage.isHidden = true
        forgotPasswordMessage.lineBreakMode = .byWordWrapping
        forgotPasswordMessage.numberOfLines = 0
        
        // Set the send email button attributes
        sendEmailButton.backgroundColor = UIColor.flatSkyBlue
        sendEmailButton.setTitleColor(UIColor.white, for: .normal)
        sendEmailButton.layer.cornerRadius = 5
        
        // If the user has an account already then give the email of that account
        if let email = defaults.object(forKey: emailKey) as? String{
            forgotPasswordTextField.text = email
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendPasswordResetEmailButtonPressed(_ sender: AnyObject) {
        
        if let auth = FIRAuth.auth(){
            if let email = forgotPasswordTextField.text{
                // Use an alert to help let the user confirm 
                // they are sending the email to the correct address
                let alert = UIAlertController(title: "Confirmation", message: "Are you sure we should send a password reset email to the following address: \(email)", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {(action: UIAlertAction) in
                    
                    // Attempting to send a password reset email
                    print("Forgoten Password Email \(email)")
                    auth.sendPasswordReset(withEmail: email, completion: {
                        (error) in
                        // Let the user see the error
                        if let error = error{
                            self.forgotPasswordMessage.text = error.localizedDescription
                            self.forgotPasswordMessage.isHidden = false
                        }
                            // Let the user know the password reset email was sent
                        else{
                            self.forgotPasswordMessage.text = "Sent a password reset email to the following address: \(email). Please login while connected to the internet."
                            self.forgotPasswordMessage.isHidden = false
                            self.forgotPasswordTextField.text = nil
                        }
                    })
                    
                })
                
                // No Action
                let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                // Present the alert
                alert.addAction(yesAction)
                alert.addAction(noAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
