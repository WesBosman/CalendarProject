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
    @IBOutlet weak var forgotPasswordGreetingLabel: UILabel!
    @IBOutlet weak var forgotPasswordEmail: UITextField!
    @IBOutlet weak var forgotSubmitButton: UIButton!
    @IBOutlet weak var backToLoginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func forgotPasswordSubmitButtonPressed(_ sender: AnyObject) {
        if let auth = FIRAuth.auth(){
            if let email = forgotPasswordEmail.text{
                print("Forgot Password Email \(email)")
            
                auth.sendPasswordReset(withEmail: email, completion: {(error) in
                
                    if(error != nil){
                        print("Error \(error.debugDescription)")
                    
                    
                    }
                    else{
                        print("Email sent")
                    }
                
                })
            }
        }
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
