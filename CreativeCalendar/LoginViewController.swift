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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let auth = FIRAuth.auth()
        //let user = auth?.currentUser
        
        auth?.addStateDidChangeListener({ auth, user in
            if let user = auth.currentUser {
                // User is signed in.
                print("User is Signed In")
                
                if let name = auth.currentUser?.displayName{
                    print("User Name \(name)")
                }
                
                if let email = auth.currentUser?.email{
                    print("Email \(email)")
                }
                
                
                
            } else {
                // No user is signed in.
                print("User is not Signed In")
                
            }
        })
        
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
