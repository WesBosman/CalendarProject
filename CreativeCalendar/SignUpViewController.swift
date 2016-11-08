//
//  SignUpViewController.swift
//  CreativeCalendar
//
//  Created by Wes Bosman on 11/7/16.
//  Copyright © 2016 Wes Bosman. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var signUpGreetingLabel: UILabel!
    @IBOutlet weak var signUpEmailAddress: UITextField!
    @IBOutlet weak var signUpPassword: UITextField!
    @IBOutlet weak var signUpPasswordConfirm: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backToLoginButton: UIButton!
    let defaults = UserDefaults.standard
    let emailKey = "Email"
    let passKey = "Password"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func userSignedUp(_ sender: AnyObject) {
        
        if let email = signUpEmailAddress.text{
            print("Email is not null \(email)")
            // Set Email in User Defaults
            defaults.set(email, forKey: emailKey)
            
            if let password  = signUpPassword.text{
                print("Password is not null \(email)")
                
                if let confirmPassword = signUpPasswordConfirm.text{
                    print("Confirm Password is not null \(confirmPassword)")
                    
                    if(password == confirmPassword){
                        // Set Password in User Defaults
                        defaults.set(password, forKey: passKey)
                        print("Password and confirm password matches")
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            print("User Created")                    
                        })
                    }
                }
                else{
                    print("Confirm Password is null")
                }
            }
            else{
                print("Password is null")
            }
        }
        else{
            print("Email is null")
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
