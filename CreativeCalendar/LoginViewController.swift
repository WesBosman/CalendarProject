//
//  LoginViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 11/7/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginGreetingLabel: UILabel!
    @IBOutlet weak var loginEmail: UITextField!
    @IBOutlet weak var loginPassword: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    let defaults = UserDefaults.standard
    let emailKey = "Email"
    let passKey  = "Password"
    
    // What if they don't have WIFI Access?!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // If User is already logged in let them into the application
        FIRAuth.auth()?.addStateDidChangeListener({ auth, user in
            if let user = auth.currentUser {
                // User is signed in.
                print("User is Signed In")
                //self.performSegue(withIdentifier: "Login", sender: nil)
                
                if let name = user.displayName{
                    print("User Name \(name)")
                }
                
                if let email = user.email{
                    print("Email \(email)")
                }
                
            } else {
                // No user is signed in.
                print("User is not Signed In")
                
            }
        })
        
    }
    
    @IBAction func userLoginPressed(_ sender: AnyObject) {
        print("User Pressed the Login Button")
        if let auth = FIRAuth.auth(){
            
            if let email = loginEmail.text{
                
                if let password = loginPassword.text{
                    
                    // Is user has access to Internet
                    auth.signIn(withEmail: email , password: password , completion: { user, error in
                        print("User is logging in")
                        self.performSegue(withIdentifier: "Login", sender: sender)
                        
                        if(error != nil){
                            print("Error Logging in \(error.debugDescription)")
                            // User May not have access to the Internet
                            // Try to login using user defaults
                            
                            let e = self.defaults.object(forKey: self.emailKey) as! String
                            
                            let p = self.defaults.object(forKey: self.passKey) as! String
                            
                            if(password == p && email == e){
                                print("Password : \(password) Email : \(email)")
                                self.performSegue(withIdentifier: "Login", sender: sender)
                            }
                            
                        }
                    })
                }
            }
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
