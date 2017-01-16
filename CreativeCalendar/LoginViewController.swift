//
//  LoginViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 11/7/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit
import FirebaseAuth
import LocalAuthentication

class LoginViewController: UIViewController {
    
    @IBOutlet weak var appHeaderLabel: UILabel!
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginMessage: UILabel!
    
    let defaults = UserDefaults.standard
    let emailKey = "Email"
    let passKey  = "Password"
    
    // What if they don't have WIFI Access?!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the error message label
        loginMessage.text = "This is where errors will appear"
        loginMessage.lineBreakMode = .byWordWrapping
        loginMessage.numberOfLines = 0
        loginMessage.isHidden = true
        
        // If the user's email is stored in user defaults
        if let email = defaults.object(forKey: emailKey) as? String{
            loginEmail.text = email
        }
        
        // If the user's email is stored by firebase
        if let userEmail = FIRAuth.auth()?.currentUser?.email{
            loginEmail.text = userEmail
        }
        
        // If User is already logged in let them into the application
        FIRAuth.auth()?.addStateDidChangeListener({
            (auth, user) in
            
            if let user = auth.currentUser {
                // User is signed in.
                print("User is Signed In")
                
                if let name = user.displayName{
                    print("User Name \(name)")
                }
                
                if let email = user.email{
                    print("Email \(email)")
                }
                
                //self.performSegue(withIdentifier: "Login", sender: nil)
                
            } else {
                // No user is signed in.
                print("User is not Signed In")
                
            }
        })
        
        // Testing Local Authentication
//        locallyAuthenticateUser()
        
    }
    
    @IBAction func userLoginButtonPressed(_ sender: AnyObject) {
        print("User Pressed the Login Button")
            
        if let auth = FIRAuth.auth(){
                
            if let email = loginEmail.text, let password = loginPassword.text{
                    
                // user has access to Internet
                auth.signIn(withEmail: email , password: password , completion:
                    { (user, error) in
                            
                        // Let us know which user is trying to login
                        if let user = user{
                            print("")
                            print("User Email = \(user.email!)")
                            print("")
                            
                            // Perform Segue
                            self.performSegue(withIdentifier: "Login", sender: sender)
                                
                        }
                            
                        // Catch any errors
                        if let error = error{
                            print("")
                            print("\(error.localizedDescription)")
                            print("")
                            
                            self.loginMessage.text = error.localizedDescription
                            self.loginMessage.isHidden = false
                            
                            // Try to locally authenticate the user 
                            // If there is an error logging in
                            // self.locallyAuthenticateUser()
                        }
                })
            }
        }
    }
    
    
    
    func showPasswordAlert(){
        let passwordAlert: UIAlertController = UIAlertController(title: "Password", message: "Enter Password", preferredStyle: .alert)
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action: UIAlertAction) -> Void in
            passwordAlert.dismiss(animated: true, completion: nil)
        })
        
        let submitAction: UIAlertAction = UIAlertAction(title: "Submit", style:.default, handler: {(action: UIAlertAction) -> Void in
            
        })
        
        passwordAlert.addTextField(configurationHandler: {(textField: UITextField) -> Void in
            
        })
        
        passwordAlert.addTextField(configurationHandler: {(textField:UITextField) -> Void in
            
        })
        
        passwordAlert.addAction(cancelAction)
        passwordAlert.addAction(submitAction)
        
        self.present(passwordAlert, animated: true, completion: nil)
    }
    
    func showNoTouchIDAlert(){
        let alertController: UIAlertController = UIAlertController(title: "No Touch ID Detected", message: "Sorry, your device does not support fingerprint identification", preferredStyle: .alert)
        let okAction: UIAlertAction = UIAlertAction(title: "Dismiss", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // Local Authentication
    func locallyAuthenticateUser(){
        let context: LAContext = LAContext()
        var authError: NSError?
        
        // Check to see if touch ID can be used
        if (context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError)){
            // If Touch ID can be used then use it
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                   localizedReason: "Please Scan Your Finger to Proceed",
                                   reply: { //[unowned self]
                                    (success, error) -> Void in
            if(success){
                 print("Success logging in using touch ID")
                 self.performSegue(withIdentifier: "Login", sender: self)
                }
            else{
                print("Error logging in using touch ID")
                                        
                // Catch any errors
                print("Error = \(error!.localizedDescription)")
                print("Auth Error = \(authError?.code)")
                                        
                if let err = authError{
                    // Check the error codes and act accordingly
                    switch(err.code){
                        case LAError.appCancel.rawValue:
                            print("App Cancel Error")
                        
                        case LAError.authenticationFailed.rawValue:
                            print("Authentication Failed Error")
                                                
                        case LAError.invalidContext.rawValue:
                            print("Invalid Context Error")
                                                
                        case LAError.passcodeNotSet.rawValue:
                            print("Passcode has not been set error")
                                                
                        case LAError.systemCancel.rawValue:
                            print("System Cancel")
                                                
                        case LAError.touchIDLockout.rawValue:
                            print("Touch ID Lockout Error")
                                                
                        case LAError.touchIDNotEnrolled.rawValue:
                            print("Touch ID Not Enrolled Error")
                                                
                        case LAError.touchIDNotAvailable.rawValue:
                            print("Touch ID Not Available")
                                                
                        case LAError.userCancel.rawValue:
                            print("User Cancel Error")
                                                
                        default:
                            print("Default Case")
                                                
                        }
                    }
                }
            })
        }
        // Touch ID Can not be used have to figure out another method...
        else{
            showNoTouchIDAlert()
            return
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        print("Segue Identifier \(segue.identifier)")
        if segue.identifier == "Login"{
            
        }
    }
}
