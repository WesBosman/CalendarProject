//
//  SignUpViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 11/7/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit
import FirebaseAuth
import Locksmith

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpHeaderLabel: UILabel!
    @IBOutlet weak var signUpMessageLabel: UILabel!
    @IBOutlet weak var signUpEmailAddress: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpConfirmPassword: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up the header label
        signUpHeaderLabel.text = "Please Enter a valid email address and a password that is atleast 8 characters long."
        signUpHeaderLabel.lineBreakMode = .byWordWrapping
        signUpHeaderLabel.numberOfLines = 0
        
        // Set up the message label
        signUpMessageLabel.lineBreakMode = .byWordWrapping
        signUpMessageLabel.numberOfLines = 0
        signUpMessageLabel.isHidden = true
        
        // Set sign up button attributes
        signUpButton.backgroundColor = UIColor.flatSkyBlue
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.layer.cornerRadius = 5
        
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: AnyObject) {
        // Get the email address from the text box
        if let email = signUpEmailAddress.text{
            // Get the password and confirmed password from their textboxes
            if let password = signUpPassword.text,
                let confirmPassword = signUpConfirmPassword.text{
                
                // If the passwords match and they are both at least 8 chars
                if (password == confirmPassword &&
                    (password.characters.count >= 8 &&
                        confirmPassword.characters.count >= 8)) {
                
                    FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: {
                        
                        (user, error) in
                        
                        if let error = error{
                            self.signUpMessageLabel.isHidden = false
                            self.signUpMessageLabel.text = error.localizedDescription
                        }
                        
                        if let user = user{
                            self.signUpMessageLabel.isHidden = false
                            
                            // Get the users email address
                            if let email = user.email{
                                // Notify the user that an account has been created successfully
                                self.signUpMessageLabel.text = "Created an account with the following email address: \(email)"
                                UserDefaults.standard.set(true, forKey: "signedUp")
                                
                                // Set the fields back to nil
                                self.signUpEmailAddress.text = nil
                                self.signUpPassword.text = nil
                                self.signUpConfirmPassword.text = nil
                                
                                // Try to store the user data in the keychain using locksmith
                                do{
                                    try Locksmith.saveData(data: [user.email! : password], forUserAccount: user.email!)
                                    print("Saved data to locksmith")
                                }
                                catch{
                                    print("Error saving data to Locksmith: \(error.localizedDescription)")
                                }
                            }
                        }
                    
                    })
                }
                else{
                    // If the passwords do not match
                    if (confirmPassword != password){
                        self.signUpMessageLabel.isHidden = false
                        self.signUpMessageLabel.text = "Sorry, Passwords do not match. Try again"
                    }
                    // If the passwords are not long enough in length
                    else if (  password.characters.count < 8 && confirmPassword.characters.count < 8){
                        self.signUpMessageLabel.isHidden = false
                        self.signUpMessageLabel.text = "The passwords must be at least 8 characters in length."
                    }
                    // Clear the password and confirm password text fields
                    self.signUpPassword.text = nil
                    self.signUpConfirmPassword.text = nil
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
