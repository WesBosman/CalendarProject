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
import Locksmith

class LoginViewController: UIViewController {
    
    @IBOutlet weak var appHeaderLabel: UILabel!
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginMessage: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    

    var userEmail: String = String()
    // What if they don't have WIFI Access?!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide the error message label
        loginMessage.text = "This is where errors will appear"
        loginMessage.lineBreakMode = .byWordWrapping
        loginMessage.numberOfLines = 0
        loginMessage.isHidden = true
        
        loginButton.backgroundColor = UIColor.flatSkyBlue
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.layer.cornerRadius = 5
        
        forgotPasswordButton.backgroundColor = UIColor.flatSkyBlue
        forgotPasswordButton.setTitleColor(UIColor.white, for: .normal)
        forgotPasswordButton.layer.cornerRadius = 5
        
        signupButton.backgroundColor = UIColor.flatSkyBlue
        signupButton.setTitleColor(UIColor.white, for: .normal)
        signupButton.layer.cornerRadius = 5
        
        
        let notFirstRun  = UserDefaults.standard.bool(forKey: "firstLaunchKey")
        let userSignedUp = UserDefaults.standard.bool(forKey: "signedUp")
        
        // If the application has been run for the first time then delete what is in the keychain
        if(notFirstRun == false){
            if let userEmail = FIRAuth.auth()?.currentUser?.email{
                do{
                    print("Deleting Data for User Account \(userEmail)")
                    try Locksmith.deleteDataForUserAccount(userAccount: userEmail)
                }
                catch let error {
                    print("Error deleting keychain data for user \(userEmail)")
                    print("Error \(error.localizedDescription)")
                }
            }
            else{
                    print("Could not get user email")
            }
            // Set the user defaults to true since the app has launched before
            UserDefaults.standard.set(true, forKey: "firstLaunchKey")
        }

        
        // If the user's email is stored in firebase then fill in the email text field for them
        if (userSignedUp){
            loginEmail.text = userEmail
            signupButton.isEnabled = false
            signupButton.isHidden  = true
            print("User Signed Up")
        }
        else{
            signupButton.isEnabled = true
            signupButton.isHidden = false
            print("User Not Signed Up")
        }
        
        // Testing Local Authentication
//        locallyAuthenticateUser()
        
        // If User is already logged in let them into the application
        FIRAuth.auth()?.addStateDidChangeListener({
            (auth, user) in
            
            if let user = auth.currentUser {
                // User is signed in.
                print("User is Signed In")
                
                if let email = user.email{
                    print("Email \(email)")
                    self.userEmail = email
                }
                
                // Disable the sign up button
                self.signupButton.isEnabled = false
                self.signupButton.backgroundColor = UIColor.lightGray
                
            } else {
                // No user is signed in.
                print("User is not Signed In")
                
                // Enable the sign up button
                self.signupButton.isEnabled = true
                self.signupButton.backgroundColor = UIColor.flatSkyBlue
                
            }
        })
    }
    
    @IBAction func userLoginButtonPressed(_ sender: AnyObject) {
        print("User Pressed the Login Button")
            
        if let auth = FIRAuth.auth(){
                
            if let email = loginEmail.text, let password = loginPassword.text{
                    
                // user has access to Internet
                auth.signIn(withEmail: email ,
                            password: password ,
                            completion:
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
                            
                            
                            // Try to compare the login info to what is in the keychain
                            let dictionary = Locksmith.loadDataForUserAccount(userAccount: email)
                            
                            // Check the login locally
                            if(self.userEmail == email){
                                if let userPassword = dictionary?[email] as?String{
                                
                                    if(userPassword == password){
                                        self.performSegue(withIdentifier: "Login", sender: sender)
                                    }
                                    else{
                                        self.loginMessage.text = "Password does not match the one stored on this device"
                                        self.loginMessage.isHidden = false
                                    }
                                }
                            }
                            //  If the local login fails then show the error
                            else{
                                self.loginMessage.text = error.localizedDescription
                                self.loginMessage.isHidden = false
                            }
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
        let okAction: UIAlertAction = UIAlertAction(title: "Dismiss",
                                                    style: .cancel,
                                                    handler: nil)
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
                                   reply: {
                                    [unowned self]
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
                        
                        case LAError.userFallback.rawValue:
                            print("User FallBack authorization mechanism")
                            self.userFallBack()
                        
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
    
    func userFallBack(){
        let context: LAContext = LAContext()
        var authError: NSError?
        
        if(context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError)){
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "No Touch ID being used", reply: {
                (success, error) in Void()
                if (success){
                    print("Successfully authenticated user using device lock code")
                }
                else{
                    print("Error while trying to get user device lock code")
                }
            })
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
